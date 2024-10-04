import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contact.dart'; // Assuming the Contact model is defined in this path

class FriendsHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search for users by username
  Future<List<Contact>> searchByUsername(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();

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
    final isAlreadyAdded = await isAlreadyFriends(friendId);
    if (currentUserId != null && friendId.isNotEmpty && !isAlreadyAdded) {
      // Create a new chat document between the current user and the friend
      final chatDocRef = _firestore.collection('chats').doc();

      // Set the participants (current user and the friend) in the chat document
      await chatDocRef.set({
        'participants': [currentUserId, friendId],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Check if the user is already friends with the specified friendId
  Future<bool> isAlreadyFriends(String friendId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null && friendId.isNotEmpty) {
      final chatQuerySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      // Check if any chat contains both users
      for (var chatDoc in chatQuerySnapshot.docs) {
        final participants = chatDoc['participants'] as List<dynamic>;
        if (participants.contains(friendId)) {
          return true; // Already friends
        }
      }
    }
    return false; // Not friends
  }
}
