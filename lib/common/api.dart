abstract class Api {
  // For android emulator, baseUrl = 'http://10.0.2.2:3001/api/'
  // static const String baseUrl = 'https://b3510dzk-3001.asse.devtunnels.ms/api/';

  // For desktop/web: use localhost
  // static const String baseUrl = 'http://localhost:5000/api/';
  static String wsUrl = 'ws://localhost:5000/';

  // For mobile devices: replace with your computer's IP address
  // Make sure your phone and computer are connected to the same WiFi network
  // To find your IP address on Windows, run 'ipconfig' in Command Prompt 
  // and look for the IPv4 address under your active network adapter
  // Example: 192.168.1.5
  static const String baseUrl = 'http://192.168.1.103:5000/api/';
  // static String wsUrl = 'ws://192.168.1.5:5000/';

  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String fcmToken = 'auth/fcm-token';
  static const String forgetPassword = 'auth/forget-password';
}
