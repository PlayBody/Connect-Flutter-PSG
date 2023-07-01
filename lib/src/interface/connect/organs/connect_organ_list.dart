import 'dart:async';
import 'dart:math';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/organs/connect_organ_view.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class ConnectOrganList extends StatefulWidget {
  const ConnectOrganList({Key? key}) : super(key: key);

  @override
  _ConnectOrganList createState() => _ConnectOrganList();
}

class _ConnectOrganList extends State<ConnectOrganList> {
  late Future<List> loadData;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? initCameraPosition;

  List<OrganModel> organs = [];
  String openQuestion = '';

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Dialogs().waitDialog(context, '位置情報権限を設定してください。');
      Navigator.pop(context);
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng initialPosition = LatLng(position.latitude, position.longitude);

    initCameraPosition = CameraPosition(
      target: initialPosition,
      zoom: 15,
    );
    setState(() {});

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadOrganListUrl,
        {'company_id': APPCOMANYID}).then((value) => results = value);
    organs = [];

    if (results['isLoad']) {
      for (var item in results['organs']) {
        if (item['lat'] == null ||
            item['lon'] == null ||
            double.tryParse(item['lat']) == null ||
            double.tryParse(item['lon']) == null) {
          item['distance'] = '';
        } else {
          LatLng latlong =
              new LatLng(double.parse(item['lat']), double.parse(item['lon']));
          item['distance'] = clacDistance(initialPosition, latlong);
          _markers.add(Marker(
              markerId: MarkerId("a"),
              draggable: true,
              position: latlong,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              onDragEnd: (_currentlatLng) {
                latlong = _currentlatLng;
              }));
        }
        item['is_open'] =
            await ClOrgan().isOpenOrgan(context, item['organ_id']);
        organs.add(OrganModel.fromJson(item));
      }
    }

    setState(() {});
    return [];
  }

  int clacDistance(LatLng pos1, LatLng pos2) {
    const double pi = 3.1415926535897932;
    const R = 6371e3; // metres
    var fLat1 = pos1.latitude * pi / 180; // φ, λ in radians
    var fLat2 = pos2.latitude * pi / 180;
    var si = (pos2.latitude - pos1.latitude) * pi / 180;
    var ra = (pos2.longitude - pos1.longitude) * pi / 180;

    var a = sin(si / 2) * sin(si / 2) +
        cos(fLat1) * cos(fLat2) * sin(ra / 2) * sin(ra / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double d = R * c;

    return d.floor();
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '店舗一覧',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  // _getOrganSearch(),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: GoogleMap(
                      markers: _markers,
                      mapType: MapType.normal,
                      initialCameraPosition: initCameraPosition!,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  // _getMapView(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...organs.map((e) => _getOrganItem(e)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

  var txtQuestionStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  var txtAnswerStyle = TextStyle(fontSize: 18);

  Widget _getOrganSearch() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          prefixIcon: Icon(Icons.search),
          hintText: '店舗を検索',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _getMapView() {
  //   return Container(
  //     height: 180,
  //     decoration: BoxDecoration(color: Colors.grey),
  //     child: GoogleMap(
  //       markers: _markers,
  //       mapType: MapType.terrain,
  //       initialCameraPosition: initCameraPosition!,
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller.complete(controller);
  //       },
  //     ),
  //   );
  // }

  Widget _getOrganItem(OrganModel item) {
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
          _getOrganImage(item),
          SizedBox(width: 12),
          _getOrganContent(item),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _getOrganImage(item) {
    return Container(
      width: 90,
      height: 90,
      child: item.organImage == null || item.organImage!.isEmpty
          ? Image.network(organImageUrl + 'no_image.jpg')
          : Image.network(organImageUrl + item.organImage!),
    );
  }

  Widget _getOrganContent(OrganModel item) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: EdgeInsets.only(top: 4),
              child: Row(children: [
                Text(
                  item.isOpen ? '営業中' : '',
                  style: TextStyle(fontSize: 12),
                ),
                Expanded(child: Container()),
                Text((item.distance == null || item.distance == '' || !item.distance_status) ? '' : (item.distance! + 'm'),
                    style: TextStyle(fontSize: 16))
              ])),
          Container(
              child: Text(item.organName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Container(
              child: Text(item.organAddress!, style: TextStyle(fontSize: 12))),
          if (item.snsurl != null && item.snsurl != '')
            Container(
                child: Row(children: [
              // Container(
              //     padding: EdgeInsets.all(4),
              //     color: Colors.green,
              //     child: Text(
              //       'SNS',
              //       style: TextStyle(color: Colors.white, fontSize: 12),
              //     )),
              Flexible(
                  child: Text(
                item.snsurl!,
                softWrap: true,
              )),
              IconButton(
                  onPressed: () => _launchInBrowser(item.snsurl!),
                  icon: Icon(
                    Icons.link,
                    color: Colors.blue,
                    size: 32,
                  ))
            ])),
          // GestureDetector(
          //     onTap: () => _launchInBrowser(item.snsurl!),
          //     child: Container(child: Text('SNS : ' + item.snsurl!))),
          Container(
            child: Row(children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    padding: EdgeInsets.all(6),
                    visualDensity: VisualDensity(vertical: -2)),
                child: Text('電話問い合わせ', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  callDialog(
                      context, item.organPhone == null ? '' : item.organPhone!);
                },
              ),
              Expanded(child: Container()),
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ConnectOrganView(organId: item.organId);
                    }));
                  },
                  child: Text('詳細', style: TextStyle(fontSize: 14)))
            ]),
          )
        ],
      ),
    );
  }

  void callDialog(BuildContext context, String phone) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Text('電話問い合わせ',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    primary: Colors.orange),
                child: Container(
                    child: Row(children: [
                  Container(
                      padding: EdgeInsets.only(left: 30),
                      alignment: Alignment.center,
                      width: 60,
                      child: Icon(Icons.phone, color: Colors.white, size: 42)),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text('お問い合わせ', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          Text(phone, style: TextStyle(fontSize: 22))
                        ],
                      ))
                ])),
                onPressed: () {
                  launchUrl(Uri.parse("tel://" + phone));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String _url) async {
    launchUrl(Uri.parse(_url));
    // if (await canLaunch(_url)) {
    //   await launch(_url);
    // } else {
    //   throw 'Could not launch $_url';
    // }
  }
}
