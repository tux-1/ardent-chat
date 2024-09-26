import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final TextEditingController nameController;
  final Function(String) onEdit;

  const NameWidget({
    super.key,
    required this.nameController,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: 'Name'),
        readOnly: true,
      ),
      subtitle: const Text("This name will be visible to your contacts"),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          onEdit(nameController.text);
        },
      ),
    );
  }
}
