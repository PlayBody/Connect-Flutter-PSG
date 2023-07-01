import 'dart:async';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/cart.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/component/container.dart';
import 'package:connect/src/interface/connect/component/userbutton.dart';
import 'package:connect/src/interface/connect/product/card_select.dart';
import 'package:connect/src/interface/connect/product/order_complete.dart';
import 'package:connect/src/interface/connect/product/product_list.dart';
import 'package:connect/src/model/cartdetailmodel.dart';
import 'package:flutter/material.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({Key? key}) : super(key: key);

  @override
  _ProductCart createState() => _ProductCart();
}

class _ProductCart extends State<ProductCart> {
  late Future<List> loadData;

  List<CartDetailModel> ticketCarts = [];
  dynamic cartInfo = {};
  String totalAmount = '0';

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    ticketCarts = await ClCart().getCarts(context);
    cartInfo = await ClCart().getCartSum(context);
    totalAmount = cartInfo['amount'].toString();

    setState(() {});
    return [];
  }

  Future<void> increaseQuantity(isAdd, CartDetailModel item) async {
    if (isAdd) {
      if (item.cartCount == null || item.cartCount! >= 10) return;
      item.cartCount = item.cartCount! + 1;
    } else {
      if (item.cartCount == null || item.cartCount! <= 1) return;
      item.cartCount = item.cartCount! - 1;
    }
    Dialogs().loaderDialogNormal(context);
    await ClCart().updateCartDetail(context, item);
    loadInitData();
    Navigator.pop(context);
  }

  Future<void> deleteDetail(CartDetailModel item) async {
    Dialogs().loaderDialogNormal(context);
    await ClCart().deleteCartDetail(context, item);
    loadInitData();
    Navigator.pop(context);
  }

  void pushProduct() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProductList();
    }));
  }

  Future<void> doCart() async {
    bool? isPay = await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CardSelect(payAmount: totalAmount);
    }));
    if (isPay == null) return;
    if (isPay) {
      ClCart().updateCart(context);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return OrderComplete();
      }));
    } else {
      Dialogs().infoDialog(context, '購入に失敗しました。');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'カート',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          ticketCarts.length < 1
                              ? 'カートに商品はありません。'
                              : ('小計 ￥' + cartInfo['amount']),
                          style: TextStyle(fontSize: 24),
                        )),
                    if (ticketCarts.length < 1)
                      ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 200),
                          child: ElevatedButton(
                            child: Text('商品購入'),
                            onPressed: () => pushProduct(),
                          )),
                    if (ticketCarts.length > 0)
                      ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 200),
                          child: ElevatedButton(
                            child: Text('購入に進む'),
                            onPressed: () => doCart(),
                          )),
                    if (ticketCarts.length > 0)
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        height: 2,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...ticketCarts.map((e) => _getCartItem(e)),
                        ],
                      ),
                    )),
                  ],
                ));
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

  Widget _getCartItem(CartDetailModel item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            item.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
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
                  Text(item.detail,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                      '小計  ￥' +
                          (int.parse(item.price) * item.cartCount!).toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ))
            ],
          ),
          Row(
            children: [
              IncreaseButton(
                  tapFunc: () => increaseQuantity(false, item),
                  icon: Icons.remove),
              IncreaseView(value: item.cartCount!),
              IncreaseButton(
                  tapFunc: () => increaseQuantity(true, item), icon: Icons.add),
              Expanded(child: Container()),
              Container(
                child: ElevatedButton(
                  child: Text('削除'),
                  onPressed: () => deleteDetail(item),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
