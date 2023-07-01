import 'dart:convert';

import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/bussiness/stamps.dart';
import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/interface/component/button/default_buttons.dart';
import 'package:connect/src/interface/component/dropdown/dropdownmodel.dart';
import 'package:connect/src/interface/component/dropdown/dropdownnumber.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/history/connect_history.dart';
import 'package:connect/src/interface/connect/product/card_select.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:connect/src/model/ticketmodel.dart';
import 'package:connect/src/model/usercouponmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/dialogs.dart';
import '../../../http/webservice.dart';
import '../../../common/globals.dart' as globals;
import '../../../common/apiendpoint.dart';

class ConnectReserveConfirm extends StatefulWidget {
  final String reserveOrganId;
  final String? reserveStaffId;
  final DateTime reserveStartTime;
  final int reserveStatus;
  const ConnectReserveConfirm(
      {required this.reserveOrganId,
      this.reserveStaffId,
      required this.reserveStartTime,
      required this.reserveStatus,
      Key? key})
      : super(key: key);

  @override
  _ConnectReserveConfirm createState() => _ConnectReserveConfirm();
}

class _ConnectReserveConfirm extends State<ConnectReserveConfirm> {
  late Future<List> loadData;
  String reserveOrganName = '';
  int sumAmount = 0;
  int sumMenuTime = 0;
  DateTime reserveEndTime = DateTime.now();
  int couposAmount = 0;
  int sumTicketAmount = 0;
  String useCouponId = '';
  String payMethod = '2';
  bool payStatus = false;
  var codeController = TextEditingController();
  List<TicketModel> tickets = [];

  List<UserCouponModel> coupons = [];
  List<String> useCouponIds = [];
  int selAmount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.reserveStatus == 2 || globals.reserveUserCnt > 1)
      payMethod = '2';
    loadData = loadReserveData();
  }

  Future<List> loadReserveData() async {
    // if (globals.reserveUserCnt > 1) {
    //   sumMenuTime = globals.reserveTime;
    // } else {
    globals.connectReserveMenuList.forEach((element) {
      sumAmount = sumAmount + int.parse(element['menu'].menuPrice);
    });
    // }

    int sumMenuTime = 0;

    for (int i = 1; i <= globals.reserveMultiUsers.length; i++) {
      var iItem = globals.connectReserveMenuList
          .where((element) => element['no'] == i.toString());
      if (iItem.isEmpty) continue;

      int iTime = 0;
      iItem.forEach((element) {
        iTime = iTime + int.parse(element['menu'].menuTime);
      });

      // int interval = 0;
      // iItem.forEach((element) {
      //   if (int.parse(element['menu'].menuInterval) > interval)
      //     interval = int.parse(element['menu'].menuInterval);
      // });

      // iTime = iTime + interval;
      if (sumMenuTime < iTime) sumMenuTime = iTime;
    }

    if (globals.reserveMultiUsers.length > 1) {
      sumMenuTime = globals.reserveTime;
    }

    selAmount = 0;
    if (globals.selStaffType == 1 || globals.selStaffType == 2) {
      selAmount = 200;
    }
    if (globals.selStaffType == 3) {
      if (sumMenuTime > 120) {
        selAmount = 400;
      }
      if (sumMenuTime > 85 && sumMenuTime <= 115) {
        selAmount = 300;
      }
      if (sumMenuTime <= 85) {
        selAmount = 200;
      }
    }
    sumAmount = (sumAmount + selAmount * 1.1).toInt();
    print(globals.connectReserveMenuList);
    print(sumMenuTime);
    coupons = await ClCoupon().loadUserCoupons(context, {
      'user_id': globals.userId,
      'use_flag': '1',
      'use_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'use_organ': widget.reserveOrganId
    });

    reserveEndTime =
        widget.reserveStartTime.add(Duration(minutes: sumMenuTime));

    OrganModel? organ =
        await ClOrgan().loadOrganInfo(context, widget.reserveOrganId);

    if (organ != null) reserveOrganName = organ.organName;

    tickets = await ClUser().loadUserTickets(context);

    setState(() {});
    return [];
  }

  Future<void> loadCoupon(_userCouponId, flag) async {
    if (flag == 'add') {
      useCouponIds.add(_userCouponId);
    } else {
      useCouponIds.remove(_userCouponId);
    }
    couposAmount = 0;
    useCouponIds.forEach((element) {
      UserCouponModel _selCoupon = coupons.firstWhere((e) => e.id == element);
      if (_selCoupon.discountAmount != null) {
        couposAmount += int.parse(_selCoupon.discountAmount!);
      }
      if (_selCoupon.discountRate != null) {
        // ignore: division_optimization
        couposAmount += ((sumAmount.toDouble() *
                    int.parse(_selCoupon.discountRate!).toDouble()) /
                100)
            .toInt();
      }
    });

    setState(() {});
  }

  Future<void> saveReserve() async {
    if (sumTicketAmount + couposAmount > sumAmount) {
      Dialogs().infoDialog(context, '割引額は合計金額より小さくなければなりません。');
      return;
    }
    payStatus = false;
    bool conf = await Dialogs().confirmDialog(context, '予約しますか？');

    if (!conf) return;
    if (payMethod == '1') {
      await doPay();
    } else {
      saveReserveData();
    }
  }

  Future<void> saveReserveData() async {
    Dialogs().loaderDialogNormal(context);
    Map<String, dynamic> param = {
      'organ_id': widget.reserveOrganId,
      'user_id': globals.userId,
      'sel_staff_type': globals.selStaffType.toString(),
      'staff_id': widget.reserveStaffId == null ? '' : widget.reserveStaffId,
      'reserve_start_time':
          DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.reserveStartTime),
      'reserve_end_time':
          DateFormat('yyyy-MM-dd HH:mm:ss').format(reserveEndTime),
      'coupon_id': useCouponId,
      'coupon_use_amount': couposAmount.toString(),
      'ticket_amount': sumTicketAmount.toString(),
      'amount': sumAmount.toString(),
      'pay_method': payMethod,
      'user_count': globals.reserveMultiUsers.length.toString(),
      'sum_time': sumMenuTime.toString(),
      'reserve_status': widget.reserveStatus.toString()
    };
    if (globals.reserveMultiUsers.length > 0)
      param['user_2'] = globals.reserveMultiUsers[0]['name'];
    if (globals.reserveMultiUsers.length > 1)
      param['user_3'] = globals.reserveMultiUsers[1]['name'];
    if (globals.reserveMultiUsers.length > 2)
      param['user_4'] = globals.reserveMultiUsers[2]['name'];

    Map<String, dynamic> data = {};
    globals.connectReserveMenuList.forEach((e) {
      data[e['no'] + e['menu'].menuId] = {
        'no': e['no'],
        'menu': {
          'menu_id': e['menu'].menuId,
          'menu_price': e['menu'].menuPrice,
          'multi_number': e['menu'].multiNumber,
        }
      };
    });
    param['reserve_menu'] = jsonEncode(data);
    Map<String, dynamic> ticketdata = {};
    tickets.forEach((e) {
      if (e.cartCount != null && e.cartCount! > 0) {
        ticketdata[e.ticketId] = {
          'ticket_id': e.ticketId,
          'use_count': e.cartCount
        };
      }
    });
    param['use_ticket'] = jsonEncode(ticketdata);
    Map<dynamic, dynamic> results = {};

    await Webservice()
        .loadHttp(context, apiSaveReserveByUser, param)
        .then((v) => results = v);
    if (results['isSave']) {
      // if (widget.reserveStaffId != null)
      //   await Webservice().loadHttp(context, apiAddStaffPointDataUrl, {
      //     'date_year': widget.reserveStartTime.year.toString(),
      //     'date_month': reserveEndTime.month < 10
      //         ? '0' + reserveEndTime.month.toString()
      //         : reserveEndTime.month.toString(),
      //     'staff_id': widget.reserveStaffId,
      //     'point_type': '6',
      //     'organ_id': widget.reserveOrganId,
      //     'time': sumMenuTime.toString()
      //   });

      useCouponIds.forEach((element) {
        Webservice().loadHttp(context, apiBase + '/apicoupons/useUserCoupon',
            {'user_coupon_id': element});
      });

      globals.connectReserveMenuList = [];
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ConnectHistory();
      }));
    } else {
      Navigator.pop(context);
      Dialogs().infoDialog(context, '予約できません。入力したデータをもう一度確認してください。');
    }
  }

  Future<void> doPay() async {
    bool? isPay = await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CardSelect(payAmount: sumAmount.toString());
    }));
    if (isPay == null) return;
    if (isPay) {
      saveReserveData();
    } else {
      Dialogs().infoDialog(context, '購入に失敗しました。');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '予約確認',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.only(top: 40, left: 40, right: 30),
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(child: _getMainColumn())),
                  _getReserveConfirmButton()
                ]));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  var txtHeaderStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  var txtContentStyle = TextStyle(fontSize: 14);

  Widget _getMainColumn() {
    return Column(
      children: [
        _getReserveOrgan(),
        SizedBox(height: 20),
        _getPayMethod(),
        SizedBox(height: 20),
        _getReserveMenus(),
        SizedBox(height: 20),
        _getReserveTime(),
        SizedBox(height: 20),
        _getCouponUse(),
        SizedBox(height: 12),
        _getTicketUse(),
        SizedBox(height: 30),
        _getAmountSum()
      ],
    );
  }

  Widget _getReserveOrgan() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('予約店舗：', style: txtHeaderStyle),
          ),
          Expanded(
            child: Text(reserveOrganName, style: txtHeaderStyle),
          )
        ],
      ),
    );
  }

  Widget _getPayMethod() {
    return Container(
        child: DropDownModelSelect(
            value: payMethod,
            items: [
              if (widget.reserveStatus == 1 &&
                  globals.reserveMultiUsers.length == 1)
                DropdownMenuItem(child: Text('クレジット決済'), value: '1'),
              DropdownMenuItem(child: Text('店頭で決済'), value: '2')
            ],
            tapFunc: (v) {
              payMethod = v;
              setState(() {});
            }));
  }

  Widget _getReserveMenus() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          '予約メニュー',
          style: txtHeaderStyle,
        ),
      ),
      Container(
          child: Column(children: [
        ...globals.connectReserveMenuList.map((e) => Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(
                  child: Text(e['no'] + ' - ' + e['menu'].menuTitle,
                      style: txtContentStyle)),
              Container(
                  child: Text(Funcs().currencyFormat(e['menu'].menuPrice) + '円',
                      style: txtContentStyle)),
            ]))),
        Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(child: Text('指名料', style: txtContentStyle)),
              Container(
                  child: Text(
                      Funcs().currencyFormat(
                              (selAmount * 1.1).toInt().toString()) +
                          '円',
                      style: txtContentStyle)),
            ]))
      ])),
      Container(height: 1, color: Colors.grey),
      Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Expanded(child: Text('合計金額', style: txtContentStyle)),
            Container(
                child: Text(Funcs().currencyFormat(sumAmount.toString()) + '円',
                    style: txtContentStyle))
          ]))
    ]));
  }

  Widget _getReserveTime() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text('予約日時', style: txtHeaderStyle),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                  DateFormat('yyyy/MM/dd HH:mm')
                          .format(widget.reserveStartTime) +
                      ' ~ ' +
                      DateFormat('HH:mm').format(reserveEndTime),
                  style: txtContentStyle))
        ],
      ),
    );
  }

  Widget _getCouponUse() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Text('クーポン使用', style: txtHeaderStyle),
        ),
        if (coupons.length < 1) Container(child: Text('使用可能なクーポンはありません。')),
        ...coupons.map((e) => Container(
                child: Row(children: [
              Container(
                alignment: Alignment.center,
                width: 30,
                child: useCouponIds.contains(e.id)
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              Container(width: 120, child: Text(e.couponName)),
              if (!useCouponIds.contains(e.id))
                ColorButton(
                    tapFunc: () => loadCoupon(e.id, 'add'),
                    label: '使用',
                    color: Color(0xffcb4612),
                    fcolor: Colors.white),
              if (useCouponIds.contains(e.id))
                ColorButton(
                    tapFunc: () => loadCoupon(e.id, 'remove'),
                    label: 'キャンセル',
                    color: Colors.grey,
                    fcolor: Colors.white)
            ])))
        // Container(
        //     child: Row(children: [
        //   Flexible(
        //       child: TextInputNormal(
        //           controller: codeController, contentPadding: 10)),
        //   ElevatedButton(onPressed: () => loadCoupon(), child: Text('適用'))
        // ])),
      ],
    ));
  }

  Widget _getTicketUse() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Text('チケット使用', style: txtHeaderStyle),
      ),
      if (tickets.length < 1)
        Container(
            child:
                Text('使用するチケットかありません。', style: TextStyle(color: Colors.red))),
      ...tickets.map((e) => _getTicketRow(e))
    ]));
  }

  Widget _getTicketRow(e) => Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(width: 120, child: Text(e.title)),
        Flexible(
            child: DropDownNumberSelect(
                max: e.userCnt,
                min: 0,
                value: e.cartCount.toString(),
                tapFunc: (v) {
                  e.cartCount = int.parse(v);
                  print(sumTicketAmount);
                  setState(() {});
                }))
      ]));

  Widget _getAmountSum() {
    sumTicketAmount = 0;
    if (tickets.length > 0)
      tickets.forEach((element) {
        sumTicketAmount = sumTicketAmount +
            (int.parse(element.disamount)) *
                (element.cartCount == null ? 0 : element.cartCount!);
      });
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(child: Text('クーポン適用後金額', style: txtHeaderStyle)),
          Container(
              child: Text(
                  Funcs().currencyFormat(
                          (sumAmount - couposAmount - sumTicketAmount)
                              .toString()) +
                      '円',
                  style: txtHeaderStyle))
        ]));
  }

  Widget _getReserveConfirmButton() {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: ElevatedButton(
              child: Text('確定'),
              onPressed: () => saveReserve(),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  textStyle: TextStyle(fontSize: 16)),
            )));
  }
}
