// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';

import '../../../common/globals.dart' as global;

class MyConnetAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      elevation: 8,
      titleSpacing: 0,
      title: Container(
        height: 70,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 10, left: 16),
                    // margin: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      global.connectHeaerTitle,
                      style: TextStyle(
                          color: Color(0xffeb5a00),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.5),
                    )),
                Container(
                  width: 150,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Color(0xffd4dc57),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )),
                )
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
      actions: [
        Container(
          padding: EdgeInsets.only(top: 10),
          width: 70,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_rounded, size: 32, color: Color(0xffeb5a00)),
              Text(
                global.userName,
                style: TextStyle(fontSize: 10, color: Color(0xffeb5a00)),
              )
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            child: Container(
              width: 70,
              height: 70,
              color: Color(0xffeb5a00),
              child: Icon(Icons.menu, color: Colors.white, size: 32),
            ),
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity(horizontal: -2),
              padding: EdgeInsets.all(0),
              elevation: 0,
            ))
      ],
    );
  }
}
