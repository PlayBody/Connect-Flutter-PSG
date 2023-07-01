import 'package:flutter/material.dart';

class Header1Text extends StatelessWidget {
  final String label;
  const Header1Text({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    );
  }
}

class Header3Text extends StatelessWidget {
  final String label;
  const Header3Text({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }
}

class Header4Text extends StatelessWidget {
  final String label;
  const Header4Text({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
