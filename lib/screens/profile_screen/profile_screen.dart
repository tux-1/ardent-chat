import 'dart:io';
import 'widgets/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/name_widget.dart';
import 'widgets/email_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'enas';
  String _email = 'enas@gmail.com';
  ImageProvider<Object>? _profileImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _emailController.text = _email;
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _profileImage = FileImage(File(image.path));
      });
    }
  }

  void _saveProfile() {
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
    });
    Navigator.pop(context);
  }

  void _editName(String currentName) {
    _showEditDialog(
      title: 'Edit Name',
      currentValue: currentName,
      onSave: (newValue) {
        setState(() {
          _nameController.text = newValue;
        });
      },
    );
  }


  void _editEmail(String currentEmail) {
    _showEditDialog(
      title: 'Edit Email',
      currentValue: currentEmail,
      onSave: (newValue) {
        setState(() {
          _emailController.text = newValue;
        });
      },
    );
  }


  void _showEditDialog({
    required String title,
    required String currentValue,
    required Function(String) onSave,
  })
  {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
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
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),


        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProfilePhoto(
                profileImage: _profileImage,
                onImagePicked: _pickImage,
              ),


              const SizedBox(height: 40),
              NameWidget(
                nameController: _nameController,
                onEdit: _editName,
              ),


              const SizedBox(height: 20),
              EmailWidget(
                emailController: _emailController,
                onEdit: _editEmail,
              ),





              const Spacer(),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
