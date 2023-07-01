import 'dart:io';
import 'package:connect/src/common/bussiness/company.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/model/companymodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseView extends StatefulWidget {
  const LicenseView({Key? key}) : super(key: key);

  @override
  _LicenseView createState() => _LicenseView();
}

class _LicenseView extends State<LicenseView> {
  late Future<List> loadData;

  bool ischeck = false;
  CompanyModel? company;

  @override
  void initState() {
    super.initState();
    loadData = loadCompanyData();
  }

  Future<List> loadCompanyData() async {
    company = await ClCompany().loadCompanyInfo(context, APPCOMANYID);
    return [];
  }

  void onReadCheck(isread) {
    ischeck = isread;
    setState(() {});
  }

  Future<void> onTapAgree() async {
    if (!ischeck) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_rirakukan_agree_license', true);

    Navigator.pushNamed(context, '/Home');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _getBodyContent();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )));
  }

  Widget _getBodyContent() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _getPageTitle(),
          _getLicenseContent(),
          _getBottom(),
        ],
      ),
    );
  }

  Widget _getPageTitle() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Text('利用規約',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }

  Widget _getLicenseContent() {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(children: [
      _getTextView(),
      _getCheckContent(),
    ])));
  }

  Widget _getTextView() {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Html(
          data: company == null ? '' : company!.licensText,
          style: {'h5': Style(padding: EdgeInsets.only(top: 20, bottom: 5))},
        ));
  }

  Widget _getCheckContent() {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Row(
          children: [
            Checkbox(value: ischeck, onChanged: (v) => onReadCheck(v!)),
            Container(child: Text('すべて読みました。'))
          ],
        ));
  }

  var buttonSide = BorderSide(color: Color(0xffefefef), width: 1);
  Widget _getBottom() {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(top: buttonSide, right: buttonSide)),
                  child: TextButton(
                      child: Text('同意します。'),
                      onPressed: ischeck ? () => onTapAgree() : null))),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(border: Border(top: buttonSide)),
                  child: TextButton(
                      child: Text('同意しない。'), onPressed: () => exit(1))))
        ],
      ),
    );
  }
}
