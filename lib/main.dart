import 'package:chat_app/features/test/test_view.dart';
import 'package:chat_app/router/router.dart';
import 'package:chat_app/router/shell_route/bloc/shell_route_cubit.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đặt hướng đứng cho ứng dụng
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Khởi tạo Hive
  // final docDir = await getApplicationDocumentsDirectory();
  // Hive.init(docDir.path);

  // Khởi tạo Firebase
  // await FirebaseService.init();

  runApp(const CallMainView());
}

class RealChatApp extends StatelessWidget {
  const RealChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShellRouteCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Real Chat',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}
