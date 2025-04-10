import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final Color border;
  final bool isError;
  final double radius;
  final Function(int)? changeError;

  const TextFieldCustom(
      {super.key,
      required this.hintText,
      required this.icon,
      this.controller,
      this.border = ColorConfig.border6,
      this.isError = false,
      this.radius = 229,
      this.changeError});

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  void initState() {
    widget.controller?.addListener(listenerController);
    super.initState();
  }

  listenerController() {
    if (widget.isError && widget.changeError != null) {
      widget.changeError!(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: const [ColorConfig.boxShadow],
      ),
      child: TextField(
        controller: widget.controller,
        cursorHeight: Resizable.font(context, 16),
        cursorColor: ColorConfig.primary1,
        style: TextStyle(
            fontSize: Resizable.font(context, 16),
            color: ColorConfig.primary1,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(widget.icon,
                  color: ColorConfig.primary1,
                  size: Resizable.size(context, 20))
              : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: Resizable.font(context, 16),
              color: ColorConfig.hintText,
              fontWeight: FontWeight.w400),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(
                color: widget.isError ? ColorConfig.error : ColorConfig.border6,
                width: Resizable.size(context, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(
                color: widget.isError ? ColorConfig.error : widget.border,
                width: Resizable.size(context, 1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(
                color:
                    widget.isError ? ColorConfig.error : ColorConfig.primary1,
                width: 2),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
              vertical: Resizable.size(context, 6),
              horizontal: Resizable.size(context, 12)),
        ),
      ),
    );
  }
}
