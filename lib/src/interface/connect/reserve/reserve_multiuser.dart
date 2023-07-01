import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/interface/component/button/default_buttons.dart';
import 'package:connect/src/interface/component/dropdown/dropdownnumber.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/component/text/input_texts.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:connect/src/interface/connect/reserve/connect_reserve_menu.dart';
import 'package:connect/src/interface/connect/reserve/reserve_date_first.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/globals.dart' as globals;

class ReserveMultiUser extends StatefulWidget {
  final String organId;
  const ReserveMultiUser({required this.organId, Key? key}) : super(key: key);

  @override
  _ReserveMultiUser createState() => _ReserveMultiUser();
}

class _ReserveMultiUser extends State<ReserveMultiUser> {
  late Future<List> loadData;
  int userCount = 1;
  var txtUser2Controller = TextEditingController();
  var txtUser3Controller = TextEditingController();
  var txtUser4Controller = TextEditingController();
  OrganModel? organ;
  String sumTime = '10';

  String errMsg = '';

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    organ = await ClOrgan().loadOrganInfo(context, widget.organId);
    return [];
  }

  void pushReserveMenu() {
    // if ((userCount > 1 && txtUser2Controller.text == '') ||
    //     (userCount > 2 && txtUser3Controller.text == '') ||
    //     (userCount > 3 && txtUser4Controller.text == '')) {
    //   errMsg = 'ユーザー名を入力してください。';
    //   setState(() {});
    //   return;
    // }
    // errMsg = '';
    // setState(() {});
    globals.selStaffType = 0;
    globals.menuSelectNumber = 1;
    globals.reserveMultiUsers = [];
    globals.connectReserveMenuList = [];
    globals.reserveTime = int.parse(sumTime);
    globals.reserveUserCnt = userCount;

    // if (userCount > 1) globals.reserveMultiUsers.add(txtUser2Controller.text);
    // if (userCount > 2) globals.reserveMultiUsers.add(txtUser3Controller.text);
    // if (userCount > 3) globals.reserveMultiUsers.add(txtUser4Controller.text);

    globals.reserveMultiUsers = [];
    globals.reserveMultiUsers.add({'no': '1', 'name': globals.userName});
    if (userCount > 1)
      globals.reserveMultiUsers.add({'no': '2', 'name': 'ユーザー２'});
    if (userCount > 2)
      globals.reserveMultiUsers.add({'no': '3', 'name': 'ユーザー３'});
    if (userCount > 3)
      globals.reserveMultiUsers.add({'no': '4', 'name': 'ユーザー４'});

    if (userCount > 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ReserveDateFirst(organId: widget.organId);
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ConnectReserveMenus(organId: widget.organId);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
        title: '予定人数',
        bgColor: Color(0xfff4f4ea),
        render: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _getBodyContent();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget _getBodyContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(child: _getMainColumn())),
          Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('複数人数のご予約の場合は指名予約できません。'),
                  Text('指名をご希望の場合は店舗に直接お電話ください。'),
                  if (organ != null && organ!.organPhone != null)
                    TextButton(
                        onPressed: () =>
                            launchUrl(Uri.parse("tel://" + organ!.organPhone!)),
                        child: Text(
                          '電話番号：${organ!.organPhone}',
                          style: TextStyle(color: Colors.black),
                        )),
                ],
              )),
          SizedBox(height: 40),
          PrimaryButton(label: '次へ', tapFunc: () => pushReserveMenu())
        ],
      ),
    );
  }

  Widget _getMainColumn() {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            TextLabel(label: '来店予定人数'),
            SizedBox(width: 16),
            Flexible(
                child: DropDownNumberSelect(
                    value: userCount.toString(),
                    max: 4,
                    tapFunc: (v) {
                      userCount = int.parse(v);
                      setState(() {});
                    }))
          ],
        ),
        SizedBox(height: 24),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(errMsg, style: TextStyle(color: Colors.red))),
        // if (userCount > 1)
        //   Container(
        //       margin: EdgeInsets.symmetric(vertical: 4),
        //       child: Row(children: [
        //         TextLabel(label: 'ご来店者様のご氏名(2人目)'),
        //         SizedBox(width: 16),
        //         Flexible(child: TextInputNormal(controller: txtUser2Controller))
        //       ])),
        // if (userCount > 2)
        //   Container(
        //       margin: EdgeInsets.symmetric(vertical: 4),
        //       child: Row(children: [
        //         TextLabel(label: 'ご来店者様のご氏名(3人目)'),
        //         SizedBox(width: 16),
        //         Flexible(child: TextInputNormal(controller: txtUser3Controller))
        //       ])),
        // if (userCount > 3)
        //   Container(
        //       margin: EdgeInsets.symmetric(vertical: 4),
        //       child: Row(children: [
        //         TextLabel(label: 'ご来店者様のご氏名(4人目)'),
        //         SizedBox(width: 16),
        //         Flexible(child: TextInputNormal(controller: txtUser4Controller))
        //       ])),
        if (userCount > 1)
          Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Row(children: [
                TextLabel(label: 'ご予約時間(分)'),
                SizedBox(width: 16),
                Flexible(
                    child: DropDownNumberSelect(
                        value: sumTime,
                        min: 10,
                        max: 200,
                        diff: 5,
                        tapFunc: (v) => sumTime = v))
              ])),
      ],
    );
  }
}
