import 'package:flutter/material.dart';

class TextInputNormal extends StatelessWidget {
  final controller;
  final String? hintText;
  final String? errorText;
  final double? contentPadding;
  final TextInputType? inputType;
  final bool? isPassword;
  final bool? isCenter;
  final double? fontSize;
  final bool? isEnabled;
  final int? multiline;
  const TextInputNormal(
      {required this.controller,
      this.errorText,
      this.hintText,
      this.contentPadding,
      this.inputType,
      this.isPassword,
      this.isCenter,
      this.fontSize,
      this.isEnabled,
      this.multiline,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: multiline == null ? 1 : multiline,
      enabled: isEnabled == null ? true : isEnabled,
      textAlign:
          (isCenter == null || false) ? TextAlign.left : TextAlign.center,
      obscureText: isPassword == null ? false : isPassword!,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        errorText: errorText,
        isDense: true,
        contentPadding:
            EdgeInsets.all(contentPadding == null ? 14 : contentPadding!),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFbebebe)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFbebebe)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFbebebe)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      style: TextStyle(fontSize: fontSize == null ? 14 : fontSize),
    );
  }
}
