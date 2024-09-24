import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/models/chat_model.dart';
import '../../../common/models/message_type.dart';

class ChatBox extends StatelessWidget {
  final Chat chat;

  const ChatBox({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(chat.profileImageUrl),
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
                    backgroundColor: chat.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            chat.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: _buildMessageContent(chat.message, context),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat.Hm().format(chat.time),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(MessageType messageType, BuildContext context) {
    switch (messageType) {
      case MessageType.text:
        return Text(
          'This is a text message that will not overflow',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        );
      case MessageType.image:
        return Row(
          children: [
            Icon(Icons.image, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            const Text('Image'),
          ],
        );
      case MessageType.audio:
        return Row(
          children: [
            Icon(Icons.audiotrack,
                color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            const Text('Audio'),
          ],
        );
      case MessageType.video:
        return Row(
          children: [
            Icon(Icons.videocam,
                color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            const Text('Video'),
          ],
        );
      case MessageType.gif:
        return Row(
          children: [
            Icon(Icons.gif, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            const Text('GIF'),
          ],
        );
      default:
        return const Text(
          'Unknown Message Type',
          overflow: TextOverflow.ellipsis,
        );
    }
  }
}
