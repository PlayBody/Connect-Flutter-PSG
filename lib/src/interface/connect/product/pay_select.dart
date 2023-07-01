import 'package:flutter/material.dart';

enum PaymentType {
  giftcardPayment,
  cardPayment,
  googlePay,
  applePay,
  buyerVerification,
  secureRemoteCommerce
}

final int cookieAmount = 100;

String getCookieAmount() => (cookieAmount / 100).toStringAsFixed(2);

class PaySelect extends StatelessWidget {
  final bool googlePayEnabled;
  final bool applePayEnabled;
  PaySelect({required this.googlePayEnabled, required this.applePayEnabled});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: _title(context),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: 300,
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // _ShippingInformation(),
                      // _LineDivider(),
                      _PaymentTotal(),
                      _LineDivider(),
                      _RefundInformation(),
                      _payButtons(context),
                    ]),
              ),
            ]),
      );

  Widget _title(context) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        // Padding(padding: EdgeInsets.only(right: 56)),
        Container(
          child: Expanded(
            child: Text(
              "Place your order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                color: Colors.blue)),
      ]);

  Widget _payButtons(context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _payItem(context, "Pay with gift card", PaymentType.giftcardPayment),
          _payItem(context, "Pay with card", PaymentType.cardPayment),
          _payItem(
              context, "Buyer Verification", PaymentType.buyerVerification),
          _payItem(context, "masterCard", PaymentType.secureRemoteCommerce),
        ],
      );

  Widget _payItem(context, label, paymentType) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 1, color: Colors.grey.withOpacity(0.2)))),
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(width: 50, height: 30, color: Colors.grey),
              SizedBox(width: 12),
              Container(
                child: Text(label),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context, paymentType);
        },
      );
}

class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Divider(
        height: 1,
        color: Colors.grey,
      ));
}

class _PaymentTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Total",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Padding(padding: EdgeInsets.only(right: 47)),
          Text(
            "\$${getCookieAmount()}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class _RefundInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: MediaQuery.of(context).size.width - 60,
              child: Text(
                "You can refund this transaction through your Square dashboard, go to squareup.com/dashboard.",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ],
        ),
      );
}
