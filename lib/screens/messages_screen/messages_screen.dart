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
    context.read<MessagesCubit>().setActive(true);
    context.read<MessagesCubit>().fetchMessages(widget.chat);
  }

  @override
  void deactivate() {
    context.read<MessagesCubit>().setActive(false);
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<MessagesCubit>().setActive(true);
    } else {
      context.read<MessagesCubit>().setActive(false);
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
