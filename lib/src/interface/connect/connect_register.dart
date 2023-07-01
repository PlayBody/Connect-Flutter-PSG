// import 'package:crm_app/common/const.dart';
import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/interface/component/button/account_button.dart';
import 'package:connect/src/interface/component/text/input_texts.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:connect/src/interface/connect/connect_login.dart';
import 'package:connect/src/interface/connect/register_verify.dart';
import 'package:connect/src/model/usermodel.dart';
import 'package:flutter/material.dart';

import '../../common/globals.dart' as globals;

class ConnectRegister extends StatefulWidget {
  final bool? isProfile;
  const ConnectRegister({this.isProfile, Key? key}) : super(key: key);

  @override
  _ConnectRegister createState() => _ConnectRegister();
}

class _ConnectRegister extends State<ConnectRegister> {
  var _groupValue = '1';

  String selectYear = DateTime.now().year.toString();
  String selectMonth = DateTime.now().month.toString();
  String selectDay = DateTime.now().day.toString();
  List<String> yearsList = [];
  List<String> monthsList = [];
  int days = Funcs().getMaxDays(null, null);

  var txtFirstNameController = TextEditingController();
  var txtLastNameController = TextEditingController();
  var txtAliasController = TextEditingController();
  var txtPhoneController = TextEditingController();
  var txtMailController = TextEditingController();
  var txtPassController = TextEditingController();

  String? errFirstName;
  String? errLastName;
  String? errAlias;
  String? errPhone;
  String? errMail;
  String? errPass;

  bool isEditable = true;

  String appVersion = '';

  late Future<List> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadUserInfo();
  }

  Future<List> loadUserInfo() async {
    if (globals.userId == '') return [];

    UserModel userInfo = await ClUser().getUserFromId(context, globals.userId);

    txtFirstNameController.text = userInfo.userFirstName;
    txtLastNameController.text = userInfo.userLastName;
    txtAliasController.text = userInfo.userNick;
    txtPhoneController.text = userInfo.userTel;
    txtMailController.text = userInfo.userEmail;
    _groupValue = userInfo.userSex;

    DateTime birth = DateTime.parse(userInfo.userBirth);
    selectYear = birth.year.toString();
    selectMonth = birth.month.toString();
    selectDay = birth.day.toString();

    if (userInfo.password == '') {
      txtPassController.text = '';
    } else {
      txtPassController.text = 'oldpassword';
    }

    isEditable = false;

    setState(() {});
    return [];
  }

  Future<void> saveUserInfo() async {
    String strSex = _groupValue.toString();
    String strBirthDay = selectYear + "-" + selectMonth + "-" + selectDay;

    if (!isFormCheck()) return;

    Dialogs().loaderDialogNormal(context);
    UserModel? checkuser = await ClUser().getUserModel(context,
        {'company_id': APPCOMANYID, 'user_email': txtMailController.text});

    if (checkuser != null) {
      errMail = "入力されたメールアドレスは使用中です。";
      setState(() {});
      Navigator.pop(context);
      return;
    }

    await ClUser().regVerifyCode(context, txtMailController.text);
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return RegisterVerify(saveData: {
        'user_id': globals.userId,
        'company_id': APPCOMANYID,
        'user_first_name': txtFirstNameController.text,
        'user_last_name': txtLastNameController.text,
        'user_nick': txtAliasController.text,
        'user_tel': txtPhoneController.text,
        'user_email': txtMailController.text,
        'user_sex': strSex,
        'user_birthday': strBirthDay,
        'user_device_token': globals.connectDeviceToken,
        'user_password': txtPassController.text
      });
    }));
  }

  Future<void> deleteAccount() async {
    bool conf = await Dialogs().confirmDialog(context, qCommonDelete);
    if (!conf) return;
    bool isDelete = await ClUser().deleteUser(context, globals.userId);
    if (isDelete)
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ConnectLogin();
      }));
  }

  Future<void> updateUserInfo() async {
    String strSex = _groupValue.toString();
    String strBirthDay = selectYear + "-" + selectMonth + "-" + selectDay;

    if (!isFormCheck()) return;

    Dialogs().loaderDialogNormal(context);
    dynamic param = {
      'user_id': globals.userId,
      'company_id': APPCOMANYID,
      'user_first_name': txtFirstNameController.text,
      'user_last_name': txtLastNameController.text,
      'user_nick': txtAliasController.text,
      'user_tel': txtPhoneController.text,
      'user_sex': strSex,
      'user_birthday': strBirthDay,
      'user_device_token': globals.connectDeviceToken,
      'user_password': txtPassController.text
    };
    await ClUser().updateUserProfile(context, param);
    Navigator.pop(context);

    globals.userName =
        txtFirstNameController.text + ' ' + txtLastNameController.text;
    Navigator.pushNamed(context, '/Home');
  }

  bool isFormCheck() {
    bool isCheck = true;
    if (txtFirstNameController.text == '') {
      isCheck = false;
      errFirstName = warningCommonInputRequire;
    } else {
      errFirstName = null;
    }

    if (txtLastNameController.text == '') {
      isCheck = false;
      errLastName = warningCommonInputRequire;
    } else {
      errLastName = null;
    }

    if (txtAliasController.text == '') {
      isCheck = false;
      errAlias = 'ニックネームを入力してください。';
    } else {
      errAlias = null;
    }

    // if (txtPhoneController.text == '') {
    //   isCheck = false;
    //   errPhone = '電話番号を入力してください。';
    // } else {
    //   errPhone = null;
    // }

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

    if (!isCheck) return false;
    return true;
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
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: _getBodyContents(),
                  ),
                ),
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

  var txtBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));
  var txtPadding = EdgeInsets.all(8);

  List<Widget> _getBodyContents() {
    return [
      Container(
          padding: EdgeInsets.only(top: 10, right: 10),
          child:
              Text('', style: TextStyle(fontSize: 10, color: Colors.black45)),
          alignment: Alignment.topRight),
      _getShopTitle(),
      _getContentTitle('氏名'),
      _getNameInput(),
      SizedBox(height: 12),
      _getContentTitle('ニックネーム'),
      _getAliasInput(),
      // SizedBox(height: 12),
      // _getContentTitle('電話番号'),
      // _getPhoneInput(),
      SizedBox(height: 12),
      _getContentTitle('メールアドレス'),
      _getEmailInput(),
      SizedBox(height: 12),
      _getContentTitle('パスワード'),
      _getUserPassword(),
      // SizedBox(height: 12),
      _getSexInput(),
      // SizedBox(height: 12),
      // _getBirthInput(),
      SizedBox(height: 42),
      _getButton(),
      SizedBox(height: 12),
      if (widget.isProfile != null && widget.isProfile! == true)
        _getDeleteAccountButton(),
      SizedBox(height: 24),
      if (widget.isProfile == null || !widget.isProfile!)
        TextButton(
          child: Text(
            '既にアカウントのをお持ちの方',
            style: TextStyle(color: Colors.black.withOpacity(0.5)),
          ),
          onPressed: () => Navigator.pushNamed(context, '/Login'),
        )
    ];
  }

  Widget _getShopTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 36),
      child: Text(APPCOMPANYTITLE,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }

  Widget _getContentTitle(_title) {
    return Container(
      padding: EdgeInsets.only(left: 8, bottom: 4),
      alignment: Alignment.centerLeft,
      child: InputLabel(label: _title),
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

  Widget _getNameInput() {
    return Container(
      child: Row(children: [
        Flexible(
          child: TextInputNormal(
              isEnabled: widget.isProfile == null ? true : !widget.isProfile!,
              controller: txtFirstNameController,
              errorText: errFirstName),
        ),
        SizedBox(width: 8),
        Flexible(
            child: TextInputNormal(
                isEnabled: widget.isProfile == null ? true : !widget.isProfile!,
                controller: txtLastNameController,
                errorText: errLastName))
      ]),
    );
  }

  Widget _getAliasInput() {
    return Container(
      child: TextInputNormal(
          isEnabled: widget.isProfile == null ? true : !widget.isProfile!,
          controller: txtAliasController,
          errorText: errAlias),
    );
  }

  Widget _getEmailInput() {
    return Container(
      child: TextInputNormal(
          isEnabled: widget.isProfile == null ? true : !widget.isProfile!,
          controller: txtMailController,
          inputType: TextInputType.emailAddress,
          errorText: errMail),
    );
  }

  // Widget _getPhoneInput() {
  //   return Container(
  //       child: TextInputNormal(
  //     inputType: TextInputType.number,
  //     errorText: errPhone,
  //     controller: txtPhoneController,
  //   ));
  // }
  Widget _getSexInput() {
    return Row(
      children: <Widget>[
        InputLabel(label: '性別'),
        SizedBox(width: 30),
        Radio(
          value: '1',
          groupValue: _groupValue,
          onChanged: isEditable ? (val) => selectSexValue(val) : null,
        ),
        Padding(
          padding: EdgeInsets.only(right: 30),
          child: TextLabel(label: '男'),
        ),
        Radio(
          value: '2',
          groupValue: _groupValue,
          onChanged: isEditable ? (val) => selectSexValue(val) : null,
        ),
        Container(child: TextLabel(label: '女')),
      ],
    );
  }

  // Widget _getBirthInput() {
  //   return Row(
  //     children: <Widget>[
  //       InputLabel(label: '生年月日'),
  //       SizedBox(width: 4),
  //       Container(
  //         width: 70,
  //         child: DropDownNumberSelect(
  //           value: selectYear,
  //           min: 1970,
  //           max: 2030,
  //           tapFunc: !isEditable ? null : (v) => selectYearValue(v),
  //         ),
  //       ),
  //       TextLabel(label: '年 '),
  //       Container(
  //         width: 50,
  //         child: DropDownNumberSelect(
  //           value: selectMonth,
  //           max: 12,
  //           tapFunc: !isEditable ? null : (v) => selectMonthValue(v),
  //         ),
  //       ),
  //       TextLabel(label: '月 '),
  //       Container(
  //         width: 50,
  //         child: DropDownNumberSelect(
  //           value: selectDay,
  //           max: days,
  //           tapFunc: !isEditable ? null : (v) => selectDayValue(v),
  //         ),
  //       ),
  //       TextLabel(label: '日 '),
  //     ],
  //   );
  // }

  Widget _getButton() {
    return AccountButton(
      tapFunc: () {
        if (widget.isProfile != null && widget.isProfile! == true)
          updateUserInfo();
        else
          saveUserInfo();
      },
      label: widget.isProfile == true ? '保存する' : '会員画面へ',
    );
  }

  Widget _getDeleteAccountButton() {
    return DeleteAccountButton(
      tapFunc: () => deleteAccount(),
      label: 'このアカウントを削除',
    );
  }

  void selectSexValue(val) {
    _groupValue = val.toString();
    setState(() {});
  }

  // void selectYearValue(val) {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   selectYear = val.toString();
  //   days = Funcs().getMaxDays(selectYear, selectMonth);
  //   setState(() {});
  // }

  // void selectMonthValue(val) {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   selectMonth = val.toString();
  //   days = Funcs().getMaxDays(selectYear, selectMonth);
  //   setState(() {});
  // }

  // void selectDayValue(val) {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   selectDay = val.toString();
  //   setState(() {});
  // }
}
