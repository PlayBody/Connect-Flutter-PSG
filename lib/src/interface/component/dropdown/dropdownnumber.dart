import 'package:flutter/material.dart';

class DropDownNumberSelect extends StatelessWidget {
  final String? value;
  final int? diff;
  final int? min;
  final contentPadding;
  final int max;
  final tapFunc;
  const DropDownNumberSelect(
      {this.value,
      required this.max,
      required this.tapFunc,
      this.diff,
      this.contentPadding,
      this.min,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> itemList = [];
    int _start = min == null ? 1 : min!;
    int _dff = diff == null ? 1 : diff!;
    for (var i = _start; i <= max; i = i + _dff) {
      itemList.add(i.toString());
    }
    return DropdownButtonFormField(
      isExpanded: true,
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
            ? EdgeInsets.fromLTRB(8, 8, 0, 8)
            : contentPadding,
      ),
      value: value,
      items: [
        ...itemList.map((e) => DropdownMenuItem(
            child: Text(e, textAlign: TextAlign.right), value: e))
      ],
      onChanged: tapFunc,
    );
  }
}
