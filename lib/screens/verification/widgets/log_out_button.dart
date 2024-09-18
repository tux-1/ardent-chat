
import 'package:flutter/material.dart';

import '../../../common/helpers/auth_helper.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AuthHelper.signOut(context);
      },
      child: const Text('Log out'),
    );
  }
}
