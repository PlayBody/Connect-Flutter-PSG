import 'package:flutter/material.dart';

class DropDownModelSelect extends StatelessWidget {
  final String? value;
  final dropdownState;
  final List<DropdownMenuItem> items;
  final contentPadding;
  final String? hint;
  final tapFunc;
  const DropDownModelSelect(
      {this.value,
      required this.items,
      this.dropdownState,
      this.contentPadding,
      required this.tapFunc,
      this.hint,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: dropdownState,
      hint: Text(hint == null ? '' : hint!),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffbebebe),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffbebebe),
          ),
        ),
        contentPadding: contentPadding == null
            ? EdgeInsets.fromLTRB(8, 12, 0, 12)
            : contentPadding,
      ),
      value: value,
      items: items,
      onChanged: tapFunc,
    );
  }
}
