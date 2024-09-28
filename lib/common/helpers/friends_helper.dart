import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contact.dart'; // Assuming the Contact model is defined in this path

class FriendsHelper {
  // Search for users by username
  Future<List<Contact>> searchByUsername(String username) async {
    // Search for users in the "users" collection whose usernames match the query
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();

    // Convert the querySnapshot to a list of Contact objects
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Contact(
        id: doc.id, // Firestore document ID will be used as the user ID
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        profileImageUrl: data['profileImageUrl'] ?? '',
        isOnline: data['isOnline'] ?? false,
      );
    }).toList();
  }

  // Add a friend by creating a new chat document
  Future<void> addFriend(String friendId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null && friendId.isNotEmpty) {
      // Create a new chat document between the current user and the friend
      final chatDocRef = FirebaseFirestore.instance.collection('chats').doc();

      // Set the participants (current user and the friend) in the chat document
      await chatDocRef.set({
        'participants': [currentUserId, friendId],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Create an empty subcollection 'messages' under this chat document
      // You don't need to add anything to the 'messages' subcollection yet
      final messagesCollectionRef = chatDocRef.collection('messages');
      
      // Optionally, you can add an empty document to initialize the collection
      // or just leave it for later when you start sending messages.
      await messagesCollectionRef.doc('initial_placeholder').set({});
    }
  }
}
