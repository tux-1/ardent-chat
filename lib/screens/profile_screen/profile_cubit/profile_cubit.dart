import 'dart:io';
import 'package:bloc/bloc.dart';
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

  // Method to load profile information
  Future<void> loadProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final profile = await ProfileHelper.getProfileInfo();
      emit(ProfileState(
        name: profile.username,
        email: profile.email,
        profileImage: NetworkImage(profile.profileImageUrl),
        status: ProfileStatus.success,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          status: ProfileStatus.error, errorMessage: 'Failed to load profile'));
    }
  }

  void updateName(String newName) {
    emit(state.copyWith(name: newName));
  }

  void updateProfileImage(ImageProvider<Object>? newImage) {
    emit(state.copyWith(profileImage: newImage));
  }

  Future<void> saveProfile(String newName, File? newPicture) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await ProfileHelper.updateProfileInfo(
        newUsername: newName == state.name ? null : newName,
        newPicture: newPicture,
      );
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: newName,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to save profile',
      ));
    }
  }
}
