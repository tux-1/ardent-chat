import 'dart:async';

import 'package:ardent_chat/common/helpers/chats_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/chat_model.dart';
import '../../../common/models/request_status.dart';
import 'chats_state.dart';
class ChatsCubit extends Cubit<ChatsState> {
  StreamSubscription<List<Chat>>? _chatsSubscription;

  ChatsCubit() : super(ChatsState()) {
    getChats();
  }

  Future<void> getChats() async {
    // Emit loading state
    emit(state.copyWith(status: RequestStatus.loading));

    // Cancel any existing subscriptions before starting a new one to prevent memory leaks
    await _chatsSubscription?.cancel();

    // Subscribe to the chat stream
    _chatsSubscription = ChatsHelper.getChatsStream()
        .listen((chats) {
          // When new chat data is received from the stream, emit the updated state
          emit(state.copyWith(
            chats: chats,
            status: RequestStatus.loaded,
          ));
        }, onError: (error) {
          // Handle any errors in the stream
          emit(state.copyWith(status: RequestStatus.error));
        });
  }

  // Dispose of the subscription when the cubit is closed to avoid memory leaks
  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
