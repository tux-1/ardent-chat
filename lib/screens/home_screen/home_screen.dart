import 'package:ardent_chat/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../common/models/chat_model.dart';

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
        ChatScreen(chats: chatList),
        const Center(child: Text("Settings")),
      ][selectedIndex],

      // Floating action button
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // TODO: We should call Add Friends Screen
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),

      // Position the floating action button in the center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom navigation bar with a curved container
      bottomNavigationBar: Container(
        height: 80.0,
        decoration: BoxDecoration(
          color: Colors.white,
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
                    ? Theme.of(context).primaryColor
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
                    ? Theme.of(context).primaryColor
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
