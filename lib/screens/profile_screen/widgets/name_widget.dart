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
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(Icons.person_2_outlined,color: Theme.of(context).colorScheme.onPrimaryContainer,),
      title: Text(
        'Name',
        style: textTheme.titleMedium?.copyWith(
          color: Theme.of(context).primaryColor,
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
          Text("This name will be visible to your contacts",style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
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
