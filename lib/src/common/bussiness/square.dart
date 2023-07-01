import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/card_model.dart';
import '../../common/globals.dart' as globals;

import '../apiendpoint.dart';

class ClSquare {
  Future<bool> addPayments(
      context, String amount, String uuid, String nonce, String isSave, String customerId, String postalCode) async {
    String apiURL = apiBase + '/apisquare/addPayment';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiURL, {
      'amount': amount,
      'currency': 'JPY',
      'idempotency_key': uuid,
      'source_id': nonce,
      'customer_id' : customerId,
      'is_save_card' : isSave,
      'user_id' : globals.userId,
      'auth_token' : globals.squareToken,
      'postal_code' : postalCode
    }).then((v) => {results = v});
    print(results);
    return results['isPay'];
  }

  Future<List<CardModel>> getCardList(context) async {
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadCardListUrl, {
      'user_id' : globals.userId,
    }).then((v) => {results = v});

    List<CardModel> cards = [];
    for(var item in results['cards']){
      cards.add(CardModel.fromJson(item));
    }
    return cards;
  }
}
