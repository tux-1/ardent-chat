import 'package:ardent_chat/common/constants/routes.dart';
import 'package:ardent_chat/screens/chat_screen/chat_screen.dart';
import 'package:ardent_chat/screens/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../chat_screen/cubit/chats_cubit.dart';
import '../settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ChatsCubit>().getChats();
    context.read<SettingsCubit>().loadOnlineStatusPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: [
        const ChatScreen(),
        const SettingsPage(),
      ][selectedIndex],

      // Floating action button
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, Routes.addFriendScreen);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),

      // Position the floating action button in the center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom navigation bar with a curved container
      bottomNavigationBar: Container(
        height: 80.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45.0),
            topRight: Radius.circular(45.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 30.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Ionicons.chatbubbles,
                color: selectedIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Ionicons.settings_sharp,
                color: selectedIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
