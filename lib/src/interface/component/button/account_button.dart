import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final String label;
  final tapFunc;
  const AccountButton({required this.label, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 280,
        child: ElevatedButton(
          onPressed: tapFunc,
          child: Text(label),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              primary: Colors.black,
              onPrimary: Colors.white,
              textStyle: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ));
  }
}

class DeleteAccountButton extends StatelessWidget {
  final String label;
  final tapFunc;
  const DeleteAccountButton(
      {required this.label, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 280,
        child: ElevatedButton(
          onPressed: tapFunc,
          child: Text(label),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              primary: Colors.red,
              onPrimary: Colors.white,
              textStyle: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ));
  }
}
