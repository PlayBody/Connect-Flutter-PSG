import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'messages.dart';

class Dialogs {
  Future<void> loaderDialogNormal(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }

  void infoDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<bool> confirmDialog(BuildContext context, String message) async {
    final value = await showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text(message),
        // content: Text("Action cannot be undone."),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("はい"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          BasicDialogAction(
            title: Text("いいえ"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
    return value == true;
  }

  Future<String> selectDialog(
      BuildContext context, String title, List<dynamic> listString) async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          Row(children: [
            ...listString.map((e) => Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: ElevatedButton(
                      child: Text(e['val']),
                      onPressed: () => Navigator.of(context).pop(e['key']),
                    ))))
          ])
        ],
      ),
    );

    return value.toString();
  }

  Future<bool> waitDialog(BuildContext context, String msg) async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(msg),
        actions: [
          TextButton(
            child: const Text('閉じる'),
            onPressed: () => {Navigator.of(context).pop(true)},
          ),
        ],
      ),
    );
    return value == true;
  }

  Future<bool> oldVersionDialog(BuildContext context, String url) async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(warningVersionUpdate),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => {Navigator.of(context).pop(true)},
          ),
        ],
      ),
    );
    return value == true;
  }

  Future<bool> retryOrExit(BuildContext context, String message) async {
    final value = await showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text(message),
        // content: Text("Action cannot be undone."),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("リトライ"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          BasicDialogAction(
            title: Text("終了"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
    return value == true;
  }
}
