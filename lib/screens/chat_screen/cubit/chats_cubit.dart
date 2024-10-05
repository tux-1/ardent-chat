import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/helpers/chats_helper.dart';
import '../../../common/models/chat_model.dart';
import '../../../common/models/request_status.dart';
import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  StreamSubscription<List<Chat>>? _chatsSubscription;
  List<Chat> _allChats = [];
  String searchQuery = "";
  ChatsCubit() : super(ChatsState()) {
    getChats();
  }

  Future<void> getChats() async {
    // Emit loading state
    emit(state.copyWith(status: RequestStatus.loading));

    // Cancel any existing subscriptions before starting a new one to prevent memory leaks
    await _chatsSubscription?.cancel();

    // Subscribe to the chat stream
    _chatsSubscription = ChatsHelper.getChatsStream().listen((chats) {
      _allChats = chats;
      emit(state.copyWith(
        chats: _chats(searchQuery),
        status: RequestStatus.loaded,
      ));
    }, onError: (error) {
      emit(state.copyWith(status: RequestStatus.error));
    });
  }
  void updateSearchQuery(String query) {
    searchQuery = query;
    emit(state.copyWith(chats: _chats(query)));
  }
  List<Chat> _chats(String query) {
    if (query.isEmpty) return _allChats;
    return _allChats.where((chat) =>
        chat.contact.username.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Dispose of the subscription when the cubit is closed to avoid memory leaks
  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
