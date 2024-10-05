import 'package:ardent_chat/common/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../common/models/chat_model.dart';
import '../../../common/models/message_type.dart';
import 'package:ardent_chat/screens/messages_screen/messages_screen.dart';

class ChatBox extends StatelessWidget {
  final Chat chat;

  const ChatBox({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MessagesScreen(chat: chat),
            ),
          );
        },
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: chat.contact.profileImageUrl.isEmpty
                  ? const AssetImage('assets/images/anonymous.png')
                  : NetworkImage(chat.contact.profileImageUrl) as ImageProvider,
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
              style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              chat.time.toDate().toFormattedString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: _buildMessageContent(
          messageType: chat.messageType,
          context: context,
          text:
              "${chat.lastMessageSenderId == FirebaseAuth.instance.currentUser?.uid ? "You: " : ""}${chat.text}",
        ),
      ),
    );
  }

  Widget _buildMessageContent({
    required MessageType messageType,
    required BuildContext context,
    required String text,
  }) {
    Widget messageWidget;

    switch (messageType) {
      case MessageType.text:
        messageWidget = Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
        );
        break;
      case MessageType.image:
        messageWidget = Row(
          children: [
            Icon(Icons.image, color: Theme.of(context).colorScheme.onPrimaryContainer),
            const SizedBox(width: 5),
            Text('Image',style:TextStyle(color:Theme.of(context).colorScheme.onPrimaryContainer )),
          ],
        );
        break;
      case MessageType.audio:
        messageWidget = Row(
          children: [
            Icon(Icons.audiotrack,
                color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            Text('Audio',style:TextStyle(color:Theme.of(context).colorScheme.onPrimaryContainer )),
          ],
        );
        break;
      case MessageType.video:
        messageWidget = Row(
          children: [
            Icon(Icons.videocam,
                color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 5),
            Text('Video',style:TextStyle(color:Theme.of(context).colorScheme.onPrimaryContainer )),
          ],
        );
        break;
      case MessageType.gif:
        messageWidget = Row(
          children: [
            Icon(Icons.gif, color: Theme.of(context).colorScheme.onPrimaryContainer),
            const SizedBox(width: 5),
            Text('GIF',style:TextStyle(color:Theme.of(context).colorScheme.onPrimaryContainer )),
          ],
        );
        break;
      default:
        messageWidget = const SizedBox();
    }

    return Row(
      children: [
        Expanded(child: messageWidget),
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
