import 'package:flutter/cupertino.dart';

enum ProfileStatus { loading, success, error }

class ProfileState {
  final String name;
  final String email;
  final ImageProvider<Object>? profileImage;
  final ProfileStatus status;
  final String? errorMessage;

  ProfileState({
    required this.name,
    required this.email,
    this.profileImage,
    this.status = ProfileStatus.loading,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    ImageProvider<Object>? profileImage,
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
