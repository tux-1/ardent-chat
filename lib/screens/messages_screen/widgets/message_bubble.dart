
import 'package:ardent_chat/common/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../common/models/message.dart';
import '../../../common/models/message_type.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isMe = message.senderId == FirebaseAuth.instance.currentUser!.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: isMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildMessageContent(context),
            Text(
              message.time.toDate().toFormattedString(),
              style: TextStyle(
                color: isMe ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7) : Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    bool isMe = message.senderId == '3';
    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.text,

          style: TextStyle(color: isMe ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onPrimaryContainer),
        );
      case MessageType.image:
        return Row(
          children: [
            Icon(Icons.image, color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 5),
            const Text('Image'),
          ],
        );
      case MessageType.audio:
        return Row(
          children: [
            Icon(Icons.audiotrack, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            const Text('Audio'),
          ],
        );
      case MessageType.video:
        return Row(
          children: [
            Icon(Icons.videocam, color: Theme.of(context).colorScheme.onSurface),
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
        return const SizedBox();
    }
  }
}
