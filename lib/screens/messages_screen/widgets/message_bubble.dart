import 'package:ardent_chat/common/utils/extensions.dart';
import 'package:ardent_chat/screens/messages_screen/cubit/messages_cubit.dart';
import 'package:ardent_chat/screens/messages_screen/cubit/messages_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/message.dart';
import '../../../common/models/message_type.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isMe = message.senderId == FirebaseAuth.instance.currentUser!.uid;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10).copyWith(
                topLeft: Radius.circular(isMe ? 10 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10),
              ),
            ),
            child: _buildMessageContent(context, isMe),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  message.time.toDate().toFormattedString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                BlocConsumer<MessagesCubit, MessagesState>(
                  builder: (BuildContext context, MessagesState state) {
                    final contactId = state.chat?.contact.id;
                    final isSeen = message.seenBy.contains(contactId);
                    return Icon(
                      isMe
                          ? isSeen
                              ? Icons.done_all
                              : Icons.check
                          : null,
                      size: 17,
                      color: isSeen
                          ? colorScheme.primary
                          : colorScheme.onPrimaryContainer,
                    );
                  },
                  listener: (BuildContext context, MessagesState state) {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isMe) {
    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.text,
          style: TextStyle(
            color: isMe
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary,
          ),
        );
      case MessageType.image:
        return _buildImageMessage(context);
      case MessageType.audio:
        return _buildFileMessage(context, 'Audio', Icons.audiotrack);
      case MessageType.video:
        return _buildFileMessage(context, 'Video', Icons.videocam);
      case MessageType.gif:
        return _buildFileMessage(context, 'GIF', Icons.gif);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Center(
                child: InteractiveViewer(
                  child: Image.network(
                    message.attachmentUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              message.attachmentUrl!,
              height: 100,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message.text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(BuildContext context, String type, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
        Text(type),
      ],
    );
  }
}
