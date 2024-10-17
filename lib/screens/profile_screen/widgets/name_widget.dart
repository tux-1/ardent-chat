import 'package:flutter/material.dart';
import 'package:ardent_chat/common/helpers/profile_helper.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(Icons.person_2_outlined,
          color: Theme.of(context).colorScheme.onPrimaryContainer),
      title: Text(
        'Name',
        style: textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(
          Icons.edit_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          _showEditDialog(context);
        },
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "This name will be visible to your contacts",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController(text: currentName);
    String? errorMessage;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: const Text('Edit Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter new name',
                  errorText: errorMessage,
                ),
                onChanged: (value) {
                  errorMessage = null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isEmpty) {
                  errorMessage = 'Username cannot be empty.';
                  (context as Element).markNeedsBuild();
                  return;
                }
                if (newName != currentName) {
                  final usernameExists = await ProfileHelper.checkUsernameExists(newName);
                  if (usernameExists) {
                    errorMessage = 'Username is already taken.';
                    (context as Element).markNeedsBuild();
                    return;
                  }
                }
                await onNameChanged(newName);
                Navigator.of(context).pop();},
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
