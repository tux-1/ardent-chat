import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/chat_model.dart';
import 'chats_state.dart';
class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsState()){
    getChats();
  }
  Future<void> getChats() async {
    emit(state.copyWith(status: RequestStatus.loading));
    emit(state.copyWith(chats: chatList, status: RequestStatus.loaded));
  }
}