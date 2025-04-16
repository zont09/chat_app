abstract class Api {
  // For android emulator, baseUrl = 'http://10.0.2.2:3001/api/'
  // static const String baseUrl = 'https://b3510dzk-3001.asse.devtunnels.ms/api/';

  static const String baseUrl = 'http://localhost:3001/api/';
  static String wsUrl = 'ws://yourserver.com:3000/ws'; // chưa thêm

  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String fcmToken = 'auth/fcm-token';
  static const String forgetPassword = 'auth/forget-password';
}
