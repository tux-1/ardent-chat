import 'package:ardent_chat/common/constants/routes.dart';

import 'package:ardent_chat/common/theme/theme.dart';
import 'package:ardent_chat/screens/home_screen/home_screen.dart';
import 'package:ardent_chat/screens/login_screen/login_screen.dart';
import 'package:ardent_chat/screens/messages_screen/cubit/messages_cubit.dart';

import 'package:ardent_chat/screens/onboarding/onboarding_screen.dart';
import 'package:ardent_chat/screens/settings/cubit/settings_cubit.dart';
import 'package:ardent_chat/screens/splash/splash_screen.dart';
import 'package:ardent_chat/screens/verification/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ardent_chat/screens/chat_screen/cubit/chats_cubit.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/helpers/profile_helper.dart';
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Set user online when the app starts
    if (FirebaseAuth.instance.currentUser != null) {
      ProfileHelper.updateIsOnlineStatus(true);
    }
  }

  @override
  void dispose() {
    // Set user offline when the app closes
    ProfileHelper.updateIsOnlineStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser != null) {
      if (state == AppLifecycleState.resumed) {
        // App is in the foreground
        ProfileHelper.updateIsOnlineStatus(true);
      } else if (state == AppLifecycleState.paused) {
        // App is in the background
        ProfileHelper.updateIsOnlineStatus(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(),),
        BlocProvider<MessagesCubit>(
          create: (_) => MessagesCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Ardent Chat',
        themeMode: finalTheme ? ThemeMode.dark : ThemeMode.light,
        theme: kLightTheme,
        darkTheme: kDarkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splashScreen,
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
      ),
    );
  }
}
