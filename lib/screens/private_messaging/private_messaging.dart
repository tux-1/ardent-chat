import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final bool isOnline;

  const MessagesScreen({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                color: isOnline ? Colors.green : Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _receivedMessage("Hi, Jimmy! Any update today?", "09:32 PM"),
                _sentMessage("All good! We have some update ✨", "09:34 PM"),
                _receivedMessage("Cool! I have some feedback on the 'How it works' section. Overall looks good now! 👍", "10:15 PM"),
                _sentMessage("Perfect! Will check it 🔥", "09:34 PM"),
              ],
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _receivedMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle( fontSize: 16),
            ),
          ),
          Text(
            time,
            style: const TextStyle( fontSize: 12),
          ),
        ],
      ),
    );
  }


  Widget _sentMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style:  TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
            ),
          ),
          Text(
            time,
            style: const TextStyle( fontSize: 12),
          ),
        ],
      ),
    );
  }



  Widget _inputArea() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
                Positioned(

                    right: 10,
                    child: Icon(

                        size: 30,
                        Icons.camera_alt_outlined
                    )
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }
}
