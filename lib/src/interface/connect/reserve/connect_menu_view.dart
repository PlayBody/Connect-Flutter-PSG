import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/functions.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:flutter/material.dart';

class ConnectMenuView extends StatefulWidget {
  final String menuId;
  const ConnectMenuView({required this.menuId, Key? key}) : super(key: key);

  @override
  _ConnectMenuView createState() => _ConnectMenuView();
}

class _ConnectMenuView extends State<ConnectMenuView> {
  late Future<List> loadData;

  String? menuImage;
  String? menuName;
  String? menuPrice;
  String? menuDetail;
  String? menuComment;

  @override
  void initState() {
    super.initState();
    loadData = loadMenuData();
  }

  Future<List> loadMenuData() async {
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadAdminMenuInfoUrl,
        {'menu_id': widget.menuId}).then((value) => results = value);

    if (results['isLoad']) {
      setState(() {
        menuImage = results['menu']['menu_image'];
        menuName = results['menu']['menu_title'];
        menuPrice = results['menu']['menu_price'];
        menuDetail = results['menu']['menu_detail'];
        menuComment = results['menu']['menu_comment'];
      });
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'メニュー',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 30),
                      _getMenuImage(),
                      SizedBox(height: 40),
                      _getMenuTitle(),
                      _getMenuDetail(),
                      _getMenuComment(),
                    ],
                  ),
                ),
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

  Widget _getMenuImage() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      height: 200,
      child: menuImage == null
          ? Image.asset('images/no_image.jpg', fit: BoxFit.contain)
          : Image.network(
              menuImageUrl + menuImage!,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _getMenuTitle() {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      padding: EdgeInsets.fromLTRB(30, 0, 30, 4),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  child: Text(
            menuName == null ? '' : menuName!,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ))),
          Container(
              height: 30,
              alignment: Alignment.bottomRight,
              child: menuPrice == null
                  ? Text('')
                  : Text(
                      '￥' + Funcs().currencyFormat(menuPrice!),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
        ],
      ),
    );
  }

  Widget _getMenuDetail() {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Text(
          menuDetail == null ? '' : menuDetail!,
          style: TextStyle(fontSize: 16),
        ));
  }

  Widget _getMenuComment() {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'その他・備考',
                style: TextStyle(fontSize: 16),
              )),
          Container(
              alignment: Alignment.topLeft,
              child: Text(
                menuComment == null ? '' : menuComment!,
                style: TextStyle(fontSize: 18),
                //style: styleContent,
              ))
        ],
      ),
    );
  }
}
