import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/chat_model.dart';
import '../../../common/models/message_type.dart';


class ChatsCubit extends Cubit<List<Chat>> {
  ChatsCubit() : super([]) {
    loadChats();
  }

  void loadChats() {
    final List<Chat> chatList = [
      Chat(
        name: 'Sebastian Rudiger',
        message: MessageType.text,
        time: DateTime.now(),
        unreadCount: 0,
        profileImageUrl: 'images/welcome (1).png',
        isOnline: true,
      ),
      Chat(
        name: 'Caroline Varsaha',
        message: MessageType.gif,
        time: DateTime.now(),
        unreadCount: 2,
        profileImageUrl: 'images/welcome (1).png',
        isOnline: false,
      ),
      Chat(
        name: 'Caroline Varsaha',
        message: MessageType.video,
        time: DateTime.now(),
        unreadCount: 2,
        profileImageUrl: 'images/welcome (1).png',
        isOnline: true,
      ),
      Chat(
        name: 'Caroline Varsaha',
        message: MessageType.audio,
        time: DateTime.now(),
        unreadCount: 2,
        profileImageUrl: 'images/welcome (1).png',
        isOnline: false,
      ),
      Chat(
        name: 'Caroline Varsaha',
        message: MessageType.image,
        time: DateTime.now(),
        unreadCount: 2,
        profileImageUrl: 'images/welcome (1).png',
        isOnline: true,
      ),
    ];
    emit(chatList);
  }
}
