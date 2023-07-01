import 'package:connect/src/common/bussiness/menus.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/interface/component/button/default_buttons.dart';
import 'package:connect/src/interface/component/dropdown/dropdownnumber.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/component/text/header_text.dart';
import 'package:connect/src/model/menumodel.dart';
import 'package:connect/src/model/order_model.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:connect/src/model/ticketmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/globals.dart' as globals;
import '../../../common/const.dart';

class ConnectCheckIn extends StatefulWidget {
  final String organId;
  // final String reserveId;
  const ConnectCheckIn({required this.organId, Key? key}) : super(key: key);

  @override
  _ConnectCheckIn createState() => _ConnectCheckIn();
}

class _ConnectCheckIn extends State<ConnectCheckIn> {
  late Future<List> loadData;
  OrganModel? organ;
  List<OrderModel> reserves = [];
  List<TicketModel> tickets = [];
  String? selReserveId;
  List<MenuModel> menus = [];
  List<String> selectMenus = [];

  @override
  void initState() {
    super.initState();
    loadData = loadCheckData();
  }

  Future<List> loadCheckData() async {
    organ = await ClOrgan().loadOrganInfo(context, widget.organId);
    if (organ == null) Navigator.pop(context);
    reserves = await ClReserve().loadReserves(context, {
      'user_id': globals.userId,
      'organ_id': widget.organId,
      'from_time': DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now()),
      'to_time': DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      'is_reserve_apply': '1'
    });

    tickets = await ClUser().loadUserTickets(context);

    menus = await ClMenu().loadMenuList(context, {'organ_id': widget.organId});

    setState(() {});
    return [];
  }

  Future<void> checkIn() async {
    if (organ!.isNoReserve != constCheckinTypeNone && selReserveId == null) {
      Dialogs().infoDialog(context, '予約内容を選択してください。');
      return;
    }

    int sumTicket = 0;
    tickets.forEach((element) {
      sumTicket += element.cartCount!;
    });

    if (sumTicket != organ!.checkTicketConsumtion) {
      Dialogs().infoDialog(context, 'チケット数が足りません。');
      return;
    }

    // if (selectMenus.length < 1) {
    //   Dialogs().infoDialog(context, 'メニューを選択してください。');
    //   return;
    // }

    bool conf = await Dialogs().confirmDialog(context, '入店しますか？');
    if (!conf) return;

    Dialogs().loaderDialogNormal(context);
    for (var item in tickets) {
      await ClUser()
          .usingTicketWithCheckin(context, item.id, item.cartCount.toString());
    }
    if (selReserveId == '0') selReserveId = '';
    bool isAddStamp = await ClReserve().enteringOrgan(
        context,
        widget.organId,
        selReserveId == null ? '0' : selReserveId!,
        selectMenus.isEmpty ? '' : selectMenus.join(','));
    if (isAddStamp) {
      await Dialogs().waitDialog(context, '1つのスタンプが追加されました。');
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }

  void onTapReserve(String _reserveId) {
    selReserveId = _reserveId;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = 'チェックイン';
    return MainForm(
        title: 'チェックイン',
        render: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: _getMainColumn());
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget _getMainColumn() {
    return SingleChildScrollView(
        child: Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        Header3Text(label: organ!.organName),
        SizedBox(height: 24),
        ...reserves.map((e) => GestureDetector(
              onTap: () => onTapReserve(e.orderId),
              child: Container(
                  child: Row(children: [
                Radio(
                  onChanged: (v) {},
                  value: e.orderId,
                  groupValue: selReserveId,
                ),
                Container(
                    child: Text(Funcs().dateFormatHHMMJP(e.fromTime) +
                        ' ~ ' +
                        Funcs().dateFormatHHMMJP(e.toTime)))
              ])),
            )),
        if (organ!.isNoReserve == constCheckinTypeBoth)
          GestureDetector(
            onTap: () => onTapReserve('0'),
            child: Container(
                child: Row(children: [
              Radio(
                onChanged: (v) {},
                value: '0',
                groupValue: selReserveId,
              ),
              Container(child: Text('予約なし'))
            ])),
          ),
        if (selReserveId == '0')
          ...menus.map((e) => GestureDetector(
              onTap: () {
                if (selectMenus.contains(e.menuId)) {
                  selectMenus.remove(e.menuId);
                } else {
                  selectMenus.add(e.menuId);
                }
                setState(() {});
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: selectMenus.contains(e.menuId)
                          ? Color(0xffafafaf)
                          : Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(7)),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(child: Container(child: Text(e.menuTitle))),
                      Container(
                        alignment: Alignment.centerRight,
                        width: 120,
                        child: Text(Funcs().currencyFormat(e.menuPrice) + '円'),
                      ),
                    ],
                  )))),
        if (organ!.isNoReserve == constCheckinTypeOnlyReserve &&
            reserves.length < 1)
          Text(
            '予約データがありません。入店できません。',
            style: TextStyle(color: Colors.red),
          ),
        SizedBox(height: 12),
        Header4Text(
            label: '必要なチケット数 : ' + organ!.checkTicketConsumtion.toString()),
        SizedBox(height: 48),
        Header4Text(label: 'チケット消費設定'),
        SizedBox(height: 8),
        ...tickets.map((e) => _getTicketRow(e)),
        // Expanded(child: Container()),
        SizedBox(height: 48),
        if (organ!.isNoReserve == constCheckinTypeNone || selReserveId != null)
          Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: PrimaryButton(label: '入     店', tapFunc: () => checkIn())),
        SizedBox(height: 24),
      ],
    ));
  }

  Widget _getTicketRow(e) => Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 120, child: Text(e.title)),
          Flexible(
              child: DropDownNumberSelect(
            max: e.userCnt,
            min: 0,
            value: e.cartCount.toString(),
            tapFunc: (v) => e.cartCount = int.parse(v),
          ))
        ],
      ));
}
