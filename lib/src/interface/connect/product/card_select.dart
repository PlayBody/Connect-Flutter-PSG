import 'dart:async';

import 'package:connect/src/common/bussiness/square.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class CardSelect extends StatefulWidget {
  final String payAmount;
  const CardSelect({required this.payAmount, Key? key}) : super(key: key);

  @override
  _CardSelect createState() => _CardSelect();
}

class _CardSelect extends State<CardSelect> {
  late Future<List> loadData;

  List<CardModel> cards = [];
  CardModel? selCard;

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    cards = await ClSquare().getCardList(context);
    return [];
  }

  Future<void> onPay(CardModel? card) async{
    if(card == null){
      doCart();
    }else{
      Dialogs().loaderDialogNormal(context);
      bool isPay = 
      await ClSquare().addPayments(context, widget.payAmount, Uuid().v4(), card.sourceId, '0', card.customerId, card.postalCode);
      Navigator.pop(context);
      Navigator.pop(context, isPay);    
    }
  } 


  Future<void> doCart() async {
    await _onStartCardEntryFlow();
  }

  // Future<void> _onStartGiftCardEntryFlow() async {
  //   await InAppPayments.startGiftCardEntryFlow(
  //       onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
  //       onCardEntryCancel: _onCancelCardEntryFlow);
  // }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow,
        collectPostalCode: true);
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    print(result);
    InAppPayments.completeCardEntry(onCardEntryComplete: _onCardEntryComplete);
    _showUrlNotSetAndPrintCurlCommand(result.nonce, result.card.postalCode==null ? '' : result.card.postalCode!);
    return;
  }

  Future<void> _showUrlNotSetAndPrintCurlCommand(String nonce, String postalCode) async {
    Dialogs().loaderDialogNormal(context);
    bool isPay =
        await ClSquare().addPayments(context, widget.payAmount, Uuid().v4(), nonce, '1', '', postalCode);
    Navigator.pop(context);
    Navigator.pop(context, isPay);
  }

  void _onCardEntryComplete() {}

  void _onCancelCardEntryFlow() {
    // doCart();
  }

  void selectCard(CardModel? _card){
    selCard = _card;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'お支払い',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                  Expanded(child: 
                  SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...cards.map((e) => _getCardContents(e)),
                          _getCardContents(null)
                        ],
                      ),
                    )),
                  Container(
                    child: ElevatedButton(
                      child: Text('お支払い'),
                      onPressed: () => onPay(selCard),
                    ),
                  )
                ],));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getCardContents(CardModel? e){
    return GestureDetector(child: Container(
      height: 85,
      margin: EdgeInsets.only(top: 16, left: 20, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: e==selCard? Color(0xff62a9f9) : Colors.white,
        border: Border.all(color: Color(0xffafafaf)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
        Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(border: Border.all(color: Color(0xff666666)), borderRadius: BorderRadius.circular(30)),
          child: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: e==selCard?  Colors.green : Colors.transparent, borderRadius: BorderRadius.circular(30)),
          ),
        ),
        Expanded(child: Container(
          child: 
            e==null?
            Icon(Icons.add_circle, color: Color(0xffcfcfcf), size: 52)
            :
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getCardBrandContent(e.brand),
                    SizedBox(width: 12),
                    Container(
                      alignment: Alignment.center,
                      child: Text(e.cardNum, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                    ),
                  ],),
                Container(alignment: Alignment.centerRight, child: Text(e.expDate + '    ' + e.postalCode)),
              ],
            )
        )),
      ])
    ),
    onTap: () => selectCard(e),
    );
  }

  Widget _getCardBrandContent(String cardBrand){
    String cardImageUrl = '';
    if (cardBrand=='VISA') cardImageUrl = 'images/card_brand/visa.png';
    if (cardBrand=='MASTERCARD') cardImageUrl = 'images/card_brand/master.png';
    if (cardBrand=='JCB') cardImageUrl = 'images/card_brand/jcb.png';
    if (cardBrand=='AMERICAN_EXPRESS') cardImageUrl = 'images/card_brand/amex.png';
    if (cardBrand=='DISCOVER_DINERS') cardImageUrl = 'images/card_brand/diners.png';
    return Container(
      alignment: Alignment.centerLeft, 
      child: cardImageUrl==''? Text(cardBrand) : Image.asset(cardImageUrl), 
      height: 40);
  }

}
