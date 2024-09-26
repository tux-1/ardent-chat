import 'package:ardent_chat/common/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../common/models/chat_model.dart';
import '../../../common/models/message_type.dart';

class ChatBox extends StatelessWidget {
  final Chat chat;

  const ChatBox({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: chat.contact.profileImageUrl.isEmpty
                  ? const AssetImage('assets/images/welcome (1).png')
                  : NetworkImage(chat.contact.profileImageUrl),
              radius: 25,
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
        title: Row(
          children: [
            Text(
              chat.contact.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              chat.time.toDate().toFormattedString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: _buildMessageContent(
          messageType: chat.messageType,
          context: context,
          text: chat.text,
        ),
      ),
    );
  }

  Widget _buildMessageContent(
      {required MessageType messageType,
      required BuildContext context,
      required String text}) {
    return Row(
      children: [
        Expanded(
          child: switch (messageType) {
            MessageType.text => Text(
                text,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            MessageType.image => Row(
                children: [
                  Icon(Icons.image,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 5),
                  const Text('Image'),
                ],
              ),
            MessageType.audio => Row(
                children: [
                  Icon(Icons.audiotrack,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 5),
                  const Text('Audio'),
                ],
              ),
            MessageType.video => Row(
                children: [
                  Icon(Icons.videocam,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 5),
                  const Text('Video'),
                ],
              ),
            MessageType.gif => Row(
                children: [
                  Icon(Icons.gif,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 5),
                  const Text('GIF'),
                ],
              ),
          },
        ),
        if (chat.unreadCount > 0)
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              chat.unreadCount.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
