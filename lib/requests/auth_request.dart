import 'package:chat_app/common/api.dart';
import 'package:chat_app/services/firebase_service.dart';
import 'package:chat_app/services/http_service.dart';
import 'package:dio/dio.dart';

class AuthRequest extends HttpService {
  Future<Response> login({
    required String email,
    required String password,
    String? role,
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

    return response;
  }

  Future<Response> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    final response = await post(
      url: Api.register,
      data: {
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "name": name,
      },
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response;
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
