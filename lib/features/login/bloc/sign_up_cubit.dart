import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<int> {
  SignUpCubit() : super(0);

  final TextEditingController conUsername = TextEditingController();
  final TextEditingController conPassword = TextEditingController();
  final TextEditingController conRePassword = TextEditingController();

  int errorUsername = -1;
  int errorPassword = -1;
  int errorRePassword = -1;

  checkError() {
    if(conUsername.text.isEmpty) {
      errorUsername = 1;
    } else if(!isValidEmail(conUsername.text)) {
      errorUsername = 2;
    }  else {
      errorUsername = 0;
    }

    if(conPassword.text.isEmpty) {
      errorPassword = 1;
    } else {
      errorPassword = 0;
    }

    if(conRePassword.text.isEmpty) {
      errorRePassword = 1;
    } else if(conRePassword.text != conPassword.text) {
      errorRePassword = 2;
    } else {
      errorRePassword = 0;
    }
    EMIT();
    return errorRePassword > 0 || errorPassword > 0 || errorUsername > 0;
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}