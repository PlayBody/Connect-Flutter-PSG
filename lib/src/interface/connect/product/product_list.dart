import 'dart:async';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/cart.dart';
import 'package:connect/src/common/bussiness/ticket.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/component/container.dart';
import 'package:connect/src/interface/connect/component/userbutton.dart';
import 'package:connect/src/interface/connect/product/dialog_add_cart.dart';
import 'package:connect/src/interface/connect/product/product_detail.dart';
import 'package:connect/src/model/ticketmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductList createState() => _ProductList();
}

class _ProductList extends State<ProductList> {
  late Future<List> loadData;

  CameraPosition? initCameraPosition;

  List<TicketModel> tickets = [];
  String openQuestion = '';

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    tickets = await ClTicket().loadTickets(context, APPCOMANYID);

    setState(() {});
    return [];
  }

  void increaseQuantity(isAdd, TicketModel item) {
    if (isAdd) {
      if (item.cartCount == null || item.cartCount! >= 10) return;
      item.cartCount = item.cartCount! + 1;
    } else {
      if (item.cartCount == null || item.cartCount! <= 1) return;
      item.cartCount = item.cartCount! - 1;
    }
    setState(() {});
  }

  Future<void> addCart(TicketModel item) async {
    Dialogs().loaderDialogNormal(context);
    bool isAddCart = await ClCart().addCart(context, item);
    Navigator.pop(context);
    if (!isAddCart) {
      Dialogs().infoDialog(context, 'カートが失敗しました。');
      return;
    }
    dynamic cartinfo = await ClCart().getCartSum(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogAddCart(
              showString: 'カートの小計（' +
                  cartinfo['count'] +
                  '点の商品） ￥' +
                  cartinfo['amount']);
        });
    loadInitData();
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '商品一覧',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...tickets.map((e) => _getProductContent(e)),
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

  var txtQuestionStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  var txtAnswerStyle = TextStyle(fontSize: 18);

  Widget _getProductContent(TicketModel item) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductDetail(ticketId: item.id);
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
          ),
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(item.title, style: TextStyle(fontSize: 16))),
              SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: item.image == null
                        ? Text('設定なし')
                        : Image.network(ticketImageUrl + item.image!),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.4), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    width: 120,
                    height: 80,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(item.detail,
                              style: TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.bold,
                              ))),
                      SizedBox(height: 6),
                      Text(
                          '小計  ￥' +
                              (int.parse(item.price) * item.cartCount!)
                                  .toString(),
                          style: TextStyle(fontSize: 22)),
                    ],
                  ))
                ],
              ),
              Row(
                children: [
                  IncreaseButton(
                      tapFunc: () => increaseQuantity(false, item),
                      icon: Icons.remove),
                  IncreaseView(
                      value: item.cartCount == null ? 1 : item.cartCount!),
                  IncreaseButton(
                      tapFunc: () => increaseQuantity(true, item),
                      icon: Icons.add),
                  Expanded(child: Container()),
                  Container(
                    child: ElevatedButton(
                      child: Text('カートに入れる'),
                      onPressed: () => addCart(item),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
