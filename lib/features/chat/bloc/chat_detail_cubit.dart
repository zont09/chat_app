import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailCubit extends Cubit<int> {
  ChatDetailCubit(this.user) : super(0);

  List<Message> messages = [];

  late User user;

  initData(List<Message> data) {
    messages.clear();
    messages.addAll(data);
  }

  addMessage(Message mess) {
    if(messages.any((e) => e.id == mess.id)) return;
    messages.add(mess);
    EMIT();
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}