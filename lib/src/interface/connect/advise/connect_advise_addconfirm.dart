import 'dart:io';

import 'package:connect/src/common/apiendpoint.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../common/globals.dart' as globals;

class ConnectAdviseAddConfirm extends StatefulWidget {
  final String teacherId;
  final File videoFile;
  final String adviseContent;

  const ConnectAdviseAddConfirm(
      {required this.teacherId,
      required this.videoFile,
      required this.adviseContent,
      Key? key})
      : super(key: key);

  @override
  _ConnectAdviseAddConfirm createState() => _ConnectAdviseAddConfirm();
}

class _ConnectAdviseAddConfirm extends State<ConnectAdviseAddConfirm> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    loadInitData();
  }

  Future<void> loadInitData() async {
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  Future<void> saveAdvise() async {
    if (widget.teacherId == '') {
      Dialogs().infoDialog(context, warningFormInputErr);
      return;
    }

    //base64Image = base64Encode(_photoFile.readAsBytesSync());
    // fileName = _photoFile.path.split("/").last;
    String videoFileName = 'advise-video' +
        DateTime.now()
            .toString()
            .replaceAll(':', '')
            .replaceAll('-', '')
            .replaceAll('.', '')
            .replaceAll(' ', '') +
        '.mp4';

    await Webservice().callHttpMultiPart(
        apiUploadAdviseVideo, widget.videoFile.path, videoFileName);

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiSaveAdviseInfoUrl, {
      'user_id': globals.userId,
      'teacher_id': widget.teacherId,
      'question': widget.adviseContent,
      'movie': videoFileName
    }).then((value) => results = value);

    if (results['isSave']) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Dialogs().infoDialog(context, errServerActionFail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
        title: '確認画面',
        render: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _getMovieView(),
                      SizedBox(height: 8),
                      _getContentTitle(),
                      SizedBox(height: 8),
                      _getInputContent(),
                      // _getTitle(),
                      // SizedBox(height: 8),
                      // _getSelectTeacher(),
                      // SizedBox(height: 12),
                      // _getSelectMovie(),
                      // SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              _getAddButton(),
            ],
          ),
        ));
  }

  // Widget _getTitle() {
  //   return Container(
  //     child: Text(
  //       '質問する先生',
  //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

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
      child: Text(widget.adviseContent),
    );
  }

  Widget _getAddButton() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250),
        child: ElevatedButton(
          child: Text('送信する'),
          onPressed: () => saveAdvise(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(8), textStyle: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
