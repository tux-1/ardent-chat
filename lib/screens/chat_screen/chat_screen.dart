import 'widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/models/chat_model.dart';
import 'cubit/chats_cubit.dart';
import 'widgets/chat_box.dart';


class ChatScreen extends StatelessWidget {
  final List<Chat> chats;
  ChatScreen({required this.chats});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ChatsAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<ChatsCubit, List<Chat>>(
              builder: (context, chats) {
                List<Widget> chatWidgets = chats.map((chat) {
                  return ChatBox(chat: chat);
                }).toList();
                return ListView(
                  children: chatWidgets,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
