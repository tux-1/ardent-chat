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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name',
              suffixIcon: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onEdit(nameController.text);
                },
              ),
            helper:const Center(child: Text("This name will be visible to your contacts")),
            prefixIcon: const Icon(Icons.person_2_outlined),
            suffixIconColor: Theme.of(context).colorScheme.primary,
              border:InputBorder.none,
          ),
          readOnly: true,
      ),
    );
  }
}
