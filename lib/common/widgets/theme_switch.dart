import 'package:ardent_chat/common/helpers/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/theme_provider.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    var brightness = Theme.of(context).brightness;
    final switchValue = isDarkMode ?? (brightness == Brightness.dark);

    return Switch(
      value: switchValue,
      onChanged: (newValue) => ThemeHelper.toggleThemeMode(ref),
    );
  }
}