import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/welcome (1).png',
              fit: BoxFit.fill,
            ),
            Spacer(flex: 2),
            Text(
              'Enjoy the new experience of chatting with global friends',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1),
            Text(
              'Connect people around the world for free',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 50),
                backgroundColor: Color(0xFF090057),
              ),
              onPressed: () async {
                var box = Hive.box('settings');
                await box.put('is', true);
                Navigator.of(context).pushNamed('homeScreen');
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Get Started',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Spacer(flex: 1),
            Text('Powered by الأكيلة',
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
