import 'package:flutter/material.dart';

class EmailWidget extends StatelessWidget {
  final String email;

  const EmailWidget({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: const Icon(Icons.email_outlined),
      isThreeLine: true,
      title: Text(
        'Email',
        style: textTheme.titleMedium?.copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
      subtitle: Text(
        email,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
