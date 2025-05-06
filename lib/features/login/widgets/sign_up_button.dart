import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/login/bloc/signup_cubit.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:chat_app/widgets/z_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.cubit,
  });

  final SignUpCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ZButton(
        title: cubit.isLoading ? 'Processing...' : AppText.textSignUp.text,
        onPressed: cubit.isLoading
            ? () => null
            : () async {
                // Hide keyboard
                FocusScope.of(context).unfocus();

                final response = await cubit.register();

                if (response != null) {
                  // Navigate to home screen on successful registration
                  context.go(Routes.home);
                } else {
                  // Show error dialog if registration fails
                  DialogUtils.showResultDialog(
                    context,
                    AppText.textHasError.text,
                    'Registration failed. The email might be already in use or there was a server error.',
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
