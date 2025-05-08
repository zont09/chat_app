import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/login/bloc/signup_cubit.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        UsernameTextField(
          hintText: 'Email',
          icon: Icons.email_outlined,
          controller: cubit.conEmail,
          isError: cubit.errorEmail > 0,
          changeError: (v) {
            cubit.errorEmail = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorEmail > 0) SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorEmail == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w300,
                    color: ColorConfig.error)),
          ),
        if (cubit.errorEmail == 2)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Text(AppText.textInvalidEmail.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w300,
                    color: ColorConfig.error)),
          ),

        SizedBox(height: Resizable.size(context, 10)),

        // Username field
        UsernameTextField(
          hintText: 'Username',
          icon: Icons.person_outlined,
          controller: cubit.conUsername,
          isError: cubit.errorUsername > 0,
          changeError: (v) {
            cubit.errorUsername = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorUsername > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorUsername == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w300,
                    color: ColorConfig.error)),
          ),

        SizedBox(height: Resizable.size(context, 10)),

        // Password field
        PasswordTextField(
          hintText: 'Password',
          icon: Icons.lock_outline,
          controller: cubit.conPassword,
          isError: cubit.errorPassword > 0,
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
            child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w300,
                    color: ColorConfig.error)),
          ),

        SizedBox(height: Resizable.size(context, 10)),

        // Confirm Password field
        PasswordTextField(
          hintText: 'Confirm Password',
          icon: Icons.lock_outline,
          controller: cubit.conConfirmPassword,
          isError: cubit.errorConfirmPassword > 0,
          changeError: (v) {
            cubit.errorConfirmPassword = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorConfirmPassword > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorConfirmPassword == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w300,
                    color: ColorConfig.error)),
          ),
        if (cubit.errorConfirmPassword == 2)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Text('Passwords do not match',
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w300,
                    color: ColorConfig.error)),
          ),
      ],
    );
  }
}
