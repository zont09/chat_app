import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/login/bloc/sign_up_cubit.dart';
import 'package:chat_app/features/login/widgets/password_textfield.dart';
import 'package:chat_app/features/login/widgets/username_textfield.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';

class SignUpTextFieldView extends StatelessWidget {
  const SignUpTextFieldView({
    super.key,
    required this.cubit,
  });

  final SignUpCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UsernameTextField(
          hintText: AppText.textHintUsername.text,
          icon: Icons.account_circle_outlined,
          controller: cubit.conUsername,
          isError: cubit.errorUsername > 0,
          changeError: (v) {
            cubit.errorUsername = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorPassword > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorUsername == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        if (cubit.errorUsername == 2)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textInvalidEmail.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        SizedBox(height: Resizable.size(context, 10)),
        PasswordTextField(
          hintText: AppText.textHintPassword.text,
          icon: Icons.lock_outline,
          controller: cubit.conPassword,
          changeError: (v) {
            cubit.errorPassword = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorPassword > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorPassword == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        SizedBox(height: Resizable.size(context, 10)),
        PasswordTextField(
          hintText: AppText.textHintReEnterPassword.text,
          icon: Icons.lock_outline,
          controller: cubit.conRePassword,
          changeError: (v) {
            cubit.errorRePassword = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorRePassword > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorRePassword == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        if (cubit.errorRePassword == 2)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textRePasswordNotMatch.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
      ],
    );
  }
}
