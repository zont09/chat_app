import 'package:chat_app/features/chat/views/desktop/chat_screen_desktop.dart';
import 'package:chat_app/features/chat/views/mobile/chat_screen_mobile.dart';
import 'package:chat_app/features/chat/views/tablet/chat_screen_tablet.dart';
import 'package:chat_app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class ChatMainView extends StatelessWidget {
  const ChatMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobile: ChatScreenMobile(),
        tablet: ChatScreenTablet(),
        desktop: ChatScreenDesktop());
  }
}
