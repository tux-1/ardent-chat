import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/chat_model.dart';
import '../models/message_type.dart';

/// Global constant to access the data stored in our `FirebaseFirestore`
class FirestoreHelper {
  /// Static function to return a stream of chats
  static Stream<List<Chat>> getChatsStream() {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FirebaseFirestore.instance
        .collection('chats')
        .where(
          'participants',
          arrayContains: currentUserId,
        ) // Get chats where current user is a participant
        .snapshots()
        .asyncMap((querySnapshot) async {
      return await Future.wait(querySnapshot.docs.map((doc) async {
        final chatData = doc.data();

        // Get the other participant's ID (assuming 1-to-1 chat, otherwise adjust accordingly)
        final List<dynamic> participants = chatData['participants'] ?? [];
        final String otherParticipantId = participants
            .firstWhere((id) => id != currentUserId, orElse: () => '');

        // Retrieve the other participant's profile information from Firestore
        final otherUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(otherParticipantId)
            .get();

        final String otherUserProfileImageUrl =
            otherUserDoc.data()?['profileImageUrl'] ?? '';
        final bool otherUserIsOnline =
            otherUserDoc.data()?['isOnline'] ?? false;

        // Fetch the last message from the messages collection
        final lastMessageQuery = await doc.reference
            .collection('messages')
            .orderBy('time', descending: true)
            .limit(1)
            .get();

        final lastMessageData = lastMessageQuery.docs.isNotEmpty
            ? lastMessageQuery.docs.first.data()
            : null;

        // Determine message type and time from the last message
        final MessageType lastMessageType = lastMessageData != null
            ? MessageType.values[lastMessageData['messageType'] ?? 0]
            : MessageType.text;
        final Timestamp lastMessageTime = lastMessageData != null
            ? lastMessageData['time'] as Timestamp
            : Timestamp.now();

        // Calculate unread count by checking the 'seenBy' field
        final List<dynamic> seenBy = chatData['seenBy'] ?? [];
        final int unreadCount = seenBy.contains(currentUserId) ? 0 : 1;

        // Build the Chat object
        return Chat(
          name: otherUserDoc.data()?['name'] ??
              'Unknown', // Use other participant's name
          messageType: lastMessageType,
          time: lastMessageTime,
          profileImageUrl:
              otherUserProfileImageUrl, // Profile picture of other participant
          isOnline: otherUserIsOnline, // Online status of other participant
          unreadCount: unreadCount, // Calculated locally
        );
      }).toList());
    });
  }

  /// Function to send a message
  static Future<void> sendMessage({
    required String chatId,
    required String text, // For text messages
    File? attachment, // File for the attachment, if any
    required MessageType messageType,
  }) async {
    try {
      String? attachmentUrl;
      final currentUser = FirebaseAuth.instance.currentUser;

      // Step 1: If there is an attachment, upload it to Firebase Storage
      if (attachment != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'chats/$chatId/${DateTime.now().millisecondsSinceEpoch}_${attachment.path.split('/').last}');

        final uploadTask = await storageRef.putFile(attachment);

        // Get the attachment's download URL after upload
        attachmentUrl = await uploadTask.ref.getDownloadURL();
      }

      // Step 2: Prepare the message data for Firestore
      final messageData = {
        'senderId': currentUser?.uid, // Dynamically set sender ID
        'text':
            text, // Text for text messages, can be empty if it's purely an attachment
        'messageType': messageType
            .index, // Store message type (e.g., text, image, video, etc.)
        'attachmentUrl': attachmentUrl, // Add attachment URL if any
        'time': FieldValue.serverTimestamp(), // Add server timestamp
        'seenBy': [currentUser?.uid], // Initialize seenBy with sender's ID
      };

      // Step 3: Store the message in Firestore under the chat's messages sub-collection
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);
    } catch (error) {
      // Handle error, could be Firebase or other errors
      if (kDebugMode) {
        print("Error sending message: $error");
      }
      throw ErrorDescription("Failed to send message.");
    }
  }
}
