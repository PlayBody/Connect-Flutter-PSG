import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/couponmodel.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;
import 'connect_coupon_complete.dart';

class ConnectCouponUseConfirm extends StatefulWidget {
  final String couponId;
  const ConnectCouponUseConfirm({required this.couponId, Key? key})
      : super(key: key);

  @override
  _ConnectCouponUseConfirm createState() => _ConnectCouponUseConfirm();
}

class _ConnectCouponUseConfirm extends State<ConnectCouponUseConfirm> {
  late Future<List> loadData;

  List<CouponModel> coupons = [];
  String couponName = '';
  String useDate = '';
  String condition = '';
  String comment = '';
  String discountAmount = '';
  String discountRate = '';
  String upperAmount = '';

  @override
  void initState() {
    super.initState();
    loadData = loadCouponData();
  }

  Future<List> loadCouponData() async {
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadCouponInfoUrl,
        {'coupon_id': widget.couponId}).then((value) => results = value);

    if (results['isLoad']) {
      var coupon = results['coupon'];
      couponName = coupon['coupon_name'];
      useDate = coupon['use_date'];
      condition = coupon['condition'];
      comment = coupon['comment'];
    }
    return [];
  }

  Future<void> userCoupon() async {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ConnectCouponComplete();
    }));
  }

  var txtTitleStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  var txtContentStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = 'クーポン使用';
    return MainForm(
      title: 'クーポン使用',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text('このクーポンを使用しますか？', style: txtTitleStyle),
                  ),
                  _getCouponItem(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        ElevatedButton(
                            onPressed: () {
                              // userCoupon();
                            },
                            child: Text('はい')),
                        SizedBox(width: 40),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('いいえ')),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ],
              ),
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

  Widget _getCouponItem() {
    return Container(
        margin: new EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey)),
        child: Column(
          children: [
            Container(
                child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          couponName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Container(
                        child: Text(
                      '有効期限: ' + useDate.replaceAll('-', '/'),
                    )),
                    Container(
                        child: Text(
                      condition == '1' ? '他クーポン併用不可' : '他クーポンと併用化',
                    )),
                    Container(child: Text(comment)),
                  ],
                )),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  child: Column(children: [
                    if (discountAmount != '')
                      Text(
                        Funcs().currencyFormat(discountAmount) + '円 OFF',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    if (discountRate != '')
                      Text(discountRate + '％OFF',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    if (discountRate != '' && upperAmount != '')
                      Text('上限' + Funcs().currencyFormat(upperAmount) + '円',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                  ]),
                )
              ],
            )),
          ],
        ));
  }
}
