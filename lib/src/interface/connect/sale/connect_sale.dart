import 'dart:async';

import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/globals.dart' as globals;

class ConnectSale extends StatefulWidget {
  final String url;
  const ConnectSale({required this.url, Key? key}) : super(key: key);

  @override
  _ConnectSale createState() => _ConnectSale();
}

class _ConnectSale extends State<ConnectSale> {
  late Future<List> loadData;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    loadData = loadSiteData();
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = '通販';
    return MainForm(
        title: '通販',
        render: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  // padding: EdgeInsets.only(left: 10, right: 10),
                  child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(Factory(() => EagerGestureRecognizer())),
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Future<List> loadSiteData() async {
    return [];
  }
}
