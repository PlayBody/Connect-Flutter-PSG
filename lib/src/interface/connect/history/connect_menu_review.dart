import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/order_model.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;

class ConnectMenuReview extends StatefulWidget {
  final String orderId;
  const ConnectMenuReview({required this.orderId, Key? key}) : super(key: key);

  @override
  _ConnectMenuReview createState() => _ConnectMenuReview();
}

class _ConnectMenuReview extends State<ConnectMenuReview> {
  late Future<List> loadData;

  String organName = '';
  String menuName = '';
  String menuId = '';
  int servieMark = 0;
  int priceMark = 0;

  String? errServie;
  String? errPrice;
  String? errContent;

  var contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadMenuData();
  }

  Future<List> loadMenuData() async {
    OrderModel? order =
        await ClReserve().loadReserveInfo(context, widget.orderId);
    if (order != null) {
      organName = order.organName;
      if (order.menus.length > 0) {
        menuName = order.menus.first.menuTitle;
        menuId =
            order.menus.first.menuId == null ? '' : order.menus.first.menuId!;
      }
      if (order.menus.length > 1) menuName = menuName + ' ＋ その他 ';

      Map<dynamic, dynamic> resultsReview = {};
      await Webservice().loadHttp(context, apiLoadMenuReviewUrl, {
        'user_id': globals.userId,
        'menu_id': menuId
      }).then((value) => resultsReview = value);
      if (resultsReview['isLoad']) {
        servieMark = int.parse(resultsReview['review']['service_review']);
        priceMark = int.parse(resultsReview['review']['price_review']);
        contentController.text = resultsReview['review']['review_content'];
      }
    }
    setState(() {});
    return [];
  }

  Future<void> saveReview() async {
    bool isFormCheck = true;
    if (servieMark == 0) {
      errServie = warningCommonInputRequire;
      isFormCheck = false;
    } else {
      errServie = null;
    }

    if (priceMark == 0) {
      errPrice = warningCommonInputRequire;
      isFormCheck = false;
    } else {
      errPrice = null;
    }
    if (contentController.text == '') {
      errContent = warningCommonInputRequire;
      isFormCheck = false;
    } else {
      errContent = null;
    }

    setState(() {});
    if (!isFormCheck) return;

    bool conf = await Dialogs().confirmDialog(context, qCommonSave);
    if (!conf) return;

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiSaveMenuReviewUrl, {
      'user_id': globals.userId,
      'menu_id': menuId,
      'service_mark': servieMark.toString(),
      'price_mark': priceMark.toString(),
      'content': contentController.text
    }).then((value) => results = value);

    if (results['isSave']) {
      Navigator.pop(context);
    } else {
      Dialogs().infoDialog(context, errServerActionFail);
    }
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = '評価';
    return MainForm(
      title: '評価',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _getTitle(),
                          SizedBox(height: 12),
                          _getServieTitle(),
                          _getServiceStar(),
                          _getErrorContent(errServie),
                          SizedBox(height: 12),
                          _getPriceTitle(),
                          _getPriceStar(),
                          _getErrorContent(errPrice),
                          SizedBox(height: 16),
                          _getCommentTitle(),
                          _getCommentContent()
                        ],
                      ),
                    )),
                    Container(
                      padding: EdgeInsets.only(top: 12),
                      child: ElevatedButton(
                          child: Text('匿名で送信'),
                          onPressed: () {
                            saveReview();
                          }),
                    )
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  var txtContentStyle = TextStyle(fontSize: 14);
  var txtTitleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  Widget _getTitle() {
    return Row(
      children: [
        Container(
          child: Text(organName, style: txtTitleStyle),
        ),
        Expanded(child: Container()),
        Container(
          child: Text(menuName),
        )
      ],
    );
  }

  Widget _getServieTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Text('サービスに満足いただけましたか？', style: txtTitleStyle),
    );
  }

  Widget _getPriceTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Text('価格に満足いただけましたか？', style: txtTitleStyle),
    );
  }

  Widget _getErrorContent(String? err) {
    if (err == null) return Container();
    return Container(
        alignment: Alignment.topLeft,
        child: Text(err, style: TextStyle(color: Colors.red)));
  }

  Widget _getCommentTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Text('その他（ご意見・ご要望）', style: txtTitleStyle),
    );
  }

  Widget _getCommentContent() {
    return Container(
      child: TextFormField(
        controller: contentController,
        maxLines: 5,
        decoration: InputDecoration(
            errorText: errContent,
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }

  Widget _getServiceStar() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            GestureDetector(
                child: servieMark >= 1
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    servieMark = 1;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: servieMark >= 2
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    servieMark = 2;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: servieMark >= 3
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    servieMark = 3;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: servieMark >= 4
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    servieMark = 4;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: servieMark >= 5
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    servieMark = 5;
                  });
                }),
          ],
        ));
  }

  Widget _getPriceStar() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            GestureDetector(
                child: priceMark >= 1
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    priceMark = 1;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: priceMark >= 2
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    priceMark = 2;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: priceMark >= 3
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    priceMark = 3;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: priceMark >= 4
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    priceMark = 4;
                  });
                }),
            SizedBox(width: 24),
            GestureDetector(
                child: priceMark >= 5
                    ? Icon(Icons.star, color: Colors.yellow, size: 32)
                    : Icon(Icons.star_border_outlined, size: 32),
                onTap: () {
                  setState(() {
                    priceMark = 5;
                  });
                }),
          ],
        ));
  }
}
