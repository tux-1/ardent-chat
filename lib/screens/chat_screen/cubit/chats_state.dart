import '../../../common/models/chat_model.dart';
import '../../../common/models/request_status.dart';

class ChatsState {
  final List<Chat> chats;
  final RequestStatus status;
  final String searchQuery;

  ChatsState({
    this.chats = const [],
    this.status = RequestStatus.initial,
    this.searchQuery = '',
  });

  ChatsState copyWith({
    List<Chat>? chats,
    RequestStatus? status,
    String? searchQuery,
  }) {
    return ChatsState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
