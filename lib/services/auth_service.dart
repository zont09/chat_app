import 'dart:convert';
import 'package:chat_app/models/user.dart';
import 'package:hive/hive.dart';

class AuthService {
  static const _tokenBoxName = 'auth_box';
  static const _tokenKey = 'user_token';
  static const _deviceIdKey = 'device_id';
  static const _userKey = 'current_user';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Getters for token and deviceId
  Future<String?> getToken() async {
    final box = await Hive.openBox(_tokenBoxName);
    return box.get(_tokenKey);
  }

  Future<String?> getDeviceId() async {
    final box = await Hive.openBox(_tokenBoxName);
    return box.get(_deviceIdKey,
        defaultValue:
            'flutter-device-${DateTime.now().millisecondsSinceEpoch}');
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    final box = await Hive.openBox(_tokenBoxName);
    final userJson = box.get(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Save token and deviceId
  Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_tokenBoxName);
    await box.put(_tokenKey, token);
  }

  Future<void> saveDeviceId(String deviceId) async {
    final box = await Hive.openBox(_tokenBoxName);
    await box.put(_deviceIdKey, deviceId);
  }

  // Save user
  Future<void> saveUser(User user) async {
    final box = await Hive.openBox(_tokenBoxName);
    await box.put(_userKey, jsonEncode(user.toJson()));
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout
  Future<void> logout() async {
    final box = await Hive.openBox(_tokenBoxName);
    await box.delete(_tokenKey);
    await box.delete(_userKey);
  }
}
