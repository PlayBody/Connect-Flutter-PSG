import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/question/connect_question_add.dart';
import 'package:connect/src/model/favoritequestionmodel.dart';
import 'package:flutter/material.dart';

class ConnectQuestions extends StatefulWidget {
  const ConnectQuestions({Key? key}) : super(key: key);

  @override
  _ConnectQuestions createState() => _ConnectQuestions();
}

class _ConnectQuestions extends State<ConnectQuestions> {
  late Future<List> loadData;

  List<FavoriteQuestionModel> questions = [];
  String openQuestion = '';

  @override
  void initState() {
    super.initState();
    loadData = loadMenuData();
  }

  Future<List> loadMenuData() async {
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadFavortieQuestionUrl,
        {'company_id': APPCOMANYID}).then((value) => results = value);
    questions = [];
    if (results['isLoad']) {
      for (var item in results['questions']) {
        questions.add(FavoriteQuestionModel.fromJson(item));
      }
    }
    setState(() {});
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'お問い合わせ',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _getFavoriteTitle(),
                          ...questions.map((e) => _getFavoriteQuestionItem(e)),
                          _getQuestionTitle(),
                          _getQuestionContent(),
                        ],
                      ),
                    ),
                  ),
                  _getQuestionButton()
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

  Widget _getFavoriteTitle() {
    return Container(
      child: Text(
        'よくあるご質問',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      color: Color(0xff443F2F),
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getQuestionTitle() {
    return Container(
      child: Text(
        'お問い合わせ',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      color: Color(0xff443F2F),
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getQuestionContent() {
    return Container(
      child: Text('お問い合わせいただく前に、ヘルプをご確認ください。それでも解決しない場合は、以下のお問い合わせ先よりご連絡ください。'),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }

  Widget _getQuestionButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250),
        child: ElevatedButton(
          child: Text('お問い合わせ'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ConnectQuestionAdd();
            }));
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(8), textStyle: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _getFavoriteQuestionItem(item) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffFAF8F5),
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              if (openQuestion == item.id) {
                openQuestion = '';
              } else {
                openQuestion = item.id;
              }
              setState(() {});
            },
            visualDensity: VisualDensity(horizontal: 0, vertical: -2),
            trailing: Icon(openQuestion == item.id
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
            title: Text('Q. ' + 'dddd', style: txtQuestionStyle),
          ),
          if (openQuestion == item.id)
            Container(
              child: Text(item.answer, style: txtAnswerStyle),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.white, border: Border.all(color: Colors.grey)),
            )
        ],
      ),
    );
  }
}
