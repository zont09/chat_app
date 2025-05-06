import 'package:chat_app/models/user.dart';

class AuthResponse {
  final User user;
  final String token;
  final String? message;

  AuthResponse({
    required this.user,
    required this.token,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}
