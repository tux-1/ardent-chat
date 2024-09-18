import 'dart:async';

import 'package:ardent_chat/common/constants/routes.dart';
import 'package:ardent_chat/screens/verification/widgets/log_out_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/resend_email_button.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        FirebaseAuth.instance.currentUser?.reload();
        if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
          timer.cancel();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, Routes.homeScreen);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Logo3-Transparent.png",
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Verify your email address',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: 'Welcome to ',
                  style: textTheme.headlineSmall,
                ),
                TextSpan(
                  text: 'Ardent Chat',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Text(
              "A verification email has been sent to your registered email address.\nYou will be automatically transferred after verification.",
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Haven\'t got an email?',
                ),
                ResendEmailButton(),
              ],
            ),
            const LogOutButton(),
          ],
        ),
      ),
    );
  }
}
