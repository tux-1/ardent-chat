import 'package:flutter/material.dart';
import '../../../common/models/chat_model.dart';

class MessageAppBar extends StatelessWidget {
  final Chat chat;

  const MessageAppBar({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: chat.contact.profileImageUrl.isEmpty
                      ? const AssetImage('assets/images/anonymous.png')
                      : NetworkImage(chat.contact.profileImageUrl) as ImageProvider,
                  radius: 20,
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 6,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                      chat.contact.isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.contact.username,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  chat.contact.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(fontSize: 12,color:chat.contact.isOnline ?Colors.green:Colors.grey ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.video_call),
              onPressed: () {

              },
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {

              },
            ),
          ],
        ),
      ],
    );
  }
}
