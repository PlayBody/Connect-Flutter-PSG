import 'package:connect/src/common/const.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/cartdetailmodel.dart';
import 'package:connect/src/model/ticketmodel.dart';

import '../apiendpoint.dart';
import '../../common/globals.dart' as globals;

class ClCart {
  Future<bool> addCart(context, TicketModel item) async {
    String apiUrl = apiBase + '/apicarts/addCart';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': APPCOMANYID,
      'user_id': globals.userId,
      'ticket_id': item.id,
      'count': item.cartCount == null ? '1' : item.cartCount.toString(),
      'amount': (int.parse(item.price) * item.cartCount!).toString(),
    }).then((v) => {results = v});
    return results['isSave'];
  }

  Future<bool> updateCart(context) async {
    String apiUrl = apiBase + '/apicarts/updateCart';

    print(globals.userId);
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
    }).then((v) => {results = v});

    return results['isUpdate'];
  }

  Future<dynamic> getCartSum(context) async {
    String apiUrl = apiBase + '/apicarts/getSumCart';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
    }).then((v) => {results = v});

    dynamic cartinfo = {};

    if (results['isLoad']) {
      cartinfo['amount'] = results['all_amount'].toString();
      cartinfo['count'] = results['count'].toString();
    } else {
      cartinfo['amount'] = '0';
      cartinfo['count'] = '0';
    }
    return cartinfo;
  }

  Future<List<CartDetailModel>> getCarts(context) async {
    String apiUrl = apiBase + '/apicarts/getCarts';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
    }).then((v) => {results = v});

    List<CartDetailModel> cartDetails = [];

    if (results['isLoad']) {
      for (var item in results['details']) {
        cartDetails.add(CartDetailModel.fromJson(item));
      }
    }
    return cartDetails;
  }

  Future<bool> updateCartDetail(context, CartDetailModel item) async {
    String apiUrl = apiBase + '/apicarts/updateCartDetail';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'id': item.id,
      'count': item.cartCount.toString(),
    }).then((v) => {results = v});

    return results['isSave'];
  }

  Future<bool> deleteCartDetail(context, CartDetailModel item) async {
    String apiUrl = apiBase + '/apicarts/deleteCartDetail';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'id': item.id,
    }).then((v) => {results = v});

    return results['isDelete'];
  }
}
