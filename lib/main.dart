import 'package:chat_app/features/chat/views/chat_main_view.dart';
import 'package:chat_app/features/chat/views/mobile/conservation_chat_view.dart';
import 'package:chat_app/features/onboarding/views/onboarding_main_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Afacad',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ConversationListScreen(),
    );
  }
}
