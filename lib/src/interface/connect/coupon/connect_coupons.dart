import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/stamps.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/component/text/header_text.dart';
import 'package:connect/src/model/couponmodel.dart';
import 'package:connect/src/model/rankmodel.dart';
import 'package:connect/src/model/stampmodel.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;
import 'package:carousel_slider/carousel_slider.dart';

class ConnectCoupons extends StatefulWidget {
  const ConnectCoupons({Key? key}) : super(key: key);

  @override
  _ConnectCoupons createState() => _ConnectCoupons();
}

class _ConnectCoupons extends State<ConnectCoupons> {
  late Future<List> loadData;

  List<CouponModel> coupons = [];
  List<StampModel> stamps = [];
  String openCouponId = '';
  int stampCount = 10;
  int _current = 0;
  List<RankModel> ranks = [];

  @override
  void initState() {
    super.initState();
    loadData = loadCouponData();
  }

  Future<void> updateCouponUseFlag(String userCouponId) async {
    bool conf = await Dialogs().confirmDialog(context, '使用しますか？');
    if (!conf) {
      return;
    }
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUpdateUserCouponUseFlagUrl, {'user_coupon_id': userCouponId})
        .then((value) => results = value);
    if (results['isLoad']) {
      final updateResult = results['updateResult'];
      if (updateResult) {
        await loadCouponData();
        setState(() {});
      }
      print(updateResult);

    }
  }

  Future<List> loadCouponData() async {
    // ranks = await ClCoupon().loadRanks(context, '5');
    stampCount =
        globals.userRank == null ? 5 : int.parse(globals.userRank!.maxStamp);

    stamps = await ClCoupon().loadUserStamps(context, globals.userId);

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadUserCouponsUrl,
        {'user_id': globals.userId}).then((value) => results = value);
    coupons = [];
    if (results['isLoad']) {
      for (var item in results['coupons']) {
        coupons.add(CouponModel.fromJson(item));
      }
    }

    setState(() {});
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'スタンプ・クーポン',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Container(
                    //   child: DropDownModelSelect(items: [
                    //     ...ranks.map((e) => DropdownMenuItem(
                    //           child: Text(e.rankName),
                    //           value: e.rankId,
                    //         ))
                    //   ], tapFunc: (v) {}),
                    // ),
                    _getCoupons(),
                    SizedBox(height: 8),
                    // _getCardUserButton(),
                    // SizedBox(height: 25),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Header3Text(label: '使用可能なクーポン一覧'),
                          _getCouponContent(),
                          SizedBox(height: 40),
                          Header3Text(label: 'スタンプ特典'),
                          _getBenefitContent()
                        ],
                      ),
                    ))
                  ],
                ),
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

  var txtTitleStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  var txtContentStyle = TextStyle(fontSize: 16);

  Widget _getCoupons() {
    int slideCnt = (stampCount <= 10) ? 1 : (stampCount - 1) ~/ 10 + 1;
    List<int> slideItems = [];
    for (int i = 1; i <= slideCnt; i++) slideItems.add(i);
    return Container(
        color: Color(0Xff749b88),
        child: Column(children: [
          CarouselSlider(
            options: CarouselOptions(
                viewportFraction: 1,
                height: 240,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: slideItems.map((ii) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.only(top: 8),
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(30),
                        crossAxisCount: 5,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.7,
                        children: [
                          for (int i = 10 * (ii - 1) + 1; i <= 10 * ii; i++)
                            if (i <= stampCount)
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      i <= stamps.length
                                          ? stamps[i - 1].createDate
                                          : '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: i <= stamps.length
                                        ? null

                                        // Icon(Icons.card_giftcard_outlined,
                                        //     color: Colors.white, size: 32)
                                        : Text(i.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24)),
                                    decoration: BoxDecoration(
                                      image: (i <= stamps.length)
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                apiRenderPrintLogo +
                                                    stamps[i - 1].organId,
                                              ),
                                              fit: BoxFit.fill)
                                          : null,
                                      color: ((i <= stamps.length &&
                                                  stamps[i - 1]
                                                          .useflag
                                                          .toString() ==
                                                      '1') ||
                                              i > stamps.length)
                                          ? Colors.transparent
                                          : Color(0xff464646),
                                      border:
                                          Border.all(color: Color(0xFFf3f3f3)),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                  )
                                ],
                              )
                        ]),
                  );
                },
              );
            }).toList(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ...slideItems.map((e) => Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_current + 1) == e
                          ? Color.fromRGBO(0, 0, 0, 0.6)
                          : Color.fromRGBO(0, 0, 0, 0.2)),
                ))
          ]),
        ]));
  }

  // Widget _getCardUserButton() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 30, right: 30),
  //     child: ElevatedButton(
  //       child: Text('スタンプを使う'),
  //       onPressed: () {
  //         Navigator.push(context, MaterialPageRoute(builder: (_) {
  //           return ConnectCouponConfirm();
  //         }));
  //       },
  //     ),
  //   );
  // }

  Widget _getCouponContent() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...coupons.map((e) => _getCouponItem(e)),
            ],
          ),
        ));
  }

  Widget _getBenefitContent() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Text(
        '',
        style: txtContentStyle,
      ),
    );
  }

  Widget _getCouponItem(coupon) {
    return Container(
        margin: new EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: coupon.isUserUseFlag ? Colors.grey : Colors.blueGrey)),
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
                          coupon.couponName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Container(
                        child: Text(
                      '有効期限: ' + coupon.useDate.replaceAll('-', '/'),
                    )),
                    Container(
                        child: Text(
                      coupon.condition == '1' ? '他クーポン併用不可' : '他クーポンと併用化',
                    )),
                  ],
                )),
                Container(
                  width: 130,
                  alignment: Alignment.center,
                  child: Column(children: [
                    if (coupon.discountAmount != null)
                      Text(
                        Funcs().currencyFormat(coupon.discountAmount!) +
                            '円 OFF',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    if (coupon.discountRate != null)
                      Text(coupon.discountRate! + '％OFF',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    if (coupon.discountRate != null &&
                        coupon.upperAmount != null)
                      Text(
                          '上限' +
                              Funcs().currencyFormat(coupon.upperAmount!) +
                              '円',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                  ]),
                )
              ],
            )),
            if (openCouponId == coupon.couponId)
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(child: Text(coupon.comment)),
                    Expanded(child: Container()),
                    // Container(
                    //   child: ElevatedButton(
                    //     child: Text('クーポンを使う'),
                    //     onPressed: () {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (_) {
                    //         return ConnectCouponUseConfirm(
                    //             couponId: coupon.couponId);
                    //       }));
                    //     },
                    //   ),
                    // )
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: TextButton(
                  child: Row(
                    children: [
                      Text('詳細を見る'),
                      Icon(openCouponId == coupon.couponId
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down)
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      if (openCouponId == coupon.couponId) {
                        openCouponId = '';
                      } else {
                        openCouponId = coupon.couponId;
                      }
                    });
                  },
                )),
                coupon.isUserUseFlag ? Text('使用済み') :
                Container(
                    child: TextButton(
                      child: Text('使用する', style: TextStyle(color: Colors.blue),),
                      onPressed: () {
                        updateCouponUseFlag(coupon.userCouponId);
                      },
                    )),
              ],
            ),
          ],
        ));
  }
}
