import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String label;
  const InputLabel({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2));
  }
}

class TextLabel extends StatelessWidget {
  final String label;
  const TextLabel({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(fontSize: 16, letterSpacing: 2));
  }
}

class DlgHeaderText extends StatelessWidget {
  final String label;
  const DlgHeaderText({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(label,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)));
  }
}

class DlgSubHeaderText extends StatelessWidget {
  final String label;
  const DlgSubHeaderText({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 24),
        child: Text(label, style: TextStyle(fontSize: 20, letterSpacing: 2)));
  }
}

class LeftSectionTitleText extends StatelessWidget {
  final String label;
  const LeftSectionTitleText({required this.label, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 16, bottom: 12),
        alignment: Alignment.centerLeft,
        child: Text(label,
            style: TextStyle(
                fontSize: 20, letterSpacing: 1, fontWeight: FontWeight.bold)));
  }
}

class CommentTitleText extends StatelessWidget {
  final String label;
  const CommentTitleText({required this.label, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(label, style: TextStyle(fontSize: 18, letterSpacing: 2)));
  }
}

class CommentText extends StatelessWidget {
  final String label;
  const CommentText({required this.label, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        alignment: Alignment.centerLeft,
        child: Text(label, style: TextStyle(fontSize: 12)));
  }
}

class CommentBigText extends StatelessWidget {
  final String label;
  const CommentBigText({required this.label, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        alignment: Alignment.centerLeft,
        child: Text(label, style: TextStyle(fontSize: 16)));
  }
}
