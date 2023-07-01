import 'package:connect/src/common/bussiness/common.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/history/connect_history_view.dart';
import 'package:connect/src/interface/connect/history/connect_menu_review.dart';
import 'package:connect/src/interface/connect/reserve/reserve_multiuser.dart';
import 'package:connect/src/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/globals.dart' as globals;

class ConnectHistory extends StatefulWidget {
  const ConnectHistory({Key? key}) : super(key: key);

  @override
  _ConnectHistory createState() => _ConnectHistory();
}

class _ConnectHistory extends State<ConnectHistory> {
  late Future<List> loadData;

  int listType = 1;
  List<OrderModel> reserves = [];

  @override
  void initState() {
    super.initState();
    loadData = loadHistoryData();
  }

  Future<List> loadHistoryData() async {
    reserves =
        await ClReserve().loadReserveList(context, reserve_type: listType);
    await ClCommon().clearBadge(context, {
      'receiver_type': '2',
      'receiver_id': globals.userId,
      'notification_type': '23'
    });
    setState(() {});
    return [];
  }

  Future<void> pushReserv(OrderModel item) async {
    globals.connectReserveMenuList = [];
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ReserveMultiUser(organId: item.organId);
    }));
  }

  Future<void> pushReview(OrderModel item) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ConnectMenuReview(orderId: item.orderId);
    }));
  }

  Future<void> cancelReserve(String reserveId, String staffId) async {
    bool conf = await Dialogs().confirmDialog(context, qCommonCancel);
    if (!conf) return;
    Dialogs().loaderDialogNormal(context);
    await ClReserve().updateReserveCancel(context, reserveId, staffId);
    loadHistoryData();
    Navigator.pop(context);
  }

  Future<void> onTapListType(type) async {
    listType = type;

    Dialogs().loaderDialogNormal(context);
    await loadHistoryData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = '履歴';
    return MainForm(
      title: '履歴',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        _getTopTabButton('予 約', 1),
                        SizedBox(width: 8),
                        _getTopTabButton('履 歴', 2)
                      ],
                    )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [...reserves.map((e) => _getHistoryItem(e))],
                    ),
                  ),
                ))
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getTopTabButton(label, activeValue) {
    return Expanded(
        flex: 1,
        child: ElevatedButton(
            onPressed: () => onTapListType(activeValue),
            style: ElevatedButton.styleFrom(
              primary: listType == activeValue ? Colors.red : Color(0xffefefef),
              onPrimary: listType == activeValue ? Colors.white : Colors.red,
            ),
            child: Text(label)));
  }

  var txtContentStyle = TextStyle(fontSize: 14);
  var txtTitleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  Widget _getHistoryItem(OrderModel item) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (item.status == ORDER_STATUS_RESERVE_REQUEST)
                Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Text('リクエスト中、予約はまだ確定していません',
                        style: TextStyle(fontSize: 14, color: Colors.blue))),
              _getItemHeader(item),
              SizedBox(height: 12),
              _getItemContent(item),
              _getItemBottom(item),
            ],
          ),
        ),
        onTap: item.status == ORDER_STATUS_TABLE_COMPLETE
            ? () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ConnectHistoryView(orderId: item.orderId);
                }));
              }
            : null);
  }

  Widget _getItemHeader(OrderModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(item.organName, style: txtTitleStyle)),
        SizedBox(width: 8),
        if (item.status == ORDER_STATUS_RESERVE_REJECT) Text('【予約はできませんでした】'),
        if (item.status == ORDER_STATUS_RESERVE_APPLY) Text('【予約確定しました。】'),
        if (item.status == ORDER_STATUS_TABLE_COMPLETE)
          Text(
            '【ありがとうございました】',
            style: TextStyle(color: Colors.grey),
          ),
        Expanded(child: Container()),
        // Container(child: Text('￥' + Funcs().currencyFormat(item.sumAmount))),
      ],
    );
  }

  Widget _getItemContent(item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 8),
        Expanded(child: Column(children: _getItemMenus(item))),
        SizedBox(width: 8),
        _itemContentRight(item),
      ],
    );
  }

  Widget _itemContentRight(item) {
    return Container(
      width: 110,
      child: Column(
        children: [
          SizedBox(height: 12),
          Container(
            child: Text(
              item.payMethod == '1' ? '決済すみ' : '店決済あり',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: item.payMethod == '1' ? Colors.red : Colors.blue,
              ),
            ),
            alignment: Alignment.center,
          ),
          if (item.status == ORDER_STATUS_RESERVE_CANCEL)
            Container(
              padding: EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                'キャンセル済み',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              alignment: Alignment.center,
            ),
          if (item.status == ORDER_STATUS_RESERVE_APPLY ||
              item.status == ORDER_STATUS_RESERVE_REQUEST)
            Container(
              padding: EdgeInsets.only(top: 12),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => cancelReserve(item.orderId, item.staffId),
                child: Text('キャンセル'),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _getItemMenus(item) {
    return [
      ...item.menus.map(
        (e) => Container(
          padding: EdgeInsets.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(e.menuTitle, style: txtContentStyle)),
              Container(
                alignment: Alignment.topRight,
                width: 70,
                child: Text('￥' + Funcs().currencyFormat(e.menuPrice)),
              )
            ],
          ),
        ),
      ),
      if (item.staffName != '')
        Container(
          padding: EdgeInsets.only(top: 12),
          alignment: Alignment.topLeft,
          child: Text('【' + item.staffName + '】'),
        ),
      if (item.staffType == '1' || item.staffType == '2')
        Container(
          padding: EdgeInsets.only(top: 12),
          alignment: Alignment.topLeft,
          child: Text('【' + (item.staffType == '1' ? '男性希望' : '女性希望') + '】'),
        )
    ];
  }

  Widget _getItemBottom(item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            DateFormat('yyyy-MM-dd' +
                    '(' +
                    weekAry[DateTime.parse(item.fromTime).weekday - 1] +
                    ') HH:mm')
                .format(DateTime.parse(item.fromTime)),
            style: txtContentStyle,
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
              textStyle: TextStyle(fontSize: 12),
            ),
            onPressed: item.status == ORDER_STATUS_TABLE_COMPLETE
                ? () => pushReserv(item)
                : null,
            child: Text('再注文')),
        SizedBox(width: 4),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              textStyle: TextStyle(fontSize: 12),
            ),
            onPressed: item.status == ORDER_STATUS_TABLE_COMPLETE
                ? () => pushReview(item)
                : null,
            child: Text('評価する'))
      ],
    );
  }
}
