class SettingsState {
  final bool isOnlineStatusEnabled;

  SettingsState({this.isOnlineStatusEnabled = false});

  SettingsState copyWith({bool? isOnlineStatusEnabled}) {
    return SettingsState(
      isOnlineStatusEnabled: isOnlineStatusEnabled ?? this.isOnlineStatusEnabled,
    );
  }
}