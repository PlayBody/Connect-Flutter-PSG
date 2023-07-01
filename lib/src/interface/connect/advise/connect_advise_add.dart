import 'dart:io';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/stafflistmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'connect_advise_addconfirm.dart';

class ConnectAdviseAdd extends StatefulWidget {
  const ConnectAdviseAdd({Key? key}) : super(key: key);

  @override
  _ConnectAdviseAdd createState() => _ConnectAdviseAdd();
}

class _ConnectAdviseAdd extends State<ConnectAdviseAdd> {
  late Future<List> loadData;

  List<StaffListModel> teachers = [];
  VideoPlayerController? _controller;

  String? teacherId;

  var contentController = TextEditingController();
  File? _videoFile;

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    Map<dynamic, dynamic> resultsTeacher = {};
    await Webservice().loadHttp(context, apiLoadCompanyStaffListUrl,
        {'company_id': APPCOMANYID}).then((value) => resultsTeacher = value);

    teachers = [];
    if (resultsTeacher['isLoad']) {
      for (var item in resultsTeacher['data']) {
        teachers.add(StaffListModel.fromJson(item));
      }
    }

    // await Webservice().loadHttp(context, apiLoadTeacherListUrl, {
    //   'company_id': globals.companyId
    // }).then((value) => resultsTeacher = value);

    // teachers = [];
    // if (resultsTeacher['isLoad']) {
    //   for (var item in resultsTeacher['teachers']) {
    //     teachers.add(TeacherModel.fromJson(item));
    //   }
    // }

    setState(() {});
    return [];
  }

  void pushAdviseConfirm() {
    if (teacherId == null || contentController.text == '') {
      Dialogs().infoDialog(context, warningFormInputErr);
      return;
    }

    if (_videoFile == null) {
      Dialogs().infoDialog(context, warningFormInputErr);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ConnectAdviseAddConfirm(
        teacherId: teacherId!,
        videoFile: _videoFile!,
        adviseContent: contentController.text,
      );
    }));
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
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _getTitle(),
                            SizedBox(height: 8),
                            _getSelectTeacher(),
                            SizedBox(height: 12),
                            _getSelectMovie(),
                            _getMovieView(),
                            SizedBox(height: 12),
                            _getContentTitle(),
                            SizedBox(height: 8),
                            _getInputContent(),
                          ],
                        ),
                      ),
                    ),
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
        ));
  }

  Widget _getTitle() {
    return Container(
      child: Text(
        '質問する先生',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getSelectTeacher() {
    return Container(
      child: DropdownButtonFormField(
        items: [
          ...teachers.map(
            (e) => DropdownMenuItem(
              child: e.staffNick == ''
                  ? Text(e.staffNick)
                  : (Text((e.staffFirstName == null ? '' : e.staffFirstName!) +
                      ' ' +
                      (e.staffFirstName == null ? '' : e.staffLastName!))),
              value: e.staffId,
            ),
          )
        ],
        onChanged: (v) {
          teacherId = v.toString();
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _getSelectMovie() {
    final ImagePicker _picker = ImagePicker();
    return Container(
      child: ElevatedButton(
        child: Text(('動画アップロード')),
        onPressed: () async {
          final XFile? video =
              await _picker.pickVideo(source: ImageSource.gallery);

          final path = video!.path;
          _videoFile = File(path);
          if (_videoFile != null) {
            _controller = VideoPlayerController.file(_videoFile!)
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {});
              });
          }
          // setState(() {
          //   _videoFile = File(video!.path);
          // });
          // video
        },
      ),
    );
  }

  Widget _getMovieView() {
    if (_controller == null) return Container();
    return Container(
        child: Stack(children: [
      _controller!.value.isInitialized
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

  Widget _getContentTitle() {
    return Container(
      child: Text(
        '質問内容',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getInputContent() {
    return Container(
      child: TextFormField(
        controller: contentController,
        maxLines: 8,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _getAddButton() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250),
        child: ElevatedButton(
          child: Text('確認画面へ'),
          onPressed: () => pushAdviseConfirm(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(8), textStyle: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
