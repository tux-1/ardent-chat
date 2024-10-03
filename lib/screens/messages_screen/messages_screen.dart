import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/helpers/messages_helper.dart';
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

class _MessagesScreenState extends State<MessagesScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MessagesHelper.markMessagesAsSeen(widget.chat.chatId);
    context.read<MessagesCubit>().fetchMessages(widget.chat.chatId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the screen is visible, mark messages as seen
      MessagesHelper.markMessagesAsSeen(widget.chat.chatId);
    }
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

    final myId = FirebaseAuth.instance.currentUser!.uid;

    final message = Message(
      senderId: myId,
      text: text,
      messageType: MessageType.text,
      time: Timestamp.now(),
      seenBy: [
        myId,
      ],
      attachmentUrl: null,
      attachmentFile: null,
    );

    context.read<MessagesCubit>().sendMessage(
          message: message,
          chatId: widget.chat.chatId,
        );

    _messageController.clear();
  }
}
