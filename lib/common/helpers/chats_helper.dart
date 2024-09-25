import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/chat_model.dart';
import '../models/contact.dart';
import '../models/message_type.dart';

/// Global constant to access the chats data stored in our `FirebaseFirestore`
class ChatsHelper {
  static Future<Contact> _getContactData(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data() ?? {};

    return Contact(
      id: userId,
      name: data['username'] ?? 'Unknown',
      profileImageUrl: data['profileImageUrl'] ?? '',
      isOnline: data['isOnline'] ?? false,
    );
  }

  static Stream<List<Chat>> getChatsStream() {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .switchMap((querySnapshot) {
      // For each chat document, listen to its messages and combine into a list
      final List<Stream<Chat>> chatStreams =
          querySnapshot.docs.map((doc) async* {
        final chatData = doc.data();

        // Get the other participant's ID
        final participants = List<String>.from(chatData['participants'] ?? []);
        final otherParticipantId = participants
            .firstWhere((id) => id != currentUserId, orElse: () => '');

        // Fetch other participant's contact data
        final Contact contact = await _getContactData(otherParticipantId);

        // Now we need to subscribe to changes in the messages sub-collection
        yield* _listenToLastMessage(doc, contact, currentUserId);
      }).toList();

      // Combine all streams into a single Stream<List<Chat>>
      return CombineLatestStream.list(chatStreams);
    });
  }

  static Stream<Chat> _listenToLastMessage(
      DocumentSnapshot<Map<String, dynamic>> doc,
      Contact contact,
      String currentUserId) {
    return doc.reference
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots()
        .asyncMap((messageSnapshot) async {
      if (messageSnapshot.docs.isNotEmpty) {
        final lastMessageData = messageSnapshot.docs.first.data();

        // Message information
        final MessageType lastMessageType =
            MessageType.values[lastMessageData['messageType'] ?? 0];
        final String lastMessageText = lastMessageData['text'] ?? '';
        final Timestamp lastMessageTime =
            lastMessageData['time'] ?? Timestamp.now();

        // Fetch all messages and filter those not seen by the current user
        final allMessagesQuery =
            await doc.reference.collection('messages').get();
        final unreadMessages = allMessagesQuery.docs.where((messageDoc) {
          final seenBy = List<String>.from(messageDoc.data()['seenBy'] ?? []);
          return !seenBy.contains(currentUserId);
        }).toList();

        // Determine unread count by counting the filtered messages
        final int unreadCount = unreadMessages.length;

        // Return the updated Chat object with the contact info and unread count
        return Chat(
          contact: contact,
          messageType: lastMessageType,
          text: lastMessageText,
          time: lastMessageTime,
          unreadCount: unreadCount,
        );
      } else {
        // Handle case where no messages are found
        return Chat(
          contact: contact,
          messageType: MessageType.text,
          text: '',
          time: Timestamp.now(),
          unreadCount: 0,
        );
      }
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
        'text': text,
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
