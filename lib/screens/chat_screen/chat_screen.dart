import '../../common/models/request_status.dart';
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
    final searchQuery = context.watch<ChatsCubit>().state.searchQuery;
    return Column(
      children: [
        const ChatsAppBar(),
        Expanded(
          child: BlocBuilder<ChatsCubit, ChatsState>(
            builder: (context, state) {
              switch (state.status) {
                case RequestStatus.initial:
                case RequestStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case RequestStatus.loaded:
                  return _buildChatsList(state, searchQuery);
                case RequestStatus.error:
                  return const Center(child: Text('Failed to load chats'));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatsList(ChatsState state, String searchQuery) {
    if (state.chats.isEmpty) {
      return const Center(child: Text('No chats matched'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: state.chats.length,
      itemBuilder: (context, index) {
        return ChatBox(chat: state.chats[index],);
      },
    );
  }
}
