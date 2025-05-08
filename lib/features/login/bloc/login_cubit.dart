import 'package:chat_app/models/auth_response.dart';
import 'package:chat_app/requests/auth_request.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<int> {
  LoginCubit() : super(0);

  final AuthRequest _authRequest = AuthRequest();
  final AuthService _authService = AuthService();

  final TextEditingController conUsername = TextEditingController();
  final TextEditingController conPassword = TextEditingController();

  int errorUsername = -1;
  int errorPassword = -1;
  bool isLoading = false;

  bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  Future<AuthResponse?> login() async {
    // Validate inputs first
    if (conUsername.text.isEmpty) {
      errorUsername = 1;
      emit(state + 1);
      return null;
    } else if (!isValidEmail(conUsername.text)) {
      errorUsername = 2;
      emit(state + 1);
      return null;
    } else {
      errorUsername = -1;
    }

    if (conPassword.text.isEmpty) {
      errorPassword = 1;
      emit(state + 1);
      return null;
    } else {
      errorPassword = -1;
    }

    try {
      isLoading = true;
      emit(state + 1);

      final response = await _authRequest.login(
        email: conUsername.text.trim(),
        password: conPassword.text,
      );

      if (response != null) {
        // Save auth token and user data
        await _authService.saveToken(response.token);
        await _authService.saveUser(response.user);
        isLoading = false;
        emit(state + 1);
        return response;
      }

      isLoading = false;
      emit(state + 1);
      return null;
    } catch (e) {
      print('Login error: $e');
      isLoading = false;
      emit(state + 1);
      return null;
    }
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
