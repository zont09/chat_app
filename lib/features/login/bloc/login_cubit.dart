import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<int> {
  LoginCubit() : super(0);

  // final UserService _userService = UserService.instance;

  final TextEditingController conUsername = TextEditingController();
  final TextEditingController conPassword = TextEditingController();

  int errorUsername = -1;
  int errorPassword = -1;


  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
