import 'dart:io';
import 'package:flutter/material.dart';
import 'widgets/message_list_view.dart';
import 'widgets/message_input_field.dart';
import 'widgets/messages_app_bar.dart';
import '../../common/models/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/messages_cubit.dart';

class MessagesScreen extends StatefulWidget {
  final Chat chat;

  const MessagesScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessagesCubit>().fetchMessages(widget.chat.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessagesAppBar(chat: widget.chat),

      body: Column(
        children: [
          const Expanded(child: MessageListView()),
          MessageInputField(
            chat: widget.chat,
            messageController: _messageController,
            onSendMessage: (text, image, file) {
            },
          ),
        ],
      ),
    );
  }
}
