import 'package:ardent_chat/common/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  String _sloganText = '';
  bool _showCursor = false; // Start with cursor hidden
  final String _completeSlogan = "WHERE CONVERSATIONS SPARK";
  int _sloganIndex = 0;
  bool _firstCharacterTyped = false; // Flag to track first character

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    // Start logo and text animations
    Future.delayed(const Duration(milliseconds: 3000), () {
      // Start typing effect after animations complete
      _startTypingEffect();
    });
  }

  Future<void> _startTypingEffect() async {
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (mounted) {
        if (_sloganIndex < _completeSlogan.length) {
          setState(() {
            _sloganText += _completeSlogan[_sloganIndex];
            _sloganIndex++;

            // Check if the first character has been typed
            if (!_firstCharacterTyped) {
              _firstCharacterTyped = true;
              _blinkCursor();
            }
          });
        } else {
          Navigator.of(context)
              .pushReplacementNamed(Routes.initialScreenWidget);
          timer.cancel();
          _blinkCursor();
        }
      }
    });
  }

  void _blinkCursor() {
    Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo animation (Fade in and move left)
            Image.asset(
              'assets/images/Logo3.png',
              width: 85,
            )
                .animate()
                .fadeIn(duration: 1000.ms)
                .moveX(begin: 100, end: -17, duration: 1000.ms, delay: 1000.ms),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Ardent-Chat-Text.png',
                  width: 200,
                  // "ARDENT CHAT" text animation (Fade in after the logo moves)
                ).animate().fadeIn(duration: 1000.ms, delay: 1600.ms),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0, top: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _sloganText,
                        style: const TextStyle(
                          fontSize: 8,
                          letterSpacing: 2,
                          wordSpacing: 1,
                          color: Color(0xFF090057),
                        ),
                      ),
                      // Blinking cursor
                      AnimatedOpacity(
                        opacity: _showCursor ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Text(
                          '|',
                          style: TextStyle(
                            fontSize: 8,
                            color: Color(0xFF090057),
                          ),
                        ),
                      ),
                    ],
                    // Typing effect for the slogan with a blinking cursor
                  ).animate().fadeIn(duration: 1000.ms, delay: 1000.ms),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
