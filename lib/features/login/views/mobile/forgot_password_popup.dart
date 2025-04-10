import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:chat_app/widgets/textfield_custom.dart';
import 'package:chat_app/widgets/z_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPopup extends StatefulWidget {
  const ForgotPasswordPopup({super.key});

  @override
  State<ForgotPasswordPopup> createState() => _ForgotPasswordPopupState();
}

class _ForgotPasswordPopupState extends State<ForgotPasswordPopup> {
  final TextEditingController controller = TextEditingController();
  int isError = -1;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(Resizable.size(context, 12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Text(AppText.textForgotPassword.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.primary2)),
            ),
            SizedBox(height: Resizable.size(context, 12)),
            TextFieldCustom(
                hintText: AppText.textHintEmailForgotPassword.text,
                icon: null,
                controller: controller,
                changeError: (v) {
                  setState(() {
                    isError = v;
                  });
                },
                isError: isError > 0,
                radius: 8),
            if (isError > 0)
              SizedBox(height: Resizable.size(context, 3)),
            if (isError == 1)
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
            if (isError == 2)
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
            SizedBox(height: Resizable.size(context, 12)),
            ZButton(
              title: AppText.btnSendRequest.text,
              colorBackground: ColorConfig.primary2,
              colorBorder: ColorConfig.primary2,
              sizeTitle: 16,
              icon: "",
              paddingHor: 20,
              paddingVer: 4,
              fontWeight: FontWeight.w500,
              onPressed: () async {

              },
            ),
          ],
        ),
      ),
    );
  }

  bool checkError() {
    setState(() {
      if (controller.text.isEmpty) {
        isError = 1;
      } else if (!isValidEmail(controller.text)) {
        isError = 2;
      } else {
        isError = 0;
      }
    });
    return isError > 0;
  }

  bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }
}
