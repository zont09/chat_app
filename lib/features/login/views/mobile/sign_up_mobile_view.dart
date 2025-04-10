import 'package:chat_app/app_texts.dart';
import 'package:chat_app/features/login/bloc/sign_up_cubit.dart';
import 'package:chat_app/features/login/views/mobile/sign_up_textfield_view.dart';
import 'package:chat_app/features/login/widgets/gradient_text.dart';
import 'package:chat_app/features/login/widgets/sign_up_button.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpMobileView extends StatelessWidget {
  const SignUpMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocBuilder<SignUpCubit, int>(
          builder: (c, s) {
            var cubit = BlocProvider.of<SignUpCubit>(c);
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              padding:
                  EdgeInsets.symmetric(horizontal: Resizable.size(context, 20)),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientText(
                      AppText.textSignUp.text.toUpperCase(),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF74CEF7), Color(0xFF43EDDE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      style: TextStyle(
                          fontSize: Resizable.font(context, 40),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Resizable.size(context, 20)),
                    SignUpTextFieldView(cubit: cubit),
                    SizedBox(height: Resizable.size(context, 20)),
                    SignUpButton(cubit: cubit),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
