import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../common/helpers/profile_helper.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
          name: '',
          email: '',
          profileImage: null,
          status: ProfileStatus.loading,
        )) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final profile = await ProfileHelper.getProfileInfo();
      emit(ProfileState(
        name: profile.username,
        email: profile.email,
        profileImage: profile.profileImageUrl.isEmpty
            ? const AssetImage('assets/images/anonymous.png')
            : NetworkImage(profile.profileImageUrl),
        status: ProfileStatus.success,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          status: ProfileStatus.error, errorMessage: 'Failed to load profile'));
    }
  }
  static Future<List> checkUsernameExists(String username) async {
    final usernameQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();

    return usernameQuery.docs;
  }

  Future<void> saveName(String newName) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await ProfileHelper.updateProfileInfo(
        newUsername: newName == state.name ? null : newName,
        newPicture: null,
      );
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: newName,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to save name',
      ));
    }
  }

  Future<void> saveProfileImage(File? newPicture) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await ProfileHelper.updateProfileInfo(
        newUsername: null,
        newPicture: newPicture,
      );
      emit(state.copyWith(
        status: ProfileStatus.success,
        profileImage: FileImage(newPicture!),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to save profile image',
      ));
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await ProfileHelper.deleteProfileImage();
      emit(state.copyWith(
        status: ProfileStatus.success,
        profileImage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to delete profile image',
      ));
    }
  }

  void updateName(String newName) {
    emit(state.copyWith(name: newName));
  }

  void updateProfileImage(ImageProvider<Object>? newImage) {
    emit(state.copyWith(profileImage: newImage));
  }
}
