import 'dart:io';
import 'package:ardent_chat/screens/profile_screen/profile_cubit/profile_cubit.dart';
import 'package:ardent_chat/screens/profile_screen/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/profile_photo.dart';
import 'widgets/name_widget.dart';
import 'widgets/email_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      context.read<ProfileCubit>().saveProfileImage(File(image.path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            switch (state.status) {
              case ProfileStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ProfileStatus.error:
                return Center(
                    child: Text(state.errorMessage ?? 'Error occurred'));
              case ProfileStatus.success:
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ProfilePhoto(
                        profileImage: state.profileImage,
                        onImagePicked: (source) => _pickImage(context, source),
                        onDeletePhoto: () {
                          context.read<ProfileCubit>().deleteProfileImage();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Profile photo deleted successfully!')),
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      NameWidget(
                        currentName: state.name,
                        onNameChanged: (newName) {
                          context.read<ProfileCubit>().saveName(newName);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Name updated successfully!')),
                          );
                        },
                      ),
                      const Divider(thickness: 0.3),
                      EmailWidget(
                        email: state.email,
                      ),
                      const Spacer(),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     final newPicture = (state.profileImage as FileImage?)?.file;
                      //     context.read<ProfileCubit>().saveProfile(newName: state.name, newPicture: newPicture);
                      //     Navigator.pop(context);
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Theme.of(context).colorScheme.primary,
                      //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      //     padding: const EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   child: const SizedBox(
                      //     width: double.infinity,
                      //     child: Text(
                      //       'Save',
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
