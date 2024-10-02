import 'package:ardent_chat/common/constants/routes.dart';

import 'package:ardent_chat/common/theme/theme.dart';
import 'package:ardent_chat/screens/home_screen/home_screen.dart';
import 'package:ardent_chat/screens/login_screen/login_screen.dart';
import 'package:ardent_chat/screens/onboarding/onboarding_screen.dart';
import 'package:ardent_chat/screens/splash/splash_screen.dart';
import 'package:ardent_chat/screens/verification/verification_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ardent_chat/screens/chat_screen/cubit/chats_cubit.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'common/theme/theme_provider.dart';

import 'screens/signup_screen/signup.dart';
import 'screens/add_friend_Screen/add-friend.dart';

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
    // Get the brightness
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    // Get the Hive-stored or Theme.of(context)-based theme setting
    final themePreference = ref.watch(themeProvider);

    // If Hive box value is null (not set), use the default Theme.of(context) brightness
    bool finalTheme = themePreference ?? isDarkMode;

    // return MaterialApp(
    return MultiBlocProvider(
        providers: [
          BlocProvider<ChatsCubit>(create: (_) => ChatsCubit()),
        ],
        child: MaterialApp(
          title: 'Ardent Chat',
          themeMode: finalTheme ? ThemeMode.dark : ThemeMode.light,
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.homeScreen,
          routes: {
            Routes.splashScreen: (context) => const AnimatedSplashScreen(),
            Routes.authenticationScreen: (context) => Container(),
            Routes.loginScreen: (context) => const LoginScreen(),
            Routes.signUpScreen: (context) => const SignUpScreen(),
            Routes.homeScreen: (context) => const HomeScreen(),
            Routes.addFriendScreen: (context) => const AddFriendScreen(),
            Routes.onBoardingScreen: (context) => const OnboardingScreen(),
            Routes.verifyAuthenticationScreen: (context) =>
                const VerificationScreen(),
          },
        ));
  }
}
