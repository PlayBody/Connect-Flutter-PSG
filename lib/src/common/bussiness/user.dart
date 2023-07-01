import 'dart:convert';

import 'package:connect/src/common/const.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/ticketmodel.dart';
import 'package:connect/src/model/usermodel.dart';

import '../apiendpoint.dart';
import '../../common/globals.dart' as globals;

class ClUser {
  Future<UserModel?> getUserModel(context, dynamic condition) async {
    Map<dynamic, dynamic> results = {};

    String apiUrl = apiBase + '/apiusers/getUserData';
    await Webservice().loadHttp(context, apiUrl,
        {'condition': jsonEncode(condition)}).then((v) => {results = v});

    if (results['isLoad']) {
      return UserModel.fromJson(results['user']);
    }
    return null;
  }

  Future<UserModel> getUserFromId(context, userId) async {
    String apiUrl = apiBase + '/apiusers/loadUserInfo';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': userId,
    }).then((v) => {results = v});

    return UserModel.fromJson(results['user']);
  }

  Future<bool> updateUserTicket(context, updateTicket) async {
    String apiUrl = apiBase + '/apiusers/updateUserTicket';

    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
      'ticket_count': updateTicket,
    });

    return true;
  }

  Future<bool> userLoginCheck(context, email, password) async {
    String apiUrl = apiBase + '/apiusers/loginCheck';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
      'email': email,
      'password': password
    }).then((v) => {results = v});

    return results['isLogin'];
  }

  Future<List<TicketModel>> loadUserTickets(context) async {
    String apiUrl = apiBase + '/apiusers/getOwnerTickets';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
    }).then((v) => {results = v});

    List<TicketModel> tickets = [];
    if (results['isLoad']) {
      for (var item in results['tickets']) {
        TicketModel tmp = TicketModel.fromJson(item);
        tmp.cartCount = 0;
        tickets.add(tmp);
      }
    }

    return tickets;
  }

  Future<void> usingTicketWithCheckin(context, id, count) async {
    String apiUrl = apiBase + '/apiusers/usingTicketWithCheckIn';

    await Webservice()
        .loadHttp(context, apiUrl, {'id': id, 'use_count': count});
  }

  Future<bool> updatePushStatus(
      context, String userId, String pushKey, bool isEnable) async {
    String apiUrl = apiBase + '/apiusers/updateUserPush';

    await Webservice().loadHttp(context, apiUrl, {
      'user_id': userId,
      'push_key': pushKey,
      'push_value': isEnable ? '1' : '0'
    });

    return true;
  }

  Future<bool> updateDeviceToken(context, String userId, String token) async {
    String apiUrl = apiBase + '/apiusers/updateDeviceToken';

    await Webservice()
        .loadHttp(context, apiUrl, {'user_id': userId, 'device_token': token});

    return true;
  }

  Future<bool> sendResetEmail(context, String email) async {
    String apiUrl = apiBase + '/apiusers/sendResetEmail';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': APPCOMANYID,
      'email': email
    }).then((value) => results = value);

    return results['isLoad'];
  }

  Future<bool> regVerifyCode(context, String email) async {
    String apiUrl = apiBase + '/apiusers/registerVerifyCode';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': APPCOMANYID,
      'email': email
    }).then((value) => results = value);

    return results['isLoad'];
  }

  Future<bool> userRegister(context, param) async {
    String apiUrl = apiBase + '/apiusers/userVerifyAndRegister';

    Map<dynamic, dynamic> results = {};
    await Webservice()
        .loadHttp(context, apiUrl, param)
        .then((value) => results = value);
    if (results['isVerify']) {
      globals.userId = results['user_id'].toString();
      globals.userName = results['user_name'];
    }

    return results['isVerify'];
  }

  Future<bool> updateUserProfile(context, param) async {
    String apiUrl = apiBase + '/apiusers/updateUserProfile';

    await Webservice().loadHttp(context, apiUrl, param);

    return true;
  }

  Future<bool> deleteUser(context, userId) async {
    await Webservice()
        .loadHttp(context, apiDeleteUserInfoUrl, {'user_id': userId});

    return true;
  }
}
