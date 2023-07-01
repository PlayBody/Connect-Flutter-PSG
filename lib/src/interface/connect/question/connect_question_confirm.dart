import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;

class ConnectQuestionConfirm extends StatefulWidget {
  final String title;
  final String question;
  const ConnectQuestionConfirm(
      {required this.title, required this.question, Key? key})
      : super(key: key);

  @override
  _ConnectQuestionConfirm createState() => _ConnectQuestionConfirm();
}

class _ConnectQuestionConfirm extends State<ConnectQuestionConfirm> {
  var titleController = TextEditingController();
  var questionController = TextEditingController();

  String? errTitle;
  String? errQuestion;

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveQuestion() async {
    bool conf = await Dialogs().confirmDialog(context, qCommonSave);

    if (!conf) return;

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiSaveQuestionUrl, {
      'user_id': globals.userId,
      'title': widget.title,
      'question': widget.question,
    }).then((value) => results = value);

    if (results['isSave']) {
    } else {
      Dialogs().infoDialog(context, errServerActionFail);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '確認画面',
      render: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                _getLabelTitle(),
                _getTitleContent(),
                _getLabelQuestion(),
                _getQuestionContent(),
              ],
            )),
            _getQuestionButton()
          ],
        ),
      ),
    );
  }

  var txtlblStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  var txtContentStyle = TextStyle(fontSize: 16);
  var decoration = InputDecoration();

  Widget _getLabelTitle() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Text('タイトル', style: txtlblStyle));
  }

  Widget _getLabelQuestion() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.only(top: 16, left: 30, right: 30),
      child: Text('お問い合わせ内容', style: txtlblStyle),
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
    );
  }

  Widget _getTitleContent() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Text(widget.title, style: txtContentStyle),
    );
  }

  Widget _getQuestionContent() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Text(widget.question, style: txtContentStyle),
    );
  }

  Widget _getQuestionButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      padding: EdgeInsets.only(top: 40),
      child: ElevatedButton(
        child: Text('送信する'),
        onPressed: () {
          saveQuestion();
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8), textStyle: TextStyle(fontSize: 16)),
      ),
    );
  }
}
