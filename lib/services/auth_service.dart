import 'package:hive/hive.dart';

abstract class AuthService {
  static Future<Box> _getBox() async {
    return await Hive.openBox('AuthService');
  }

  static Future<String> getAuthBearerToken() async {
    final authServiceBox = await _getBox();
    return authServiceBox.get('token') ?? '';
  }

  static Future<void> setAuthBearerToken(String token) async {
    final authServiceBox = await _getBox();
    await authServiceBox.put('token', token);
  }

  static Future<void> removeAuthBearerToken() async {
    final authServiceBox = await _getBox();
    await authServiceBox.delete('token');
  }
}
