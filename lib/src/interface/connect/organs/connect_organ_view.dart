import 'dart:async';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/organ_special_time_model.dart';
import 'package:connect/src/model/organ_time_model.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ConnectOrganView extends StatefulWidget {
  final String organId;
  const ConnectOrganView({required this.organId, Key? key}) : super(key: key);

  @override
  _ConnectOrganView createState() => _ConnectOrganView();
}

class _ConnectOrganView extends State<ConnectOrganView> {
  late Future<List> loadData;
  OrganModel? organ;
  List<OrganTimeModel> openTimes = [];
  List<OrganSpecialTimeModel> openSpecialTimes = [];
  bool isOpen = false;

  // String organName = '';
  // String? organImage;
  // String organAddress = '';
  // String phoneNumber = '';
  // String comment = '';
  // String activeStartTime = '';
  // String activeEndTime = '';
  // String access = '';
  // String parking = '';

  @override
  void initState() {
    super.initState();
    loadData = loadOrganData();
  }

  Future<List> loadOrganData() async {
    organ = await ClOrgan().loadOrganInfo(context, widget.organId);
    if (organ == null) return [];

    openTimes = await ClOrgan().loadOrganTimes(context, widget.organId);
    openSpecialTimes =
        await ClOrgan().loadOrganSpecialTimes(context, widget.organId);

    isOpen = await ClOrgan().isOpenOrgan(context, widget.organId);
    // Map<dynamic, dynamic> results = {};
    // await Webservice().loadHttp(context, apiLoadOrganInfo,
    //     {'organ_id': widget.organId}).then((value) => results = value);

    // if (results['isLoad']) {
    //   var organ = results['organ'];
    //   organName = organ['organ_name'];
    //   organImage = organ['image'];
    //   organAddress = organ['address'] == null ? '' : organ['address'];
    //   phoneNumber = organ['phone'] == null ? '' : organ['phone'];
    //   comment = organ['comment'] == null ? '' : organ['comment'];
    //   activeStartTime = organ['active_start_time'] == null
    //       ? ''
    //       : DateFormat('HH:mm').format(
    //           DateTime.parse('2000-01-01 ' + organ['active_start_time']));
    //   activeEndTime = organ['active_end_time'] == null
    //       ? ''
    //       : DateFormat('HH:mm')
    //           .format(DateTime.parse('2000-01-01 ' + organ['active_end_time']));

    //   access = organ['access'] == null ? '' : organ['access'];
    //   parking = organ['parking'] == null ? '' : organ['parking'];
    // }

    setState(() {});
    return [];
  }

  void onTapGoogleMap() {
    // MapsLauncher.launchQuery(
    //     '1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA');
    if (organ!.lat == null || organ!.lon == null) {
      Dialogs().infoDialog(context, '店舗の位置が設定されていません。');
      return;
    }
    MapsLauncher.launchCoordinates(
        double.parse(organ!.lat!), double.parse(organ!.lon!));
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  _getOrganItem(),
                  SizedBox(height: 60),
                  _getPhoneContent(),
                  _getBussinessTime(),
                  _getAccessContent(),
                  _getParkContent(),
                  _getComment(),
                ],
              )),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getOrganItem() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getOrganImage(),
          SizedBox(width: 12),
          _getOrganContent(),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  double labelWidth = 120;
  var rowPadding = EdgeInsets.fromLTRB(30, 10, 30, 10);
  var decorationTopLine =
      BoxDecoration(border: Border(top: BorderSide(color: Colors.grey)));
  Widget _getOrganImage() {
    return Container(
      width: 140,
      height: 90,
      child: organ!.organImage == null || organ!.organImage!.isEmpty
          ? Image.network(organImageUrl + 'no_image.jpg')
          : Image.network(organImageUrl + organ!.organImage!),
    );
  }

  Widget _getOrganContent() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isOpen)
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                '営業中',
                style: TextStyle(fontSize: 12),
              ),
            ),
          Container(
              child: Text(organ!.organName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Container(
              child: Text(organ!.organAddress ?? '',
                  style: TextStyle(fontSize: 12))),
          Container(
              child: ElevatedButton(
            child: Text('地図アプリで見る'),
            onPressed: () => onTapGoogleMap(),
          )),
        ],
      ),
    );
  }

  Widget _getPhoneContent() {
    return Container(
        padding: rowPadding,
        decoration: decorationTopLine,
        child: Row(
          children: [
            Container(width: labelWidth, child: Text('電話番号')),
            Container(child: Text(organ!.organPhone ?? ''))
          ],
        ));
  }

  Widget _getBussinessTime() {
    return Container(
        padding: rowPadding,
        decoration: decorationTopLine,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: labelWidth, child: Text('営業時間')),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...openTimes.map((e) => Row(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: 80,
                            child: (openTimes.indexOf(e) > 0 &&
                                    e.weekday ==
                                        openTimes[openTimes.indexOf(e) - 1]
                                            .weekday)
                                ? null
                                : Text('${e.weekday}曜日')),
                        Container(child: Text('${e.fromTime} ~ ${e.toTime}'))
                      ],
                    )),
                ...openSpecialTimes.map((e) => Row(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: 80,
                            child:
                                (Text(DateFormat('M月d日').format(e.fromTime)))),
                        Container(
                            child: Text(
                                '${DateFormat('HH:mm').format(e.fromTime)} ~ ${DateFormat('HH:mm').format(e.toTime)}'))
                      ],
                    ))
              ],
            ))
          ],
        ));
  }

  Widget _getAccessContent() {
    return Container(
        padding: rowPadding,
        decoration: decorationTopLine,
        child: Row(
          children: [
            Container(width: labelWidth, child: Text('アクセス')),
            Container(child: Text(organ!.access ?? ''))
          ],
        ));
  }

  Widget _getParkContent() {
    return Container(
        padding: rowPadding,
        decoration: decorationTopLine,
        child: Row(
          children: [
            Container(width: labelWidth, child: Text('駐車場')),
            Container(child: Text(organ!.parking ?? ''))
          ],
        ));
  }

  Widget _getComment() {
    return Container(
        padding: rowPadding,
        decoration: decorationTopLine,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: labelWidth, child: Text('その他')),
            Expanded(child: Text(organ!.organComment ?? ''))
          ],
        ));
  }
}
