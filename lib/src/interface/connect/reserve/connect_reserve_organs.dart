import 'package:connect/src/common/const.dart';
import 'package:connect/src/interface/connect/reserve/reserve_multiuser.dart';
import 'package:flutter/material.dart';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';

class ConnectReserveOrgan extends StatefulWidget {
  const ConnectReserveOrgan({Key? key}) : super(key: key);

  @override
  _ConnectReserveOrgan createState() => _ConnectReserveOrgan();
}

class _ConnectReserveOrgan extends State<ConnectReserveOrgan> {
  late Future<List> loadData;

  List<OrganModel> organs = [];

  @override
  void initState() {
    super.initState();
    loadData = initLoadData();
  }

  Future<List> initLoadData() async {
    organs = await ClOrgan().loadOrganList(context, APPCOMANYID);

    if (organs.length == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ReserveMultiUser(organId: organs.first.organId);
      }));
    }
    return organs;
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '予約店舗',
      render: Center(
        child: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                  padding: EdgeInsets.all(12),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    ...organs.map((d) => _getOrganContent(d)),
                  ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _getOrganContent(OrganModel organ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ReserveMultiUser(organId: organ.organId);
        }));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(child: _getOrganImage(organ.organImage)),
            _getOrganTitle(organ)
          ],
        ),
        elevation: 4,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  Widget _getOrganImage(imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        image: imageUrl == null
            ? DecorationImage(
                image: AssetImage('images/no_image.jpg'), fit: BoxFit.cover)
            : DecorationImage(
                image: NetworkImage(organImageUrl + imageUrl),
                fit: BoxFit.cover),
      ),
    );
  }

  Widget _getOrganTitle(organ) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xFF709a49), borderRadius: BorderRadius.circular(6)),
          child: Text(
            organ.organName,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: Container(
            alignment: Alignment.center,
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.keyboard_arrow_right,
                color: Color(0xFF709a49), size: 16),
          ),
        )
      ],
    );
  }
}
