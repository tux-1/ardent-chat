import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final String currentName;
  final Function(String) onNameChanged;

  const NameWidget({
    super.key,
    required this.currentName,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const Icon(Icons.person_2_outlined),
        title: TextField(
          controller: TextEditingController(text: currentName),
          decoration: const InputDecoration(
            labelText: 'Name',
            border: InputBorder.none,
          ),
          readOnly: true,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            _showEditDialog(context);
          },
        ),
        subtitle: const Text("This name will be visible to your contacts"),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          child: AlertDialog(

            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,

            ),

            title: const Text('Edit Name'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Enter new name'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },

                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onNameChanged(nameController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
