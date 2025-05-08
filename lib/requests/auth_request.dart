import 'package:chat_app/common/api.dart';
import 'package:chat_app/models/auth_response.dart';
import 'package:chat_app/services/firebase_service.dart';
import 'package:chat_app/services/http_service.dart';
import 'package:dio/dio.dart';

class AuthRequest extends HttpService {
  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    final fcmToken = await FirebaseService.fcmToken;
    final response = await post(
      url: Api.login,
      data: {
        'email': email,
        'password': password,
        'fcmToken': fcmToken,
      },
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data);
    }
    return null;
  }

  Future<AuthResponse?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final fcmToken = await FirebaseService.fcmToken;
    final response = await post(
      url: Api.register,
      data: {
        "email": email,
        "password": password,
        "username": username,
        "fcmToken": fcmToken,
      },
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(response.data);
    }
    return null;
  }

  Future<Response> sendFCMTokenToServer(String fcmToken) {
    return post(
      url: Api.fcmToken,
      data: {'fcmToken': fcmToken},
    );
  }

  Future<Response> deleteFCMTokenOnServer(String fcmToken) {
    return delete(
      url: Api.fcmToken,
      data: {'fcmToken': fcmToken},
    );
  }

  Future<Response> forgetPassword(String email) async {
    return await put(
      url: Api.forgetPassword,
      data: {'email': email},
    );
  }
}
