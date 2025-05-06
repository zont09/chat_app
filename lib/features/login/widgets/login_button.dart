import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/login/bloc/login_cubit.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:chat_app/widgets/z_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.cubit,
  });

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ZButton(
        title: cubit.isLoading ? 'Processing...' : AppText.textLogin.text,
        onPressed: cubit.isLoading
            ? () => null
            : () async {
                // Hide keyboard
                FocusScope.of(context).unfocus();

                final response = await cubit.login();

                if (response != null) {
                  // Navigate to home screen on successful login
                  context.go(Routes.home);
                } else {
                  // Show error dialog if login fails
                  DialogUtils.showResultDialog(
                    context,
                    AppText.textHasError.text,
                    response?.message ??
                        'Login failed. Please check your credentials and try again.',
                  );
                }
              },
        paddingHor: 20,
        sizeTitle: 16,
        fontWeight: FontWeight.w600,
        colorBackground: ColorConfig.primary2,
        isShadow: true);
  }
}
