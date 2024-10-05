import 'package:flutter/material.dart';
import '../../common/helpers/messages_helper.dart';
import 'widgets/message_list_view.dart';
import 'widgets/message_input_field.dart';
import 'widgets/messages_app_bar.dart';
import '../../common/models/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/messages_cubit.dart';

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
    context.read<MessagesCubit>().fetchMessages(widget.chat);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MessagesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    MessagesHelper.markMessagesAsSeen(widget.chat.chatId);
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
      appBar: MessagesAppBar(chat: widget.chat),
      body: Column(
        children: [
          const Expanded(child: MessageListView()),
          MessageInputField(
            chat: widget.chat,
            messageController: _messageController,
            onSendMessage: (text, image, file) {},
          ),
        ],
      ),
    );
  }
}
