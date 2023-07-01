import 'dart:io';

import 'package:connect/src/interface/component/text/input_texts.dart';
import 'package:connect/src/interface/connect/component/userbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatAttachContent extends StatelessWidget {
  final String attachType;
  final String filePath;
  final tapFunc;
  const ChatAttachContent(
      {required this.attachType,
      required this.filePath,
      required this.tapFunc,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Container()),
          SizedBox(width: 25),
          if (attachType != '')
            Container(
                width: 170, height: 100, child: Image.file(File(filePath))),
          if (attachType != '')
            Container(
                width: 25,
                alignment: Alignment.bottomLeft,
                child: AdminBtnIconRemove(tapFunc: tapFunc)),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

class ChatInputContent extends StatelessWidget {
  final controller;
  const ChatInputContent({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextInputNormal(
        controller: controller,
        hintText: 'メッセージを入力',
        multiline: 2,
      ),
    );
  }
}

class ChatInputButtons extends StatelessWidget {
  final tapPhotoFunc;
  final tapVideoFunc;
  final tapSendFunc;
  final bool isSending;
  final bool isUploading;
  final String progressPercent;
  const ChatInputButtons(
      {required this.tapPhotoFunc,
      required this.tapVideoFunc,
      required this.tapSendFunc,
      required this.isSending,
      required this.isUploading,
      required this.progressPercent,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Container(
            child: UserBtnIconDefualt(
                icon: Icons.add_photo_alternate, tapFunc: tapPhotoFunc),
          ),
          Container(
            child: UserBtnIconDefualt(
                icon: Icons.video_camera_back, tapFunc: tapVideoFunc),
          ),
          Expanded(child: Container()),
          if (isUploading) Text('動画アップロード中... $progressPercent%'),
          if (!isUploading)
            ElevatedButton(
              onPressed: tapSendFunc,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    height: 16,
                    width: 24,
                    child: isSending
                        ? CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : Icon(Icons.send, size: 16),
                  ),
                  Text('送信')
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ChatListContent extends StatelessWidget {
  final String content;
  final String type;
  final bool readflag;
  const ChatListContent(
      {required this.content,
      required this.type,
      required this.readflag,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Linkify(
        text: content,
        options: LinkifyOptions(humanize: false),
        onOpen: (link) async {
          launchUrl(Uri.parse(link.url));
          // print(link.url);
          // bool isRun = await canLaunch(link.url);
          // print(isRun);
          // if (isRun) launch(link.url);
        },
      ),
      decoration: BoxDecoration(
        color: type == '1'
            ? Colors.blue[100]
            : readflag
                ? Colors.grey[300]
                : Colors.red[100],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class ChatListDate extends StatelessWidget {
  final String date;
  const ChatListDate({required this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      alignment: Alignment.centerRight,
      child: Text(date),
    );
  }
}
