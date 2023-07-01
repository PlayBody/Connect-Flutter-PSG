import 'package:flutter/material.dart';

class PushDialogs extends StatelessWidget {
  final Widget render;
  const PushDialogs({required this.render, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: SingleChildScrollView(
              child: render,
            ),
          ),
        ],
      ),
    );
  }
}
