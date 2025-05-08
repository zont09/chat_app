import 'package:chat_app/common/api.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashCubit extends Cubit<bool> {
  SplashCubit() : super(false) {
    checkAuthentication();
  }

  final AuthService _authService = AuthService();
  final WebSocketService _webSocketService = WebSocketService();
  bool isLoading = true;

  Future<void> checkAuthentication([BuildContext? context]) async {
    isLoading = true;

    try {
      // Check if the user has a token
      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        // If authenticated, connect to WebSocket with token and then navigate to home
        final token = await _authService.getToken();
        final deviceId = await _authService.getDeviceId();

        // Connect to WebSocket with token
        _webSocketService.connect(Api.wsUrl, token: token, deviceId: deviceId);

        // Navigate to conversation page if context is provided
        if (context != null) {
          context.go(Routes.conversation);
        }
      } else {
        // If not authenticated, navigate to login screen if context is provided
        if (context != null) {
          context.go(Routes.login);
        }
      }

      isLoading = false;
    } catch (e) {
      print('Authentication check error: $e');
      isLoading = false;

      // Navigate to login on error if context is provided
      if (context != null) {
        context.go(Routes.login);
      }
    }
  }

  void navigateBasedOnAuth(BuildContext context) {
    checkAuthentication(context);
  }
}
