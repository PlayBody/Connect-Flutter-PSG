import 'package:flutter/material.dart';
import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/usermodel.dart';

import '../../common/globals.dart' as globals;
import 'connect_register.dart';

class ConnectSetting extends StatefulWidget {
  const ConnectSetting({Key? key}) : super(key: key);

  @override
  _ConnectSetting createState() => _ConnectSetting();
}

class _ConnectSetting extends State<ConnectSetting> {
  late Future<List> loadData;

  String isAdmin = '0';
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadData = loadSettingData();
  }

  Future<List> loadSettingData() async {
    user = await ClUser().getUserFromId(context, globals.userId);
    setState(() {});
    return [];
  }

  Future<void> saveSettingData(String pushKey, bool isEnable) async {
    await ClUser().updatePushStatus(context, globals.userId, pushKey, isEnable);
    loadSettingData();
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = '設定';
    return MainForm(
        title: '設定',
        render: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _getMainBodyContent();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget _getMainBodyContent() {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          _getSettingContentRow(
            'プロフィール',
            Icon(Icons.keyboard_arrow_right),
            () => Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ConnectRegister(isProfile: true);
            })),
          ),
          _getSettingContentRow('メッセージ通知',
              _getSwitchControl(user!.isPushMesseage, 'message'), null),
          _getSettingContentRow(
              '予約申込通知',
              _getSwitchControl(user!.isPushReserveRequest, 'reserve_request'),
              null),
          _getSettingContentRow(
              '予約承認通知',
              _getSwitchControl(user!.isPushReserveApply, 'reserve_apply'),
              null),
        ],
      ),
    ));
  }

  Widget _getSettingContentRow(label, trailingContent, onTap) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom:
              BorderSide(color: Color.fromARGB(255, 230, 230, 230), width: 1),
        )),
        child: ListTile(
            trailing: trailingContent,
            contentPadding:
                EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
            title: Text(label),
            onTap: onTap));
  }

  Widget _getSwitchControl(value, key) {
    return Switch(
      value: value,
      onChanged: (value) => saveSettingData(key, value),
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }
}
