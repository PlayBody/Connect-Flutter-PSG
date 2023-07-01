// import 'package:crm_app/common/const.dart';

import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/button/account_button.dart';
import 'package:connect/src/interface/component/text/input_texts.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:connect/src/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/globals.dart' as globals;

class ConnectLogin extends StatefulWidget {
  const ConnectLogin({Key? key}) : super(key: key);

  @override
  _ConnectLogin createState() => _ConnectLogin();
}

class _ConnectLogin extends State<ConnectLogin> {
  var txtMailController = TextEditingController();
  var txtPassController = TextEditingController();

  String? errMail;
  String? errPass;

  late Future<List> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadUserInfo();
  }

  Future<List> loadUserInfo() async {
    return [];
  }

  Future<void> saveUserInfo() async {
    bool isCheck = true;

    if (txtMailController.text == '') {
      isCheck = false;
      errMail = 'メールアドレスを入力してください。';
    } else {
      errMail = null;
    }
    if (txtPassController.text == '') {
      isCheck = false;
      errPass = 'パスウードを入力してください。';
    } else {
      errPass = null;
    }

    setState(() {});

    if (!isCheck) return;

    UserModel? user = await ClUser().getUserModel(context, {
      'company_id': APPCOMANYID,
      'user_email': txtMailController.text,
      'user_password': txtPassController.text
    });

    if (user != null) {
      globals.userId = user.userId;
      globals.userName = user.userFirstName + ' ' + user.userLastName;
      await ClUser()
          .updateDeviceToken(context, user.userId, globals.connectDeviceToken);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('is_rirakukan_login_id', user.userId);

      Navigator.pushNamed(context, '/Home');
    } else {
      Dialogs().infoDialog(context, 'ログイン情報が正しくありません。');
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
                        SizedBox(height: 12),
                        _getContentTitle('パスワード'),
                        SizedBox(height: 4),
                        _getUserPassword(),
                        SizedBox(height: 64),
                        _getButton(),
                        SizedBox(height: 24),
                        TextButton(
                          child: Text(
                            'パスワードを忘れましたか？',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/Reset'),
                        ),
                        TextButton(
                          child: Text(
                            '新規会員登録画面へ',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/Register'),
                        ),
                        TextButton(
                          child: Text(
                            'ホーム画面へ',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/Home'),
                        )
                      ],
                    )),
                  );
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
            fit: BoxFit.cover,
          )),
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

  Widget _getUserPassword() {
    return Container(
      child: TextInputNormal(
        isPassword: true,
        controller: txtPassController,
        inputType: TextInputType.text,
        errorText: errPass,
      ),
    );
  }

  Widget _getButton() {
    return AccountButton(tapFunc: () => saveUserInfo(), label: 'ログイン');
  }
}
