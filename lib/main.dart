import 'package:ardent_chat/common/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'common/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and Hive Flutter
  await Hive.initFlutter();
  await Hive.openBox('isDarkMode');

  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use MediaQuery to get the brightness
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    // Get the Hive-stored or MediaQuery-based theme setting
    final themePreference = ref.watch(themeProvider);

    // If Hive box value is null (not set), use the default MediaQuery brightness
    bool finalTheme = themePreference ?? isDarkMode;

    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: finalTheme ? ThemeMode.dark : ThemeMode.light,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
    );
  }
}
