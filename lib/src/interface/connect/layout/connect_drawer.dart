// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// import 'package:crm_app/interface/reginfo.dart';
import 'package:connect/src/common/functions.dart';
import 'package:flutter/material.dart';

import '../connect_home.dart';
import '../connect_login.dart';
import '../connect_setting.dart';
import '../../../common/globals.dart' as globals;
// Set up a mock HTTP client.

class ConnectDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
              icon: Icons.home,
              text: 'メニューに戻る',
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ConnectHome();
                  }))),
          Divider(),
          // createDrawerBodyItem(
          //     icon: Icons.info,
          //     text: 'お問い合わせ',
          //     onTap: () =>
          //         Navigator.push(context, MaterialPageRoute(builder: (_) {
          //           return ConnectQuestions();
          //         }))),
          // createDrawerBodyItem(
          //     icon: Icons.info,
          //     text: '登録情報',
          //     onTap: () =>
          //         Navigator.push(context, MaterialPageRoute(builder: (_) {
          //           return ConnectRegister();
          //         }))),
          if (globals.userId != '')
            createDrawerBodyItem(
                icon: Icons.settings,
                text: '設定',
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ConnectSetting();
                    }))),
          if (globals.userId == '')
            createDrawerBodyItem(
                icon: Icons.settings,
                text: 'ログイン',
                onTap: () => Navigator.pushNamed(context, '/Login')),
          if (globals.userId != '')
            createDrawerBodyItem(
                icon: Icons.settings,
                text: 'ログアウト',
                onTap: () => Funcs().logout(context)),
        ],
      ),
    );
  }
}

Widget createDrawerHeader() {
  return Container(
    height: 80.0,
    color: Colors.grey,
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(children: <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text(
            "CRM APP",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    ),
  );
}

Widget createDrawerBodyItem(
    {required IconData icon, required String text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
