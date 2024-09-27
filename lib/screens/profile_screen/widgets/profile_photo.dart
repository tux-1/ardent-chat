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
      clipBehavior: Clip.hardEdge,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text("Profile photo",
                        style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
              ),
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


  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Center(
              child: profileImage != null
                  ? Image(image: profileImage!)
                  : Image.asset('assets/images/anonymous.png'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        GestureDetector(
          onTap: () => _showFullScreenImage(context),
          child: CircleAvatar(
            radius: 100,
            backgroundImage: profileImage ?? const AssetImage('assets/images/anonymous.png'),

          ),
        ),

        Positioned(
          right: 5,
          bottom: 5,
          child: GestureDetector(
            onTap: () => _showImagePickerDialog(context),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.camera_alt_outlined, size: 30,color:Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
