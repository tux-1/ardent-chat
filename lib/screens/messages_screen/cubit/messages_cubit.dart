import 'package:ardent_chat/common/models/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/message.dart';
import '../../../common/models/request_status.dart';
import '../../../common/helpers/messages_helper.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  bool messagesScreenIsActive = false;

  MessagesCubit() : super(MessagesState());

  // Call this when the screen is opened or resumed
  void setActive(bool active) {
    messagesScreenIsActive = active;
    if (messagesScreenIsActive) {
      markMessagesAsSeen();
    }
  }

  void fetchMessages(Chat chat) {
    emit(state.copyWith(status: RequestStatus.loading, chat: chat));

    MessagesHelper.fetchMessagesStream(chat.chatId).listen((messages) {
      emit(
        state.copyWith(
          messages: messages,
          status: RequestStatus.loaded,
        ),
      );
      if (messagesScreenIsActive) {
        // Mark messages as seen only if the screen is active
        markMessagesAsSeen();
      }
    }).onError((error) {
      emit(state.copyWith(status: RequestStatus.error));
    });
  }

  Future<void> sendMessage(
      {required Message message, required String chatId}) async {
    try {
      await MessagesHelper.sendMessage(msg: message, chatId: chatId);
    } catch (e) {
      emit(state.copyWith(status: RequestStatus.error));
    }
  }

  void markMessagesAsSeen() {
    if (state.chat != null) {
      MessagesHelper.markMessagesAsSeen(state.chat!.chatId);
    }
  }
}
