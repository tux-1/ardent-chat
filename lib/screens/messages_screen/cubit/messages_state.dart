import '../../../common/models/chat_model.dart';
import '../../../common/models/message.dart';
import '../../../common/models/request_status.dart';

class MessagesState {
  final List<Message> messages;
  final RequestStatus status;
  final Chat? chat;

  MessagesState({this.messages = const [], this.status = RequestStatus.initial, this.chat});

  MessagesState copyWith({
    List<Message>? messages,
    RequestStatus? status,
    Chat? chat,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      chat: chat ?? this.chat,
    );
  }
}
