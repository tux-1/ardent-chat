import '../../../common/models/chat_model.dart';
enum RequestStatus { initial, loading, loaded, error }
class ChatsState {
  final RequestStatus status;
  final List<Chat> chats;
  ChatsState({this.status = RequestStatus.initial, this.chats = const []});
  ChatsState copyWith({RequestStatus? status, List<Chat>? chats}) {
    return ChatsState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
    );
  }
}