import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/button/account_button.dart';
import 'package:connect/src/interface/component/text/input_texts.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordReset createState() => _PasswordReset();
}

class _PasswordReset extends State<PasswordReset> {
  var txtMailController = TextEditingController();
  var txtPassController = TextEditingController();

  String? errMail;
  String? errPass;

  bool iscomplete = false;

  late Future<List> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadUserInfo();
  }

  Future<List> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_rirakukan_login', false);

    return [];
  }

  Future<void> sendMail() async {
    bool isCheck = true;

    if (txtMailController.text == '') {
      isCheck = false;
      errMail = 'メールアドレスを入力してください。';
    } else {
      errMail = null;
    }
    setState(() {});

    if (!isCheck) return;

    Dialogs().loaderDialogNormal(context);
    bool isSend =
        await ClUser().sendResetEmail(context, txtMailController.text);

    Navigator.pop(context);

    if (isSend) {
      iscomplete = true;
      setState(() {});
    } else {
      errMail = '登録されていないメールアドレスです。';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: FutureBuilder<List>(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (iscomplete)
                    return _completeContent();
                  else
                    return _sendContent();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/login_back.jpg'),
                  fit: BoxFit.cover)),
        ));
  }

  Widget _sendContent() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 60),
          _getShopTitle(),
          SizedBox(height: 80),
          _getContentTitle('メールアドレス'),
          SizedBox(height: 4),
          _getEmailInput(),
          SizedBox(height: 64),
          _getButton(),
          SizedBox(height: 24),
          TextButton(
            child: Text('ログイン画面に',
                style: TextStyle(color: Colors.black.withOpacity(0.5))),
            onPressed: () => Navigator.pop(context),
          )
        ],
      )),
    );
  }

  Widget _completeContent() {
    return Container(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          children: [
            SizedBox(height: 60),
            _getShopTitle(),
            SizedBox(height: 80),
            _getContentTitle('パスワードがメールで送信されました。'),
            SizedBox(height: 80),
            TextButton(
                child: Text(
                  '再送信する',
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
                onPressed: () => sendMail()),
            TextButton(
              child: Text(
                'ログイン画面に',
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  }

  Widget _getShopTitle() {
    return Container(
      child: Text(
        APPCOMPANYTITLE,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getContentTitle(_title) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      alignment: Alignment.centerLeft,
      child: InputLabel(label: _title),
    );
  }

  Widget _getEmailInput() {
    return Container(
      child: TextInputNormal(
          controller: txtMailController,
          inputType: TextInputType.emailAddress,
          errorText: errMail),
    );
  }

  Widget _getButton() {
    return AccountButton(tapFunc: () => sendMail(), label: 'メール送信');
  }
}
