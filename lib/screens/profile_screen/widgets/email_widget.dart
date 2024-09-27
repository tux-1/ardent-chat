import 'package:flutter/material.dart';

class EmailWidget extends StatelessWidget {
  final TextEditingController emailController;

  const EmailWidget({
    super.key,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: InputBorder.none,

          ),
          readOnly: true,

      ),
    );
  }
}
