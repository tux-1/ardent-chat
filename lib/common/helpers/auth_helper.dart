import 'package:ardent_chat/common/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Global constant to access the Authentication functions
class AuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final navigator = Navigator.of(context);
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.emailVerified == false) {
        navigator.pushReplacementNamed(Routes.verifyAuthenticationScreen);
      } else {
        navigator.pushReplacementNamed(Routes.homeScreen);
      }
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
    required BuildContext context,
  }) async {
    try {
      final navigator = Navigator.of(context);
      // Step 1: Check if the username already exists (case-insensitive)
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .get();

      // Check if any documents exist
      if (usernameQuery.docs.isNotEmpty) {
        throw ErrorDescription('Username is already taken.');
      }

      // Step 2: If the username is available, proceed with sign-up
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      // Step 3: Save the user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'username': username.toLowerCase(),
      });
      navigator.pushReplacementNamed(Routes.verifyAuthenticationScreen);
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
      throw ErrorDescription('An error occurred: $error');
    }
  }

  static Future<void> signOut(BuildContext context) async {
    final nav = Navigator.of(context);
    await _auth.signOut();
    nav.popUntil((route) => route.isFirst);
    nav.pushReplacementNamed(Routes.loginScreen);
  }

  static Future<void> resendVerification() async {
    _auth.currentUser?.sendEmailVerification();
  }
}
