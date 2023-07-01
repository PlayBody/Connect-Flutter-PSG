import 'dart:async';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/cart.dart';
import 'package:connect/src/common/bussiness/ticket.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/interface/component/button/default_buttons.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/component/container.dart';
import 'package:connect/src/interface/connect/component/userbutton.dart';
import 'package:connect/src/interface/connect/product/dialog_add_cart.dart';
import 'package:connect/src/model/ticketmodel.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';

class ProductDetail extends StatefulWidget {
  final String ticketId;
  const ProductDetail({required this.ticketId, Key? key}) : super(key: key);

  @override
  _ProductDetail createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {
  late Future<List> loadData;

  TicketModel? ticket;

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    ticket = await ClTicket().loadTicket(context, widget.ticketId);

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
      title: '商品詳細',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _getPhotoRow(),
                  _getTitleRow(),
                  Divider(height: 1, color: Colors.grey),
                  _getDescription(),
                  Divider(height: 1, color: Colors.grey),
                  _getIncreaseButton(),
                  SizedBox(height: 30),
                  _getCartButton(),
                  // ...tickets.map((e) => _getProductContent(e)),
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

  var _txtTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  var _txtContentStyle = TextStyle(fontSize: 16);
  double paddingH = 40;
  double paddingV = 8;

  Widget _getPhotoRow() => Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.4))),
      child: ticket!.image == null
          ? Text('設定なし')
          : Image.network(ticketImageUrl + ticket!.image!),
      height: 160);

  Widget _getTitleRow() => Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: Row(
          children: [
            Expanded(
              child: Text(ticket!.title, style: _txtTitleStyle),
            ),
            Container(
              child: Text(
                '￥' + Funcs().currencyFormat(ticket!.price),
                style: _txtContentStyle,
              ),
            )
          ],
        ),
      );

  Widget _getDescription() => Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: Text(ticket!.detail, style: _txtContentStyle),
      );

  Widget _getIncreaseButton() => Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      child: Row(
        children: [
          IncreaseButton(
              tapFunc: () => increaseQuantity(false, ticket!),
              icon: Icons.remove),
          IncreaseView(
              value: ticket!.cartCount == null ? 1 : ticket!.cartCount!),
          IncreaseButton(
              tapFunc: () => increaseQuantity(true, ticket!), icon: Icons.add),
        ],
      ));

  Widget _getCartButton() => Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: PrimaryButton(tapFunc: () => addCart(ticket!), label: 'カートに入れる'),
      );
}
