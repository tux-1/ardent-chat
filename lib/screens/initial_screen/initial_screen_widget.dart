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
          return OnboardingScreen();
        }
        // Check if user is authenticated
        else if (FirebaseAuth.instance.currentUser != null) {
          // If user is not verified send to verification screen
          if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            // TODO: Navigate user to verification screen
          }
          // TODO: If user passes verification then should be navigated to the home page
          // TODO: Go to home page here
        }
        return const Scaffold(
          body: Center(
            child: Text('Login screen ????'),
          ),
        );
      },
    );
  }
}
