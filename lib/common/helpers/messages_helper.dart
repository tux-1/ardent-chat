import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class MessagesHelper {
  // Fetch messages for a particular chat document (chatId)
  // static Stream<List<Message>> fetchMessagesStream(String chatId) {
  //   return FirebaseFirestore.instance
  //       .collection('chats')
  //       .doc(chatId)
  //       .collection('messages')
  //       .orderBy('time', descending: true)
  //       .snapshots()
  //       .map((querySnapshot) {
  //     return querySnapshot.docs.map((doc) {
  //       return Message.fromJson(doc.data());
  //     }).toList();
  //   });
  // }
  static Stream<List<Message>> fetchMessagesStream(String chatId) {
    if (chatId.isEmpty) {
      debugPrint(chatId);
      debugPrint('Invalid chatId. Cannot fetch messages.');
      return const Stream
          .empty(); // Return an empty stream if chatId is invalid
    }

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return List<Message>.empty();
      }
      return querySnapshot.docs.map((doc) {
        return Message.fromJson(doc.data());
      }).toList();
    });
  }

  static Future<void> sendMessage({
    required Message msg,
    required String chatId,
  }) async {
    if (chatId.isEmpty) {
      debugPrint('Invalid chatId. Cannot send message.');
      return; // Exit the function if chatId is invalid
    }
    String? attachmentUrl;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final updatedSeenBy = msg.seenBy.contains(currentUserId)
        ? msg.seenBy
        : [...msg.seenBy, currentUserId];

    // If the message contains a file, upload it to Firebase Storage
    if (msg.attachmentFile != null) {
      final fileName =
          '${msg.senderId}_${DateTime.now().millisecondsSinceEpoch}';
      final ref = FirebaseStorage.instance
          .ref()
          .child('attachments')
          .child(chatId)
          .child(fileName);

      // Upload the file and get the download URL
      final uploadTask = await ref.putFile(msg.attachmentFile!);
      attachmentUrl = await uploadTask.ref.getDownloadURL();
    }

    // Create the message data for Firestore
    final messageData = {
      'senderId': msg.senderId,
      'text': msg.text,
      'messageType': msg.messageType.index,
      'attachmentUrl': attachmentUrl, // Use the uploaded URL
      'seenBy': updatedSeenBy,
      'time': msg.time,
    };

    // Save the message to Firestore
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  static Future<void> markMessagesAsSeen(String chatId) async {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (chatId.isEmpty) {
      debugPrint('Invalid chatId. Cannot fetch messages.');
      return; // Or handle the error appropriately
    }

    // Reference to the messages collection in the chat
    final messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    // Get all messages that have not been seen by the current user
    final QuerySnapshot unreadMessagesSnapshot = await messagesCollection
        .where('seenBy', whereNotIn: [
      currentUserId
    ]) // This ensures we only get unread messages
        .get();

    // Batch update messages to mark them as seen
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    for (final messageDoc in unreadMessagesSnapshot.docs) {
      batch.update(messageDoc.reference, {
        'seenBy': FieldValue.arrayUnion(
            [currentUserId]), // Add current user ID to seenBy
      });
    }

    // Commit the batch update
    await batch.commit();
  }
}
