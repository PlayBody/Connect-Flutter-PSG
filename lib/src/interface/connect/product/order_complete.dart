import 'dart:async';

import 'package:connect/src/common/bussiness/cart.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/product/product_list.dart';
import 'package:connect/src/model/cartdetailmodel.dart';
import 'package:flutter/material.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete({Key? key}) : super(key: key);

  @override
  _OrderComplete createState() => _OrderComplete();
}

class _OrderComplete extends State<OrderComplete> {
  late Future<List> loadData;

  List<CartDetailModel> ticketCarts = [];
  dynamic cartInfo = {};

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    ticketCarts = await ClCart().getCarts(context);
    cartInfo = await ClCart().getCartSum(context);

    setState(() {});
    return [];
  }

  void pushProduct() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProductList();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MainForm(
        title: 'カート完了',
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
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          child: Text(
                            '注文が確定しました。',
                            style: TextStyle(fontSize: 24),
                          )),
                      SizedBox(height: 30),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          child: Text(
                            'ご利用いただき、\nありがとうございました。',
                            style: TextStyle(fontSize: 24),
                          )),
                      SizedBox(height: 60),
                      ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 200),
                          child: ElevatedButton(
                            child: Text('購入を続ける'),
                            onPressed: () => pushProduct(),
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
      ),
    );
  }

  var txtQuestionStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  var txtAnswerStyle = TextStyle(fontSize: 18);
}
