import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/login/bloc/login_cubit.dart';
import 'package:chat_app/features/login/views/mobile/login_textfield_view.dart';
import 'package:chat_app/features/login/views/mobile/sign_up_mobile_view.dart';
import 'package:chat_app/features/login/widgets/login_button.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginMobileView extends StatelessWidget {
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<LoginCubit>(c);
          return Material(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.size(context, 20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png',
                        height: Resizable.size(context, 120)),
                    SizedBox(height: Resizable.size(context, 40)),
                    LoginTextFieldView(cubit: cubit),
                    SizedBox(height: Resizable.size(context, 15)),
                    LoginButton(cubit: cubit),
                    SizedBox(height: Resizable.size(context, 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppText.textNoAccount.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 14),
                                fontWeight: FontWeight.w500,
                                color: ColorConfig.textColor7)),
                        InkWell(
                          onTap: () {
                            context.push(Routes.register);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => SignUpMobileView()));
                          },
                          child: Text(AppText.textCreateAccountNow.text,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 14),
                                  fontWeight: FontWeight.w500,
                                  color: ColorConfig.primary2)),
                        ),
                      ],
                    ),
                    SizedBox(height: Resizable.size(context, 80)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
