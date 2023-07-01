import 'dart:developer';
import 'dart:io';

import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/common/bussiness/user.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/check/connect_checkin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../common/globals.dart' as globals;

class ConnectCheck extends StatefulWidget {
  const ConnectCheck({Key? key}) : super(key: key);

  @override
  _ConnectCheck createState() => _ConnectCheck();
}

class _ConnectCheck extends State<ConnectCheck> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = 'チェックイン';
    return MainForm(title: 'チェックイン', render: _buildQrView(context));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      String _format = describeEnum(scanData.format);
      String? _code = scanData.code;
      String err = '';
      String organCode = '';
      if (_format == 'qrcode') {
        if (!isQrCode(_code)) {
          err = "不正確なQRコードです。";
        }
        List<String> _data = _code!.split('!');
        organCode = _data[3];
        if (!checkDomain(_data[2])) {
          err = "このお店のアプリのQRコードではありません。";
        }
        if (!(await checkGPS(_data[3]))) {
          err = "GPS認証に失敗しました。";
        }
      } else {
        err = "不正確なQRコードです。";
      }

      if (err == '') {
        var organ = await ClOrgan().loadOrganInfoByNum(context, organCode);
        if (organ == null) {
          await Dialogs().waitDialog(context, 'システムエラーが発生しました。');
          Navigator.pop(context);
        } else {
          // var reserve =
          //     await ClReserve().getReserveNow(context, organ['organ_id']);
          // print(organ['organ_id']);
          // if (reserve == null) {
          //   await Dialogs().waitDialog(context, '予約内容は存在しません。');
          //   Navigator.pop(context);
          // } else {
          //   Navigator.pop(context);
          //   Navigator.push(context, MaterialPageRoute(builder: (_) {
          //     return ConnectCheckIn(
          //         reserveId: reserve.reserveId, organId: organ['organ_id']);
          //   }));
          // }
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ConnectCheckIn(organId: organ['organ_id']);
          }));
        }

        // await checkIn(scanData.code);

        // Navigator.pop(context);

        //Dialogs().infoDialog(context, scanData.code);
      } else {
        await Dialogs().waitDialog(context, err);
        Navigator.pop(context);
      }
      controller.resumeCamera();
      result = scanData;
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  bool isQrCode(_code) {
    if (!(_code.indexOf('!') > 0)) return false;

    List<String> _data = _code.split('!');
    if (_data.length != 5) return false;

    int sum = 0;
    for (var i = 0; i < _data[1].length; i++) {
      sum = sum + int.parse(_data[1].substring(i, i + 1));
    }
    print('-------------------------------------------');
    print(sum.toString());
    print(_data);
    if (sum.toString() != _data[4]) return false;

    return true;
  }

  bool checkDomain(String domain) {
    if (domain == APPDOMAIN)
      return true;
    else
      return false;
  }

  Future<bool> checkGPS(organNumber) async {
    var organ = await ClOrgan().loadOrganInfoByNum(context, organNumber);

    if (organ == null) return false;
    if (organ['lat'] == null || organ['lon'] == null) return false;

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    return true;
  }

  Future<void> checkIn(qrCode) async {
    String organCode = qrCode.toString().split('!')[3];

    var organ = await ClOrgan().loadOrganInfoByNum(context, organCode);

    print(organ);
    if (organ == null) return;

    String ticketCount = (organ['checkin_ticket_consumption'] == null ||
            organ['checkin_ticket_consumption'] == '')
        ? '0'
        : organ['checkin_ticket_consumption'];

    var userInfo = {}; //await ClUser().loadUserInfo(context);
    var userTicket = userInfo['user_ticket'];
    if (userTicket == null) userTicket = '0';

    if (int.parse(ticketCount) > 0 &&
        (int.parse(ticketCount) > int.parse(userTicket))) {
      await Dialogs().waitDialog(context, 'チケットが足りません。');
      return;
    } else {
      bool isComplete =
          await ClReserve().updateReserveStatus(context, organ['organ_id']);
      if (isComplete && int.parse(ticketCount) > 0) {
        await ClUser().updateUserTicket(context,
            (int.parse(userTicket) - int.parse(ticketCount)).toString());
      }
      if (!isComplete) {
        await Dialogs().waitDialog(context, '予約データが存在しません。');
      }
    }
  }
}
