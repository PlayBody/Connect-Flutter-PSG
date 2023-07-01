import 'package:flutter/material.dart';

class IncreaseView extends StatelessWidget {
  final int value;
  const IncreaseView({required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        width: 60,
        height: 30,
        child: Text(
          value.toString(),
          style: TextStyle(fontSize: 18),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6)));
  }
}
