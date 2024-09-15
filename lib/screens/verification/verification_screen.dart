import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const Text(
                '''A verification email has been sent to your registered email address.
You will be automatically transferred after verification.''',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Resend verification email logic here
                },
                child: const Text('Resend Verification Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
