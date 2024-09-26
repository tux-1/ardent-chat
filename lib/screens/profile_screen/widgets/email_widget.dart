import 'package:flutter/material.dart';

class EmailWidget extends StatelessWidget {
  final TextEditingController emailController;
  final Function(String) onEdit;

  const EmailWidget({
    Key? key,
    required this.emailController,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.email_outlined),
      title: TextField(
        controller: emailController,
        decoration: const InputDecoration(labelText: 'Email'),
        readOnly: true,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          onEdit(emailController.text);
        },
      ),
    );
  }
}
