import 'package:chat_app/features/login/views/mobile/login_mobile_view.dart';
import 'package:chat_app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class LoginMainView extends StatelessWidget {
  const LoginMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobile: LoginMobileView(),
        tablet: LoginMobileView(),
        desktop: LoginMobileView());
  }
}
