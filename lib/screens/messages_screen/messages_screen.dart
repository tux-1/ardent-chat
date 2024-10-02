import 'package:flutter/material.dart';
import 'widgets/message_list_view.dart';
import 'widgets/message_input_field.dart';
import 'widgets/messages_app_bar.dart';
import '../../common/models/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/messages_cubit.dart';
import '../../common/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/models/message_type.dart';

class MessagesScreen extends StatefulWidget {
  final Chat chat;

  const MessagesScreen({
    super.key,
    required this.chat,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessagesCubit>().fetchMessages(widget.chat.contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MessageAppBar(chat: widget.chat),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          const Expanded(child: MessageListView()),
          MessageInputField(
            messageController: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      senderId: '3',
      text: text,
      messageType: MessageType.text,
      time: Timestamp.now(),
      seenBy: [],
      attachmentUrl: null,
      attachmentFile: null,
    );

    context.read<MessagesCubit>().sendMessage(
      message: message,
      chatId: widget.chat.contact.id,
    );

    _messageController.clear();
  }
}
