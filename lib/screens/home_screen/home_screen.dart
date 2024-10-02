import 'package:ardent_chat/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ardent_chat/screens/add_friend_Screen/add-friend.dart';

import '../settings/settings.dart'; // Import the AddFriendScreenimport '../settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        // TODO: We should call ChatsScreen & Settings Screen
        const ChatScreen(),
        const SettingsPage(),
      ][selectedIndex],

      // Floating action button
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // TODO: We should call Add Friends Screen

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFriendScreen(),
            ),
          );
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
