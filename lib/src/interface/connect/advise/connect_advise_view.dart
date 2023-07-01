import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

class ConnectAdviseView extends StatefulWidget {
  final String adviseId;

  const ConnectAdviseView({required this.adviseId, Key? key}) : super(key: key);

  @override
  _ConnectAdviseView createState() => _ConnectAdviseView();
}

class _ConnectAdviseView extends State<ConnectAdviseView> {
  late Future<List> loadData;
  String teacherName = '';
  String question = '';
  String answer = '';
  String uDate = '';

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    Map<dynamic, dynamic> results = {};

    await Webservice().loadHttp(context, apiLoadAdviseInfoUrl,
        {'advise_id': widget.adviseId}).then((value) => results = value);

    if (results['isLoad']) {
      if (results['advise']['movie_file'] != null) {
        http.Response response = await http
            .get(Uri.parse(adviseMovieBase + results['advise']['movie_file']));
        if (response.statusCode == 200) {
          _controller = VideoPlayerController.network(
              adviseMovieBase + results['advise']['movie_file']);
          await _controller!.initialize();
        }
      }
      uDate = results['advise']['update_date'];
      teacherName = results['advise']['teacher_name'];
      question = results['advise']['question'];
      answer = results['advise']['answer'] == null
          ? ''
          : results['advise']['answer'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'アドバイス履歴',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _getDateAndTeacher(),
                            SizedBox(height: 8),
                            _getMovieView(),
                            SizedBox(height: 8),
                            _getQuestionTitle(),
                            SizedBox(height: 8),
                            _getQuestion(),
                            SizedBox(height: 24),
                            _getAnswerTitle(),
                            SizedBox(height: 8),
                            _getAnswer()
                          ],
                        ),
                      ),
                    ),
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

  Widget _getDateAndTeacher() {
    return Row(children: [
      Container(
        child: Text(
          DateFormat('yyyy/MM/dd').format(DateTime.parse(uDate)),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 24),
        child: Text(
          teacherName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }

  Widget _getMovieView() {
    if (_controller == null) return Container();
    return Container(
        child: Stack(children: [
      _controller != null
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          : Container(),
      if (_controller != null)
        Positioned.fill(
            child: Center(
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
            child: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ))
    ]));
  }

  Widget _getQuestionTitle() {
    return Container(
      child: Text(
        '質問内容',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getQuestion() {
    return Container(
      child: Text(question),
    );
  }

  Widget _getAnswerTitle() {
    return Container(
      child: Text(
        'アドバイス',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getAnswer() {
    return Container(
      child: Text(answer),
    );
  }
}
