import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterVerify extends StatefulWidget {
  final dynamic saveData;
  const RegisterVerify({Key? key, required this.saveData}) : super(key: key);

  @override
  _RegisterVerify createState() => _RegisterVerify();
}

class _RegisterVerify extends State<RegisterVerify> {
  List<String> numItems = [
    '7',
    '8',
    '9',
    '4',
    '5',
    '6',
    '1',
    '2',
    '3',
    '',
    '0',
    '←',
  ];

  late Future<List> loadData;

  String verifyCode = "";
  String errorText = "";

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

  Future<void> registerUser() async {
    Dialogs().loaderDialogNormal(context);
    dynamic param = widget.saveData;
    param['code'] = verifyCode;

    bool isRegister = await ClUser().userRegister(context, param);

    Navigator.pop(context);
    if (isRegister) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('is_rirakukan_login_id', param['user_id']);

      Navigator.pushNamed(context, '/Home');
      return;
    }

    verifyCode = '';
    errorText = "認証コードが正しくありません。";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    _getEmailInput(),
                    SizedBox(height: 16),
                    Container(
                        child: Text(errorText,
                            style: TextStyle(color: Colors.red))),
                    SizedBox(height: 44),
                    Text('セキュリティコード'),
                    SizedBox(height: 24),
                    _numberInput(),
                    TextButton(
                      autofocus: true,
                      child: Text(
                        '新規会員登録画面へ',
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
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
    );
  }

  Widget _getShopTitle() {
    return Container(
      child: Text(
        APPCOMPANYTITLE,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getEmailInput() {
    return Row(
      children: [
        Expanded(child: Container()),
        _getVerifyCodeItem(
            verifyCode.length > 0 ? verifyCode.substring(0, 1) : ''),
        Expanded(child: Container()),
        _getVerifyCodeItem(
            verifyCode.length > 1 ? verifyCode.substring(1, 2) : ''),
        Expanded(child: Container()),
        _getVerifyCodeItem(
            verifyCode.length > 2 ? verifyCode.substring(2, 3) : ''),
        Expanded(child: Container()),
        _getVerifyCodeItem(
            verifyCode.length > 3 ? verifyCode.substring(3, 4) : ''),
        Expanded(child: Container()),
      ],
    );
  }

  Widget _getVerifyCodeItem(String code) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      width: 50,
      child: Text(
        code,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _numberInput() {
    return Container(
        child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.9,
            children: [...numItems.map((num) => _getNumpadContent(num))]));
  }

  Widget _getNumpadContent(num) {
    return GestureDetector(
        onTap: () {
          errorText = '';
          setState(() {});
          if (num == '') return;
          if (num == '←') {
            if (verifyCode.length < 1) return;
            verifyCode = verifyCode.substring(0, verifyCode.length - 1);
          } else {
            verifyCode = verifyCode + num;
          }
          if (verifyCode.length == 4) {
            registerUser();
          }
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            num,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ));
  }
}
