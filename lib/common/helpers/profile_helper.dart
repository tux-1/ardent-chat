import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/contact.dart';
import 'chats_helper.dart';

/// Global constant to access profile information
class ProfileHelper {
  static Future<Contact> getProfileInfo() async {
    return await ChatsHelper.getContactData(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  static Future<void> updateProfileInfo({
    String? newUsername,
    File? newPicture,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Prepare the data to update
    final Map<String, dynamic> updatedData = {};

    // Reference to Firestore user document
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Retrieve existing profile data to check for the current profile picture URL
    final userDoc = await userDocRef.get();
    String? currentProfileImageUrl = userDoc.data()?['profileImageUrl'];

    // Upload the new picture if provided
    if (newPicture != null) {
      // Step 1: Upload the new picture
      String newProfileImageUrl =
          await _uploadProfilePicture(userId, newPicture);
      updatedData['profileImageUrl'] = newProfileImageUrl;

      // Step 2: Update Firestore with the new picture's URL
      await userDocRef.update(updatedData);

      // Step 3: Now delete the old profile picture after successfully updating Firestore
      if (currentProfileImageUrl != null && currentProfileImageUrl.isNotEmpty) {
        await _deleteOldProfilePicture(currentProfileImageUrl);
      }
    }

    // Update username if a new one is provided
    if (newUsername != null && newUsername.isNotEmpty) {
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: newUsername.toLowerCase())
          .get();

      // Check if any documents exist
      if (usernameQuery.docs.isNotEmpty) {
        throw ErrorDescription('Username is already taken.');
      }

      updatedData['username'] = newUsername.toLowerCase();
      await userDocRef.update(updatedData);
    }
  }

  static Future<void> deleteProfileImage() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // Reference to Firestore user document
    final userDocRef =
    FirebaseFirestore.instance.collection('users').doc(userId);

    // Retrieve existing profile data to check for the current profile picture URL
    final userDoc = await userDocRef.get();
    String? currentProfileImageUrl = userDoc.data()?['profileImageUrl'];

    if (currentProfileImageUrl != null && currentProfileImageUrl.isNotEmpty) {
      await _deleteOldProfilePicture(currentProfileImageUrl);
      await userDocRef.update({'profileImageUrl': FieldValue.delete()});
    }
  }

  static Future<void> _deleteOldProfilePicture(String imageUrl) async {
    try {
      // Extract the reference path from the URL and delete the file from Firebase Storage
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      debugPrint('Failed to delete old profile picture: $e');
      rethrow;
    }
  }

  static Future<String> _uploadProfilePicture(String userId, File image) async {
    // Create a reference in Firebase Storage for the new profile picture
    final ref = FirebaseStorage.instance
        .ref()
        .child('profilePictures')
        .child('$userId.jpg');

    // Upload the new image to Firebase Storage
    await ref.putFile(image);

    // Get the URL of the uploaded image
    final String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  static Future<bool> checkUsernameExists(String username) async {
    final usernameQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    if (usernameQuery.docs.first.data()['username'] == username) {
      debugPrint('Username is taken');
    }
    return usernameQuery.docs.first.data()['username'] == username;
  }
}
