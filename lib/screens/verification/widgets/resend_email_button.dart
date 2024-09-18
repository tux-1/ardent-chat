import 'dart:async';

import 'package:ardent_chat/common/helpers/auth_helper.dart';
import 'package:flutter/material.dart';

class ResendEmailButton extends StatefulWidget {
  const ResendEmailButton({
    super.key,
  });

  @override
  State<ResendEmailButton> createState() => _ResendEmailButtonState();
}

class _ResendEmailButtonState extends State<ResendEmailButton> {
  final resendMessageTimer = Stopwatch()..start();
  Timer? _rebuildTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _rebuildTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {}); // Triggers a rebuild every second
    });
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondsPassed = resendMessageTimer.elapsed.inSeconds;
    final countdownTime = 60 - secondsPassed;
    return TextButton(
      onPressed: secondsPassed < 60
          ? null
          : () {
              // Resend
              AuthHelper.resendVerification();
              resendMessageTimer.reset();
              setState(() {});
            },
      child: Text(
        'Resend Email ${countdownTime > 0 ? 'in $countdownTime' : ''}',
      ),
    );
  }
}
