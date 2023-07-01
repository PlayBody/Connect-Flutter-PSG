import 'package:connect/src/common/messages.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:flutter/material.dart';
import 'connect_question_confirm.dart';

class ConnectQuestionAdd extends StatefulWidget {
  const ConnectQuestionAdd({Key? key}) : super(key: key);

  @override
  _ConnectQuestionAdd createState() => _ConnectQuestionAdd();
}

class _ConnectQuestionAdd extends State<ConnectQuestionAdd> {
  var titleController = TextEditingController();
  var questionController = TextEditingController();

  String? errTitle;
  String? errQuestion;

  @override
  void initState() {
    super.initState();
  }

  void pushConfirm() {
    bool isFormCheck = true;
    if (titleController.text == '') {
      isFormCheck = false;
      errTitle = warningCommonInputRequire;
    } else {
      errTitle = null;
    }
    if (questionController.text == '') {
      isFormCheck = false;
      errQuestion = warningCommonInputRequire;
    } else {
      errQuestion = null;
    }
    setState(() {});

    if (!isFormCheck) return;

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ConnectQuestionConfirm(
          title: titleController.text, question: questionController.text);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'お問い合わせ',
      render: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _getLabelTitle(),
                _getInputTitle(),
                _getLabelContent(),
                _getInputContent(),
              ],
            ))),
            _getQuestionButton()
          ],
        ),
      ),
    );
  }

  var txtlblStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  var decoration = InputDecoration();

  Widget _getLabelTitle() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Text('タイトル', style: txtlblStyle));
  }

  Widget _getLabelContent() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.only(top: 16, left: 30, right: 30),
      child: Text('お問い合わせ内容', style: txtlblStyle),
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
    );
  }

  Widget _getInputTitle() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        controller: titleController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          hintText: '例：新規会員登録について',
          errorText: errTitle,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _getInputContent() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        controller: questionController,
        maxLines: 10,
        decoration: InputDecoration(
          errorText: errQuestion,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _getQuestionButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: ElevatedButton(
        child: Text('確認画面へ'),
        onPressed: () {
          pushConfirm();
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8), textStyle: TextStyle(fontSize: 16)),
      ),
    );
  }
}
