import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';

class ZButton extends StatelessWidget {
  const ZButton(
      {super.key,
      required this.title,
      this.icon,
      required this.onPressed,
      this.sizeTitle = 14,
      this.colorTitle = ColorConfig.textPrimary,
      this.sizeIcon = 16,
      this.colorIcon = ColorConfig.primary2,
      this.colorBorder = ColorConfig.primary2,
      this.colorBackground = ColorConfig.primary2,
      this.paddingHor = 8,
      this.paddingVer = 8,
      this.fontWeight = FontWeight.w500,
      this.radius = 229,
      this.fontFamily = 'Afacad',
      this.suffix,
      this.isShadow = false,
      this.shadowText,
      this.maxWidth,
      this.enable = true});

  final String title;
  final String? icon;
  final Function() onPressed;

  final double sizeTitle;
  final Color colorTitle;
  final double sizeIcon;
  final Color colorIcon;
  final Color colorBorder;
  final Color colorBackground;
  final double paddingHor;
  final double paddingVer;
  final FontWeight fontWeight;
  final double radius;
  final String fontFamily;
  final Widget? suffix;
  final bool isShadow;
  final List<BoxShadow>? shadowText;
  final double? maxWidth;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enable,
      child: Stack(
        children: [
          Container(
            width: maxWidth,
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.size(context, paddingHor),
              vertical: Resizable.size(context, paddingVer),
            ),
            decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: colorBorder),
                boxShadow: isShadow
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: Resizable.size(context, 4),
                            offset: Offset(0, Resizable.size(context, 2)))
                      ]
                    : []),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && icon!.isNotEmpty)
                  Image.asset(
                    icon!,
                    height: Resizable.font(context, sizeIcon),
                    color: colorIcon,
                  ),
                if (icon != null && icon!.isNotEmpty)
                  SizedBox(width: Resizable.size(context, 6)),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: Resizable.font(context, sizeTitle),
                      fontWeight: fontWeight,
                      fontFamily: fontFamily,
                      color: colorTitle,
                      shadows: shadowText),
                ),
                if (suffix != null) SizedBox(width: Resizable.size(context, 9)),
                if (suffix != null) suffix!,
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: onPressed,
                splashColor: Colors.grey.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
