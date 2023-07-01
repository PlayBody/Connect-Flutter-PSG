import 'package:flutter/material.dart';

class UserTextInputDefualt extends StatelessWidget {
  final controller;
  final hintText;
  final String? errorText;
  const UserTextInputDefualt({
    required this.controller,
    required this.hintText,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          isDense: true,
          hintText: hintText,
          errorText: errorText,
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
