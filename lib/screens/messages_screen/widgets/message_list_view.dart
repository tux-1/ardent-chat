
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/request_status.dart';
import '../cubit/messages_cubit.dart';
import '../cubit/messages_state.dart';
import 'message_bubble.dart';

class MessageListView extends StatelessWidget {
  const MessageListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        switch (state.status) {
          case RequestStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case RequestStatus.error:
            return const Center(child: Text('Failed to load messages'));

          default:
            if (state.messages.isEmpty) {
              return const Center(child: Text('No messages yet'));
            }

            return ListView.builder(
              reverse: true,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return MessageBubble(message: message);
              },
            );
        }
      },
    );
  }
}
