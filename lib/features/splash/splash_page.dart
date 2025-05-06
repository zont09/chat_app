import 'package:chat_app/common/api.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();
  final WebSocketService _webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Short delay to show splash screen
    // await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if the user has a token
    final isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      // If authenticated, connect to WebSocket with token and then navigate to home
      final token = await _authService.getToken();
      final deviceId = await _authService.getDeviceId();

      // Connect to WebSocket with token
      _webSocketService.connect(Api.wsUrl, token: token, deviceId: deviceId);

      // Navigate to conversation page
      if (mounted) {
        context.go(Routes.conversation);
      }
    } else {
      // If not authenticated, navigate to login screen
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),

            // App Name
            Text(
              'Real Chat',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
