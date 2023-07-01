import 'dart:convert';

import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/stafflistmodel.dart';

import '../apiendpoint.dart';

class ClStaff {
  Future<List<StaffListModel>> loadStaffs(context, dynamic condition) async {
    String apiStaffLoadAddpointUrl = apiBase + '/apistaffs/getStaffs';

    List<StaffListModel> staffs = [];
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiStaffLoadAddpointUrl,
        {'condition': jsonEncode(condition)}).then((v) => {results = v});

    for (var item in results['staffs']) {
      staffs.add(StaffListModel.fromJson(item));
    }

    return staffs;
  }
}
