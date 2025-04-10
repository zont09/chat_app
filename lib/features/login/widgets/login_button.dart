import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/login/bloc/login_cubit.dart';
import 'package:chat_app/widgets/z_button.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.cubit,
  });

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ZButton(
        title: AppText.textLogin.text,
        onPressed: () async {

        },
        paddingHor: 20,
        sizeTitle: 16,
        fontWeight: FontWeight.w600,
        colorBackground: ColorConfig.primary2,
        isShadow: true);
  }
}