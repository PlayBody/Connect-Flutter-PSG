import 'package:connect/src/common/bussiness/common.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/organ_special_time_model.dart';
import 'package:connect/src/model/organ_time_model.dart';
import 'package:connect/src/model/organmodel.dart';

import '../apiendpoint.dart';
import '../const.dart';

class ClOrgan {
  Future<List<OrganModel>> loadOrganList(context, String companyId) async {
    String apiUrl = apiBase + '/apiorgans/getOrgans';

    List<OrganModel> organs = [];
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': companyId,
    }).then((v) => {results = v});

    for (var item in results['organs']) {
      if (item['image'] != null) {
        bool isimage = await ClCommon()
            .isNetworkFile(context, 'assets/images/organs/', item['image']);
        if (!isimage) item['image'] = null;
      }
      organs.add(OrganModel.fromJson(item));
    }

    return organs;
  }

  Future<OrganModel?> loadOrganInfo(context, String organId) async {
    String apiUrl = apiBase + '/apiorgans/loadOrganInfo';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(
        context, apiUrl, {'organ_id': organId}).then((v) => {results = v});
    OrganModel? organ;
    if (results['isLoad']) {
      organ = OrganModel.fromJson(results['organ']);
    }
    return organ;
  }

  Future<dynamic> loadOrganBussinessTime(context, String organId) async {
    String apiUrl = apiBase + '/apiorgans/loadOrganBusinessTime';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(
        context, apiUrl, {'organ_id': organId}).then((v) => {results = v});

    results['data']['from_time'] = results['data']['from_time'] == null
        ? "00:00:00"
        : (results['data']['from_time'] + ":00");
    results['data']['to_time'] = (results['data']['to_time'] == null ||
            results['data']['to_time'] == '24:00')
        ? "23:59:59"
        : (results['data']['to_time'] + ":00");
    return results['data'];
  }

  Future<dynamic> loadOrganInfoByNum(context, String organNumber) async {
    String apiUrl = apiBase + '/apiorgans/getOrganInfoByOrganNumber';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': APPCOMANYID,
      'organ_number': organNumber,
    }).then((v) => {results = v});

    return results['organ'];
  }

  Future<List<OrganTimeModel>> loadOrganTimes(context, String organId) async {
    String apiUrl = apiBase + '/apiorgans/loadOrganTimes';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(
        context, apiUrl, {'organ_id': organId}).then((v) => {results = v});

    List<OrganTimeModel> times = [];
    if (results['isLoad']) {
      for (var item in results['data']) {
        times.add(OrganTimeModel.fromJson(item));
      }
    }
    return times;
  }

  Future<List<OrganSpecialTimeModel>> loadOrganSpecialTimes(
      context, String organId) async {
    String apiUrl = apiBase + '/apis/organ/opentime/getTodaySpecialTime';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(
        context, apiUrl, {'organ_id': organId}).then((v) => {results = v});

    List<OrganSpecialTimeModel> times = [];
    if (results['is_load']) {
      for (var item in results['times']) {
        times.add(OrganSpecialTimeModel.fromJson(item));
      }
    }
    return times;
  }

  Future<bool> isOpenOrgan(context, String organId) async {
    String apiUrl = apiBase + '/apis/organ/opentime/isOpen';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(
        context, apiUrl, {'organ_id': organId}).then((v) => {results = v});
    return results['is_open'];
  }
}
