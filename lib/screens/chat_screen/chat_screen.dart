import 'cubit/chats_state.dart';
import 'widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/chat_box.dart';
import 'cubit/chats_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ChatsAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<ChatsCubit, ChatsState>(
              builder: (context, state) {
                if (state.status == RequestStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == RequestStatus.loaded) {
                  return ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      return ChatBox(chat: state.chats[index]);
                    },
                  );
                } else if (state.status == RequestStatus.error) {
                  return const Center(child: Text('Failed to load chats'));
                } else {
                  return const Center(child: Text('No chats available'));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
