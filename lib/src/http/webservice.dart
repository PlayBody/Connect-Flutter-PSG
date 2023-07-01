import 'dart:convert';
import 'dart:io';

import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class Webservice {
  Future<Map> loadHttp(
      BuildContext context, String url, Map<String, dynamic> param) async {
    // HttpClient httpClient = new HttpClient()
    //   ..badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) =>
    //           AppConst.trustSelfSigned);
    // IOClient ioClient = new IOClient(httpClient);
    bool conf = false;
    do {
      try {
        final response = await http.post(Uri.parse(url),
            headers: {
              "Accept": "application/json; charset=UTF-8",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: param);
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          conf = await Dialogs().retryOrExit(context, errServerString);
        }
      } catch (e) {
        conf = await Dialogs().retryOrExit(context, errNetworkString);
      }
    } while (conf);
    //return {};
    exit(0);
  }

  Future<void> callHttpMultiPart(
      String url, String filename, String uploadUrl) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile(
      'upload',
      File(filename).readAsBytes().asStream(),
      File(filename).lengthSync(),
      filename: uploadUrl,
    ));

    var res = await request.send();

    print(res.statusCode);
  }
}
