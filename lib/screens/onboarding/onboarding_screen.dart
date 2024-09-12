import 'package:ardent_chat/common/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
              'assets/images/welcome (1).png',
              fit: BoxFit.fill,
            ),
            const Spacer(flex: 2),
            const Text(
              'Enjoy the new experience of chatting with global friends',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 1),
            const Text(
              'Connect people around the world for free',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50),
                backgroundColor: Theme.of(context).primaryColor,
                shadowColor: Theme.of(context).primaryColor,
                elevation: 10,
              ),
              onPressed: () {
                var box = Hive.box('settings');
                box.put('isFirstTime', true);
                // TODO: Edit the routing to be to the authenticationScreen first
                // Navigator.of(context).pushReplacementNamed(Routes.authenticationScreen);
                Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Get Started',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            const Spacer(flex: 1),
            const Text('Powered by الأكيلة',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
