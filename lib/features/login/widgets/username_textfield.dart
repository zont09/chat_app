import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';

class UsernameTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final Color border;
  final bool isError;
  final Function(int)? changeError;

  const UsernameTextField(
      {super.key,
      required this.hintText,
      required this.icon,
      this.controller,
      this.border = ColorConfig.border6,
      this.isError = false,
      this.changeError});

  @override
  State<UsernameTextField> createState() => _UsernameTextFieldState();
}

class _UsernameTextFieldState extends State<UsernameTextField> {

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
        borderRadius: BorderRadius.circular(229), // Bo góc 8px
        boxShadow: const [ColorConfig.boxShadow],
      ),
      child: TextField(
        controller: widget.controller,
        cursorColor: ColorConfig.primary1,
        style: TextStyle(
            fontSize: Resizable.font(context, 16),
            color: ColorConfig.primary1,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon,
              color: ColorConfig.primary1, size: Resizable.size(context, 20)),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: Resizable.font(context, 16),
              color: ColorConfig.hintText,
              fontWeight: FontWeight.w400),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(229),
            borderSide: BorderSide(
                color: widget.isError ? ColorConfig.error : ColorConfig.border6,
                width: Resizable.size(context, 1)), // Viền khi focus
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(229),
            borderSide: BorderSide(
                color: widget.isError ? ColorConfig.error : widget.border,
                width: Resizable.size(context, 1)), // Viền khi focus
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(229),
            borderSide: BorderSide(
                color: widget.isError ? ColorConfig.error : ColorConfig.primary1,
                width: 2), // Viền khi focus
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
