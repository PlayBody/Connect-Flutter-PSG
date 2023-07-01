import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/advise/connect_advise_view.dart';
import 'package:connect/src/model/advisemodel.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../common/globals.dart' as globals;
import 'connect_advise_add.dart';
import 'package:http/http.dart' as http;

class ConnetAdvises extends StatefulWidget {
  const ConnetAdvises({Key? key}) : super(key: key);

  @override
  _ConnetAdvises createState() => _ConnetAdvises();
}

class _ConnetAdvises extends State<ConnetAdvises> {
  late Future<List> loadData;

  List<AdviseModel> advises = [];
  // VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    Map<dynamic, dynamic> resultsAdvise = {};
    await Webservice().loadHttp(context, apiLoadAdviseListUrl,
        {'user_id': globals.userId}).then((value) => resultsAdvise = value);

    advises = [];
    if (resultsAdvise['isLoad']) {
      for (var item in resultsAdvise['advise_list']) {
        if (item['movie_file'] != null) {
          http.Response response =
              await http.get(Uri.parse(adviseMovieBase + item['movie_file']));
          if (response.statusCode == 200) {
            var _controller = VideoPlayerController.network(
                adviseMovieBase + item['movie_file']);
            await _controller.initialize();

            item['controller'] = _controller;
          }
        }
        advises.add(AdviseModel.fromJson(item));
      }
    }

    setState(() {});
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'アドバイス質問一覧',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getAdviseList(),
                  _getAddButton(),
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

  Widget _getAdviseList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text('アドバイス待ち一覧')),
            ...advises.map(
              (e) => Container(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _getAdviseItem(e)),
            )
          ],
        ),
      ),
    );
  }

  Widget _getAdviseItem(AdviseModel item) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ConnectAdviseView(adviseId: item.adviseId);
        }));
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
          primary: Colors.white,
          onPrimary: Colors.black,
          side: BorderSide(
            width: 1,
            color: Color.fromARGB(255, 200, 200, 200),
          ),
          elevation: 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Container(
                  width: 80,
                  child: Text(
                    item.updateDate,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Container(
                  width: 110,
                  child: item.teacherName == null
                      ? Text('')
                      : Text(
                          item.teacherName!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 20, top: 5),
                  width: 170,
                  child: _getMovieView(item.videoController, item.adviseId),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '質問内容',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(child: Text(item.question)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMovieView(_controller, adviseId) {
    if (_controller == null) return Container();

    return Container(
        child: Stack(children: [
      _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          : Container(),
      if (_controller != null)
        Positioned.fill(
            child: Center(
          child: FloatingActionButton(
            heroTag: "btn" + adviseId,
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ))
    ]));
  }

  Widget _getAddButton() {
    return Container(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250),
        child: ElevatedButton(
          child: Text('アドバイスをもらう'),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ConnectAdviseAdd();
            }));
            Dialogs().loaderDialogNormal(context);
            loadInitData();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(8), textStyle: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
