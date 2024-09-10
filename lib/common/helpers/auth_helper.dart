import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Global constant to access the Authentication functions
class AuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      String message = 'An error occured, please check your credentials.';
      if (error.message != null) {
        message = error.message.toString();
      }
      throw ErrorDescription(message);
    } catch (error) {
      // Any other error
      throw ErrorDescription('An error occured');
    }
  }

  static Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Check if the username already exists
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      // If the query returns any documents, the username is already taken
      if (usernameQuery.docs.isNotEmpty) {
        throw ErrorDescription('Username is already taken.');
      }

      // Step 2: If the username is available, proceed with sign-up
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 3: Save the user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'username': username,
      });
    } on FirebaseAuthException catch (error) {
      String message = 'An error occurred, please check your credentials.';
      if (error.message != null) {
        message = error.message.toString();
      }
      throw ErrorDescription(message);
    } catch (error) {
      // Handle any other error
      if (kDebugMode) {
        print(error);
      }
      throw ErrorDescription('An error occurred');
    }
  }
}
