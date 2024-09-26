
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatelessWidget {
  final ImageProvider<Object>? profileImage;
  final Function(ImageSource) onImagePicked;

  const ProfilePhoto({
    super.key,
    required this.profileImage,
    required this.onImagePicked,
  });

  void _showImagePickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  onImagePicked(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  onImagePicked(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerDialog(context),
      child: CircleAvatar(
        radius: 100,
        backgroundImage: profileImage ?? const AssetImage('assets/images/welcome.png'),
        child: profileImage == null
            ? const Icon(Icons.camera_alt, size: 50)
            : null,
      ),
    );
  }
}
