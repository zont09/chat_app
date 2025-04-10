import 'dart:async';
import 'package:chat_app/app_texts.dart';
import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:chat_app/widgets/z_button.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: ColorConfig.primary1,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showResultDialog(
      BuildContext context, String title, String message,
      {Color mainColor = ColorConfig.primary2}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Cùng kiểu bo góc
        ),
        contentPadding: EdgeInsets.symmetric(
                vertical: Resizable.size(context, 12),
                horizontal: Resizable.size(context, 12))
            .copyWith(bottom: Resizable.size(context, 12)),
        // Cùng padding
        content: SizedBox(
          width: Resizable.size(context, 436),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Resizable.size(context, 8)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Resizable.font(context, 16),
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZButton(
                    title: AppText.btnOk.text,
                    colorBackground: mainColor,
                    // Dùng màu chính
                    colorBorder: mainColor,
                    sizeTitle: 16,
                    icon: "",
                    paddingHor: 25,
                    paddingVer: 4,
                    fontWeight: FontWeight.w500,
                    // Đảm bảo padding giống Confirm
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
        // actionsPadding: EdgeInsets.symmetric(
        //   horizontal: Resizable.size(context, 12),
        //   vertical: Resizable.size(context, 12),
        // ),
        // actions: [
        //
        // ],
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    Color mainColor = ColorConfig.primary2,
    Color confirmColor = ColorConfig.error,
    Color cancelColor = ColorConfig.primary3,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: EdgeInsets.all(Resizable.size(context, 25)),
        content: SizedBox(
          width: Resizable.size(context, 450),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 24),
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 18),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(
            horizontal: Resizable.size(context, 25),
            vertical: Resizable.size(context, 25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ZButton(
                title: AppText.btnCancel.text,
                colorBackground: Colors.white,
                colorTitle: cancelColor,
                sizeTitle: 16,
                icon: "",
                paddingHor: 35,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
              SizedBox(width: Resizable.size(context, 20)),
              ZButton(
                title: AppText.btnConfirm.text,
                colorBackground: confirmColor,
                colorBorder: confirmColor,
                sizeTitle: 16,
                icon: "",
                paddingHor: 20,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  static showAlertDialog(BuildContext context,
      {bool barrierDismissible = true, required Widget child}) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Resizable.size(context, 12)),
            ),
            child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: Resizable.size(context, 4),
                      offset: Offset(0, Resizable.size(context, 2)),
                    ),
                  ],
                ),
                child: child));
      },
    );
  }
}

enum DialogState { success, error }
