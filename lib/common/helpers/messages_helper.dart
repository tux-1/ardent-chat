import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/message.dart';

class MessagesHelper {
  // Fetch messages for a particular chat document (chatId)
  static Stream<List<Message>> fetchMessagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Message.fromJson(doc.data());
      }).toList();
    });
  }

  static Future<void> sendMessage({
    required Message msg,
    required String chatId,
  }) async {
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
}
