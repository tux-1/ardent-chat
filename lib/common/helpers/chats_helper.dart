import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rxdart/rxdart.dart';

import '../models/chat_model.dart';
import '../models/contact.dart';
import '../models/message_type.dart';

/// Global constant to access the chats data stored in our `FirebaseFirestore`
class ChatsHelper {
  static Future<Contact> getContactData(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data() ?? {};

    return Contact(
      id: userId,
      username: data['username'] ?? 'Unknown',
      profileImageUrl: data['profileImageUrl'] ?? '',
      email: data['email'] ?? '',
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
      // If there are no chat documents, return an empty list
      if (querySnapshot.docs.isEmpty) {
        return Stream.value([]); // Emit an empty list
      }

      // For each chat document, listen to its messages and combine into a list
      final List<Stream<Chat>> chatStreams =
          querySnapshot.docs.map((doc) async* {
        final chatData = doc.data();

        // Get the other participant's ID
        final participants = List<String>.from(chatData['participants'] ?? []);
        final otherParticipantId = participants
            .firstWhere((id) => id != currentUserId, orElse: () => '');

        // Fetch other participant's contact data
        final Contact contact = await getContactData(otherParticipantId);

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
          chatId: doc.id,
          contact: contact,
          lastMessageSenderId: lastMessageData['senderId'],
          messageType: lastMessageType,
          text: lastMessageText,
          time: lastMessageTime,
          unreadCount: unreadCount,
        );
      } else {
        // Handle case where no messages are found
        return Chat(
          chatId: doc.id,
          contact: contact,
          messageType: MessageType.text,
          lastMessageSenderId: '',
          text: '',
          time: doc.data()?['createdAt'],
          unreadCount: 0,
        );
      }
    });
  }
}
