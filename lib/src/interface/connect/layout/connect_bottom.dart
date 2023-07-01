import 'package:connect/src/interface/connect/product/product_cart.dart';
import 'package:flutter/material.dart';
import '../connect_setting.dart';
import '../../../common/globals.dart' as globals;

class ConnectBottomBar extends StatelessWidget {
  final bool? isHome;
  const ConnectBottomBar({this.isHome, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Container(width: 20),
          ConnectBottomItem(
              icon: Image.asset(
                'images/icon/icon_home.png',
                color: Colors.white,
                width: 24,
              ),
              label: 'ホーム',
              tap: isHome == null
                  ? () => Navigator.pushNamed(context, '/Home')
                  : () {}),
          ConnectBottomItem(
            icon: Image.asset(
              'images/icon/icon_back.png',
              color: Colors.white,
              width: 24,
            ),
            label: '戻る',
            tap: isHome == null
                ? () {
                    Navigator.pop(context);
                  }
                : () {},
          ),
          if (globals.isCart && globals.userId != '')
            ConnectBottomItem(
              icon: Image.asset(
                'images/icon/icon_footer_cart.png',
                color: Colors.white,
                width: 24,
              ),
              label: 'カート',
              tap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ProductCart();
              })),
            ),
          ConnectBottomItem(
            icon: Image.asset(
              'images/icon/icon_setting.png',
              color: Colors.white,
              width: 24,
            ),
            label: '設定',
            tap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ConnectSetting();
            })),
          ),
          Container(width: 20),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/footer_back.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class ConnectBottomItem extends StatelessWidget {
  final String label;
  final icon;
  final tap;
  const ConnectBottomItem(
      {required this.label, required this.icon, required this.tap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(top: 5),
            primary: Colors.transparent,
            onPrimary: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent),
        child: Column(children: [
          icon,
          Container(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          )
        ]),
        onPressed: tap,
      ),
    ));
  }
}
