import 'package:chat_app/models/conservation_model.dart';
import 'package:chat_app/models/dummy_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<int> {
  ConversationCubit() : super(0);

  List<Conversation> conversations = [];

  initData(List<Conversation> data) {
    conversations.clear();
    conversations.addAll(data);
  }

  addConversation(Conversation conv) {
    if (conversations.any((e) => e.id == conv.id)) return;
    conversations.add(conv);
    updateOrder();
    EMIT();
  }

  updateConversation(Conversation conv) {
    final index = conversations.indexWhere((e) => e.id == conv.id);
    if (index == -1) return;
    conversations[index] = conv;
    updateOrder();
    EMIT();
  }

  updateOrder() {
    conversations.sort((a, b) {
      final messA = DummyData.instance.dummyMessages.firstWhere((e) => e.id == a.lastMessage);
      final messB = DummyData.instance.dummyMessages.firstWhere((e) => e.id == b.lastMessage);
      return messB.timestamp.compareTo(messA.timestamp);
    });
    EMIT();
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
