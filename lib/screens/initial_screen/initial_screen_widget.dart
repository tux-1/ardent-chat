import 'package:ardent_chat/screens/login_screen/login_screen.dart';
import 'package:ardent_chat/screens/onboarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitialScreenWidget extends StatefulWidget {
  const InitialScreenWidget({super.key});

  @override
  _InitialScreenWidgetState createState() => _InitialScreenWidgetState();
}

class _InitialScreenWidgetState extends State<InitialScreenWidget> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    var box = Hive.box('settings');
    bool isFirstTime = box.get('isFirstTime', defaultValue: false);
    if (isFirstTime) {
      setState(() {
        _isFirstTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_isFirstTime) {
          return const OnboardingScreen();
        }
        // Check if user is not authenticated
        else if (FirebaseAuth.instance.currentUser != null) {
          // Check if verified
          if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            // TODO: Navigate user to verification screen
          }
          // If user passes verification then should be navigated to the home page
          // TODO: Go to home page here
        }
        return const LoginScreen();
      },
    );
  }
}
