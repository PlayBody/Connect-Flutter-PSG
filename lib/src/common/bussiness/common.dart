import 'dart:convert';

import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/home_menu_model.dart';

import '../apiendpoint.dart';
import '../const.dart';

class ClCommon {
  Future<bool> isNetworkFile(context, String path, String? fileUrl) async {
    if (fileUrl == null) return false;
    String apiUrl = apiBase + '/api/isFileCheck';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(
        context, apiUrl, {'path': path + fileUrl}).then((v) => {results = v});

    if (results['isFile'] == null) {
      return false;
    }
    return results['isFile'];
  }

  Future<List<HomeMenuModel>> loadConnectHomeMenu(context) async {
    Map<dynamic, dynamic> results = {};
    String apiUrl = apiBase + '/api/loadConnectHomeMenuSetting';
    await Webservice().loadHttp(context, apiUrl,
        {'company_id': APPCOMANYID}).then((value) => results = value);

    List<HomeMenuModel> homeMenus = [];
    if (results['isLoad']) {
      for (var item in results['menus']) {
        homeMenus.add(HomeMenuModel.fromJson(item));
      }
    }
    return homeMenus;
  }

  Future<int> loadBadgeCount(context, dynamic param) async {
    Map<dynamic, dynamic> results = {};
    String apiUrl = apiBase + '/api/loadBadgeCount';
    await Webservice().loadHttp(context, apiUrl,
        {'condition': jsonEncode(param)}).then((value) => results = value);

    return int.parse(results['badge_count'].toString());
  }

  Future<bool> clearBadge(context, dynamic param) async {
    String apiUrl = apiBase + '/api/clearBadgeCount';
    await Webservice()
        .loadHttp(context, apiUrl, {'condition': jsonEncode(param)});

    return true;
  }
}
