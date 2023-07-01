import 'dart:convert';

import 'package:connect/src/common/bussiness/stamps.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/globals.dart' as globals;
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/order_model.dart';
import 'package:connect/src/model/reservemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../apiendpoint.dart';

class ClReserve {
  Future<List<TimeRegion>> loadReserveConditions(context, String organId,
      String? staffId, String fromDate, String toDate, String timeDiff) async {
    int sumTime = 0;

    for (int i = 1; i <= globals.reserveMultiUsers.length; i++) {
      var iItem = globals.connectReserveMenuList
          .where((element) => element['no'] == i.toString());
      if (iItem.isEmpty) continue;

      int iTime = 0;
      iItem.forEach((element) {
        iTime = iTime + int.parse(element['menu'].menuTime);
      });

      int interval = 0;
      iItem.forEach((element) {
        if (int.parse(element['menu'].menuInterval) > interval)
          interval = int.parse(element['menu'].menuInterval);
      });

      iTime = iTime + interval;
      if (sumTime < iTime) sumTime = iTime;
    }

    if (globals.reserveMultiUsers.length > 1) {
      sumTime = globals.reserveTime;
    }

    print({
      'organ_id': organId,
      'select_staff_type': globals.selStaffType.toString(),
      'from_time': fromDate,
      'to_time': toDate,
      'user_id': globals.userId,
      'staff_id': staffId == null ? '' : staffId,
      'duration': sumTime.toString(),
      'multi_number': globals.reserveMultiUsers.length.toString(),
    });
    // print(sumTime);
    // return [];
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadReserveCondition, {
      'organ_id': organId,
      'select_staff_type': globals.selStaffType.toString(),
      'from_time': fromDate,
      'to_time': toDate,
      'user_id': globals.userId,
      'staff_id': staffId == null ? '' : staffId,
      'duration': sumTime.toString(),
      'multi_number': globals.reserveMultiUsers.length.toString(),
    }).then((v) => {results = v});
    List<TimeRegion> regions = [];

    Map<String, dynamic> timeResults = {};
    for (var item in results['regions']) {
      String newTime = DateFormat('yyyy-MM-dd HH:00:00')
          .format(DateTime.parse(item['time']));

      if (int.parse(timeDiff) < 60)
        newTime = DateFormat('yyyy-MM-dd HH:mm:00')
            .format(DateTime.parse(item['time']));

      if (timeResults[newTime] == null) {
        timeResults[newTime] = {};
        timeResults[newTime]['type'] = item['type'].toString();
        timeResults[newTime]['time'] = newTime;
      } else {
        if (int.parse(timeResults[newTime]['type']) >
            int.parse(item['type'].toString())) {
          timeResults[newTime]['type'] = item['type'].toString();
        }
      }
    }

    Map<String, dynamic> finalResults = {};
    timeResults.forEach((key, item) {
      if (!DateTime.parse(key).isAfter(DateTime.parse(toDate))) {
        if (item['type'] == '1' || item['type'] == '2') {
          String _type = item['type'].toString();

          // for (int i = int.parse(timeDiff);
          //     i < sumTime + int.parse(timeDiff);
          //     i += int.parse(timeDiff)) {
          //   String _key = DateFormat('yyyy-MM-dd HH:mm:ss')
          //       .format(DateTime.parse(key).add(Duration(minutes: i)));

          //   if (timeResults[_key]['type'] == '0' ||
          //       timeResults[_key]['type'] == '3') {
          //     _type = timeResults[_key]['type'];
          //   }
          // }
          finalResults[key] = item;
          finalResults[key]['type'] = _type;
        } else {
          finalResults[key] = item;
        }
      }
    });

    finalResults.forEach((key, item) {
      var _cellBGColor = Color(0xfffdfdf6);
      var _cellText = '';
      var _textColor = Colors.grey;
      if (item['type'] == '1') {
        _cellBGColor = Colors.white;
        _cellText = staffId == null ? '○' : '◎';
        _textColor = Colors.red;
      }
      if (item['type'] == '2') {
        _cellBGColor = Colors.white;
        _textColor = Colors.green;
        _cellText = '□';
      }
      if (item['type'] == '3') {
        _cellBGColor = Color(0xfffdfdf6);
        _cellText = 'x';
      }
      regions.add(TimeRegion(
          startTime: DateTime.parse(item['time']),
          endTime: DateTime.parse(item['time']).add(Duration(minutes: 60)),
          enablePointerInteraction: true,
          color: _cellBGColor,
          text: _cellText,
          textStyle: TextStyle(
              color: _textColor, fontSize: 18, fontWeight: FontWeight.bold)));
    });

    return regions;
  }

  Future<List<ReserveModel>> loadUserReserveList(
      context, userId, organId, fromDate, toDate) async {
    String apiURL = apiBase + '/apireserves/loadUserReserveList';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiURL, {
      'user_id': globals.userId,
      'organ_id': organId,
      'from_date': fromDate,
      'to_date': toDate,
    }).then((value) => results = value);

    List<ReserveModel> reserves = [];
    if (results['isLoad']) {
      for (var item in results['reserves']) {
        reserves.add(ReserveModel.fromJson(item));
      }
    }

    return reserves;
  }

  Future<String?> loadLastReserveStaffId(context, String organId) async {
    String apiUrl = apiBase + '/apireserves/getLastReserve';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
      'organ_id': organId,
    }).then((v) => {results = v});
    return results['staff_id'] == '' ? null : results['staff_id'].toString();
  }

  Future<bool> updateReserveStatus(context, String reserveId) async {
    String apiUrl = apiBase + '/apireserves/updateReserveStatus';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'reserve_id': reserveId,
    }).then((v) => {results = v});

    return results['isStampAdd'];
  }

  Future<bool> enteringOrgan(
      context, String organId, String reserveId, String menuIds) async {
    String apiUrl = apiBase + '/apireserves/enteringOrgan';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'organ_id': organId,
      'order_id': reserveId,
      'menu_ids': menuIds,
      'user_id': globals.userId
    }).then((v) => {results = v});

    if (results['isUpdateGrade'])
      globals.userRank = await ClCoupon().loadRankData(context, globals.userId);

    return results['isStampAdd'];
  }

  Future<ReserveModel?> getReserveNow(context, String organId) async {
    String apiUrl = apiBase + '/apireserves/getReserveNow';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': globals.userId,
      'organ_id': organId,
    }).then((v) => {results = v});

    if (results['isExistReserve']) {
      return ReserveModel.fromJson(results['reserve']);
    }

    return null;
  }

  Future<List<OrderModel>> loadReserveList(context, {reserve_type = 1}) async {
    String apiURL = apiBase + '/apiorders/loadOrderList';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiURL, {
      'user_id': globals.userId,
      'is_reserve_list': reserve_type.toString()
    }).then((value) => results = value);
    List<OrderModel> historys = [];
    if (results['isLoad']) {
      for (var item in results['orders']) {
        historys.add(OrderModel.fromJson(item));
      }
    }

    historys.sort((a, b) =>
        DateTime.parse(b.fromTime).compareTo(DateTime.parse(a.fromTime)));

    return historys;
  }

  Future<List<OrderModel>> loadReserves(context, param) async {
    String apiURL = apiBase + '/apiorders/loadOrderList';
    Map<dynamic, dynamic> results = {};
    await Webservice()
        .loadHttp(context, apiURL, param)
        .then((value) => results = value);
    List<OrderModel> reserves = [];
    if (results['isLoad']) {
      for (var item in results['orders']) {
        reserves.add(OrderModel.fromJson(item));
      }
    }

    return reserves;
  }

  Future<OrderModel?> loadReserveInfo(context, String orderId) async {
    String apiURL = apiBase + '/apiorders/loadOrderInfo';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiURL, {'order_id': orderId}).then(
        (value) => results = value);
    OrderModel? reserve;

    if (results['isLoad']) {
      reserve = OrderModel.fromJson(results['order']);
    }

    return reserve;
  }

  Future<ReserveModel?> loadReserveMenus(context, reserveId) async {
    String apiURL = apiBase + '/apireserves/loadReserveInfo';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiURL,
        {'reserve_id': reserveId}).then((value) => results = value);
    ReserveModel? reserve;
    if (results['isLoad']) {
      reserve = ReserveModel.fromJson(results['reserve']);
    }

    return reserve;
  }

  Future<bool> updateReserveCancel(context, String reserveId, String staffId) async {
    String apiUrl = apiBase + '/apiorders/updateOrder';
    await Webservice()
        .loadHttp(context, apiUrl, {'reserve_id': reserveId, 'status': ORDER_STATUS_RESERVE_CANCEL, 'staff_id': staffId});
    return true;
  }

  Future<bool> updateReceiptUserName(
      context, String reserveId, String updateUserName) async {
    dynamic data = {'id': reserveId, 'user_input_name': updateUserName};
    String apiUrl = apiBase + '/apiorders/updateOrder';
    await Webservice()
        .loadHttp(context, apiUrl, {'update_data': jsonEncode(data)});
    return true;
  }
}
