import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/message.dart';
import '../../../common/models/request_status.dart';
import '../../../common/helpers/messages_helper.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState());

  void fetchMessages(String chatId) {
    emit(state.copyWith(status: RequestStatus.loading));

    MessagesHelper.fetchMessagesStream(chatId).listen((messages) {
      emit(
        state.copyWith(
          messages: messages,
          status: RequestStatus.loaded,
        ),
      );
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
}
