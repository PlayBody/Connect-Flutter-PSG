import 'package:connect/src/common/bussiness/company.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/companymodel.dart';
import 'package:connect/src/model/order_model.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:connect/src/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConnectHistoryView extends StatefulWidget {
  final String orderId;
  const ConnectHistoryView({required this.orderId, Key? key}) : super(key: key);

  @override
  _ConnectHistoryView createState() => _ConnectHistoryView();
}

class _ConnectHistoryView extends State<ConnectHistoryView> {
  late Future<List> loadData;

  OrderModel? order;
  OrganModel? organ;
  UserModel? user;

  String userName = '';
  String orderId = '';
  String updateUserName = '';
  String sumAmount = '0';
  String couponAmount = '0';
  String reserveDate = '';
  String reserveTime = '';
  String organName = '';
  String addressNumber = '';
  String address = '';
  String phone = '';
  String receiptNumber = '';

  int subAmount = 0;
  int amount = 0;

  @override
  void initState() {
    super.initState();
    loadData = loadReserveData();
  }

  Future<List> loadReserveData() async {
    order = await ClReserve().loadReserveInfo(context, widget.orderId);

    CompanyModel company =
        await ClCompany().loadCompanyInfo(context, APPCOMANYID);
    receiptNumber = company.companyReceiptNumber;
    if (order != null) {
      organ = await ClOrgan().loadOrganInfo(context, order!.organId);
      user = await ClUser().getUserFromId(context, order!.userId);
    }

    if (user != null) {
      userName = user!.userFirstName + ' ' + user!.userLastName;
    }
    updateUserName = order!.userInputName;

    if (order != null) {
      orderId = order!.orderId;
      reserveDate =
          DateFormat('yyyy年M月d日').format(DateTime.parse(order!.createTime));

      int yobi = DateTime.parse(order!.createTime).weekday;
      reserveDate += "(" + weekAry[yobi - 1] + "曜日)";
      reserveTime =
          DateFormat('HH:mm:ss').format(DateTime.parse(order!.createTime));
      sumAmount = order!.amount.toString();
      couponAmount = order!.couponAmount;
    }

    if (organ != null) {
      organName = organ!.organName;
      address = organ!.organAddress == null ? '' : organ!.organAddress!;
      phone = organ!.organPhone == null ? '' : organ!.organPhone!;
    }

    subAmount = int.parse(sumAmount) - int.parse(couponAmount);
    amount = (subAmount).toInt();

    setState(() {});
    return [];
  }

  void titleChangeDialog(String userName) {
    final _controller = TextEditingController();

    _controller.text = userName;
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: userName.length,
    );

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '領収書の名前を変更しますか？\n変更は1回のみ可能です。',
          style: TextStyle(fontSize: 14),
        ),
        content: TextField(autofocus: true, controller: _controller),
        actions: [
          TextButton(
            child: const Text('変更'),
            onPressed: () => {updateReceiptName(_controller.text)},
          ),
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> updateReceiptName(String userName) async {
    if (orderId == '') return;
    Navigator.of(context).pop();
    if (userName == '') return;

    await ClReserve().updateReceiptUserName(context, orderId, userName);
    loadReserveData();
  }

  var textStyle1 = TextStyle(fontSize: 22);
  var contentTextStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '領収証',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                    child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey))),
                        alignment: Alignment.center,
                        child: Text(organName, style: textStyle1)),
                    SizedBox(height: 24),
                    Container(
                        alignment: Alignment.center,
                        child: Text('領    収    証',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold))),
                    SizedBox(height: 32),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1, color: Colors.grey))),
                                    child: Text(
                                        updateUserName == ''
                                            ? userName
                                            : updateUserName,
                                        style: textStyle1))),
                            if (updateUserName == '')
                              IconButton(
                                  onPressed: () => titleChangeDialog(userName),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  )),
                            Container(child: Text('様', style: textStyle1)),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.grey))),
                            child: Text(
                                '￥' +
                                    Funcs().currencyFormat(amount.toString()) +
                                    'ー',
                                style: textStyle1))),
                    _getNoramlText('上記                        として領収致しました。'),
                    SizedBox(height: 30),
                    _getNoramlText('★保管上のお願い\n財布等で保管頂く場合、印刷面を内側に折って保管願います。'),
                    SizedBox(height: 24),
                    _getNoramlText(organName),
                    _getNoramlText(address),
                    _getNoramlText(phone),
                    _getNoramlText('登録番号：' + receiptNumber),
                    SizedBox(height: 24),
                    Container(
                        child: Row(children: [
                      SizedBox(width: 12),
                      Text(reserveDate, style: contentTextStyle),
                      Expanded(child: Container()),
                      Text(reserveTime, style: contentTextStyle)
                    ])),
                    SizedBox(height: 24),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text('※は軽減税率対象商品', style: contentTextStyle)),
                    SizedBox(height: 12),
                    if (order != null)
                      ...order!.menus.map(
                          (e) => _getMenuContent(e.menuTitle, e.menuPrice)),
                    if (int.parse(couponAmount) > 0)
                      _getMenuContent('割引', couponAmount.toString()),
                    Container(height: 1, color: Colors.grey.withOpacity(0.4)),
                    _getMenuContent(
                        '内、消費税         (￥' +
                            Funcs().currencyFormat(subAmount.toString()) +
                            ')',
                        (subAmount ~/ 11).toString()),
                    Container(height: 1, color: Colors.grey.withOpacity(0.4)),
                    _getMenuContent(
                        '合計 ' + order!.menus.length.toString() + '点',
                        amount.toString()),
                    SizedBox(height: 20),
                    Container(
                        child: Row(children: [
                      Text('扱：', style: contentTextStyle),
                      Expanded(child: Container()),
                      Text('No.00001', style: contentTextStyle)
                    ])),
                    SizedBox(height: 60),
                    Container(
                        child: ElevatedButton(
                            child: Text('メールで送る'), onPressed: () {})),
                    SizedBox(height: 30),
                  ],
                )));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getNoramlText(txt) => Container(
      alignment: Alignment.topLeft, child: Text(txt, style: contentTextStyle));

  Widget _getMenuContent(title, price) => Container(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(children: [
        SizedBox(width: 12),
        Text(title, style: contentTextStyle),
        Expanded(child: Container()),
        Text('￥' + Funcs().currencyFormat(price), style: contentTextStyle)
      ]));
}
