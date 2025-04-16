import 'package:chat_app/router/router.dart';
import 'package:chat_app/services/firebase_service.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đặt hướng đứng cho ứng dụng
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Khởi tạo Hive
  final docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);

  // Khởi tạo Firebase
  await FirebaseService.init();
  
  runApp(const RealChatApp());
}

class RealChatApp extends StatelessWidget {
  const RealChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Real Chat',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
