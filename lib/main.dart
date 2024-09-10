import 'package:ardent_chat/common/constants/routes.dart';
import 'package:ardent_chat/common/helpers/theme_helper.dart';
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
  await Hive.openBox('settings');

  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
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
      title: 'Ardent Chat',
      themeMode: finalTheme ? ThemeMode.dark : ThemeMode.light,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              ThemeHelper.toggleThemeMode(ref);
              Navigator.of(context).pushNamed('ChatScreen');
            },
            child: Text('Switch mode'),
          ),
        ),
      ),
      routes: {
        Routes.addFriendScreen: (context) => Container(),
        Routes.authenticationScreen: (context) => Container(),
        Routes.homeScreen: (context) => Container(),
        Routes.onBoardingScreen: (context) => Container(),
        Routes.verifyAuthenticationScreen: (context) => Container(),
      },
    );
  }
}
