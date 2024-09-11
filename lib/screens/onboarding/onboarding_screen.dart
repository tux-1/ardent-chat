import 'package:ardent_chat/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
    return MaterialApp(
      title: 'ardent chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isFirstTime ? Onboarding() : Scaffold(),
    );
  }
}
