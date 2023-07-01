import 'dart:convert';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/couponmodel.dart';
import 'package:connect/src/model/rankmodel.dart';
import 'package:connect/src/model/stampmodel.dart';
import 'package:connect/src/model/usercouponmodel.dart';
import '../../common/globals.dart' as globals;

class ClCoupon {
  Future<bool> isHaveCouponOrStamp(context) async {
    List<StampModel> stamps =
        await loadStamps(context, {'user_id': globals.userId, 'use_flag': '1'});
    if (stamps.length > 0) return true;

    List<CouponModel> coupons = await loadCoupons(
        context, {'user_id': globals.userId, 'use_flag': '1'});
    if (coupons.length > 0) return true;

    return false;
  }

  Future<List<StampModel>> loadStamps(context, param) async {
    String apiUrl = apiBase + '/apicoupons/loadStampList';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl,
        {'condition': jsonEncode(param)}).then((v) => {results = v});

    if (!results['isLoad']) return [];

    List<StampModel> stamps = [];
    for (var item in results['stamps']) {
      stamps.add(StampModel.fromJson(item));
    }
    return stamps;
  }

  Future<List<CouponModel>> loadCoupons(context, param) async {
    String apiUrl = apiBase + '/apicoupons/loadCoupons';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl,
        {'condition': jsonEncode(param)}).then((v) => {results = v});

    if (!results['isLoad']) return [];

    List<CouponModel> coupons = [];
    for (var item in results['coupons']) {
      coupons.add(CouponModel.fromJson(item));
    }
    return coupons;
  }

  Future<List<UserCouponModel>> loadUserCoupons(context, param) async {
    String apiUrl = apiBase + '/apicoupons/loadCoupons';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl,
        {'condition': jsonEncode(param)}).then((v) => {results = v});

    if (!results['isLoad']) return [];

    List<UserCouponModel> coupons = [];
    for (var item in results['coupons']) {
      coupons.add(UserCouponModel.fromJson(item));
    }
    return coupons;
  }

  Future<List<RankModel>> loadRanks(context, userGrade) async {
    String apiUrl = apiBase + '/apicoupons/loadRanks';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': APPCOMANYID,
      'max_rank': userGrade
    }).then((v) => {results = v});

    List<RankModel> ranks = [];
    for (var item in results['ranks']) {
      ranks.add(RankModel.fromJson(item));
    }
    return ranks;
  }

  Future<RankModel> loadRankData(context, userId) async {
    String apiUrl = apiBase + '/apicoupons/loadUserRank';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': APPCOMANYID,
      'user_id': userId
    }).then((v) => {results = v});
    RankModel rank;
    rank = RankModel.fromJson(results['rank']);
    return rank;
  }

  Future<List<StampModel>> loadUserStamps(context, userId) async {
    List<StampModel> stamps = [];

    Map<dynamic, dynamic> stampResults = {};
    await Webservice().loadHttp(context, apiLoadUserStampUrl, {
      'user_id': userId,
      'company_id': APPCOMANYID
    }).then((value) => stampResults = value);

    stamps = [];
    if (stampResults['isLoad']) {
      for (var item in stampResults['stamps']) {
        stamps.add(StampModel.fromJson(item));
      }
    }

    return stamps;
  }
}
