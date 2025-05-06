import 'package:flutter_bloc/flutter_bloc.dart';

class ShellRouteCubit extends Cubit<int> {
  ShellRouteCubit() : super(0);

  void setIndex(int index) {
    emit(index);
  }
}