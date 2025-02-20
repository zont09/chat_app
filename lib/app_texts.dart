enum AppText {
  textRouteLogin,
  textRouteChat,
  textRouteOverview,
  textRouteProfile,
}

Map<AppText, String> texts = {
  AppText.textRouteLogin: "/login",
  AppText.textRouteChat: "/chat",
  AppText.textRouteOverview: "/overview",
  AppText.textRouteProfile: "/profile",
};

extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}