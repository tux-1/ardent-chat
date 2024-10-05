import 'package:ardent_chat/common/helpers/profile_helper.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  Future<void> loadOnlineStatusPreference() async {
    final bool status = await ProfileHelper.getOnlineStatusPreference();
    emit(state.copyWith(isOnlineStatusEnabled: status));
  }

  Future<void> updateOnlineStatusPreference(bool newValue) async {
    await ProfileHelper.updateOnlineStatusPreference(newValue);
    emit(state.copyWith(isOnlineStatusEnabled: newValue));
  }
}
