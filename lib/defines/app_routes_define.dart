import 'package:chat_app/app_texts.dart';

enum AppRoutes { login, chat, overview, profile }

extension AppRoutesExtension on AppRoutes {
  String get text {
    switch (this) {
      case AppRoutes.profile:
        return AppText.textRouteProfile.text;
      case AppRoutes.chat:
        return AppText.textRouteChat.text;
      case AppRoutes.overview:
        return AppText.textRouteOverview.text;
      default:
        return AppText.textRouteLogin.text;
    }
  }
}
