import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../theme/theme_provider.dart';

class ThemeHelper {
  static void _updateThemeMode(WidgetRef ref, bool isDarkMode) {
    // Access the Hive box
    var box = Hive.box('settings');

    // Update the value in Hive
    box.put('isDarkMode', isDarkMode);

    // Update the provider state
    ref.read(themeProvider.notifier).state = isDarkMode;
  }

  static void toggleThemeMode(WidgetRef ref) {
    final currentMode = ref.read(themeProvider);
    final newMode = !(currentMode ?? false);

    _updateThemeMode(ref, newMode);
  }
}
