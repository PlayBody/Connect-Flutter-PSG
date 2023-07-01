import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:connect/src/common/bussiness/message.dart';
import 'package:connect/src/common/bussiness/notification.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/functions/chats.dart';
import 'package:connect/src/common/functions/seletattachement.dart';
import 'package:connect/src/common/messages.dart';
import 'package:connect/src/interface/component/chats.dart';
import 'package:connect/src/interface/component/dropdown/dropdownmodel.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/connect/component/userbutton.dart';
import 'package:connect/src/model/messagemodel.dart';
import 'package:connect/src/model/organmodel.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/dialogs.dart';
import '../../../common/globals.dart' as globals;
import '../../../common/apiendpoint.dart';

import 'dialog_attach_preview.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:connect/src/http/webservice.dart';
// only IOS import 'package:gallery_saver/gallery_saver.dart';

class ConnectMessage extends StatefulWidget {
  const ConnectMessage({Key? key}) : super(key: key);

  @override
  _ConnectMessage createState() => _ConnectMessage();
}

class _ConnectMessage extends State<ConnectMessage> {
  late Future<List> loadData;
  bool isSending = false;
  bool isDownLoading = false;
  String attachType = '';
  String filePath = '';
  String fileName = '';
  String videoPath = '';
  var videoFileController;
  List<MessageModel> messages = [];
  List<TaskInfo>? taskInfos;
  ReceivePort _port = ReceivePort();

  var contentController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<OrganModel> organs = [];
  String selOrganId = '';

  @override
  void initState() {
    super.initState();
    loadData = loadMessageData();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String notificationType = message.data['type'].toString();
      if (notificationType == 'message') {
        refreshLoad();
      }
    });

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port_connect');
    _port.listen((dynamic data) {
      loadDownLoadTask();
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port_connect');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port_connect');
    send!.send([id, status, progress]);
  }

  Future<List<MessageModel>> loadMessageData() async {
    globals.isUpload = false;
    globals.progressPercent = 0;
    organs = await ClOrgan().loadOrganList(context, APPCOMANYID);

    messages =
        await ClMessage().loadMessageList(context, globals.userId, APPCOMANYID);
    selOrganId = '';
    contentController.clear();
    filePath = '';
    attachType = '';

    loadDownLoadTask();

    ClNotification().removeBadge(context, globals.userId, '1');
    return messages;
  }

  Future<void> sendMessage() async {
    if (isSending) return;
    if (contentController.text == '' && filePath == '') {
      isSending = false;
      return;
    }

    isSending = true;
    setState(() {});

    bool isSend = await sendMessageControl(
        context,
        globals.userId,
        APPCOMANYID,
        selOrganId,
        contentController.text,
        attachType,
        fileName,
        filePath,
        videoPath);

    if (isSend) {
      messages = await loadMessageData();
    } else {
      Dialogs().infoDialog(context, errServerActionFail);
    }
    isSending = false;
    setState(() {});
  }

  Future<void> refreshLoad() async {
    messages = await loadMessageData();
    setState(() {});
  }

  Future<void> selectPhoto() async {
    var _select = await SelectAttachments().selectImageWithFile();
    if (_select['file_path'] == null) return;
    attachType = '1';
    filePath = _select['file_path'];
    fileName = _select['file_name'];
    setState(() {});
  }

  Future<void> selectVideo() async {
    var _select = await SelectAttachments().selectFileMovie();
    if (_select['file_path'] == null) return;
    attachType = '2';
    filePath = _select['file_path'];
    fileName = _select['file_name'];
    videoPath = _select['video_file'];

    setState(() {});
  }

  Future<void> clearAttachment() async {
    filePath = '';
    attachType = '';
    videoPath = '';

    setState(() {});
  }

  void pushPreviewAttach(String fileType, String fileUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogAttachPreview(
              previewType: fileType,
              attachUrl: apiBase + '/assets/messages/' + fileUrl);
        });
  }

  Future<void> downloadFile(fileUrl, String fileName) async {
    Dialogs().loaderDialogNormal(context);
    await ChatsFunc().downloadAttachFile(fileUrl, fileName);
    Navigator.pop(context);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    globals.connectHeaerTitle = 'メッセージ';
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return MainForm(
      title: 'メッセージ',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              _getChatListContent(),
              SizedBox(height: 12),
              Container(height: 1, color: Colors.grey.withOpacity(0.5)),
              SizedBox(height: 8),
              _getReceiveOrganContent(),
              SizedBox(height: 8),
              ChatAttachContent(
                attachType: attachType,
                filePath: filePath,
                tapFunc: () => clearAttachment(),
              ),
              ChatInputContent(controller: contentController),
              ChatInputButtons(
                tapPhotoFunc: () => selectPhoto(),
                tapVideoFunc: () => selectVideo(),
                tapSendFunc: () => sendMessage(),
                isSending: isSending,
                isUploading: globals.isUpload,
                progressPercent: globals.progressPercent.toString(),
              ),
            ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _getReceiveOrganContent() {
    return Row(
      children: [
        SizedBox(width: 20),
        Text('店名'),
        SizedBox(width: 12),
        Flexible(
            flex: 1,
            child: DropDownModelSelect(
                contentPadding: EdgeInsets.fromLTRB(8, 6, 0, 6),
                value: selOrganId,
                tapFunc: (v) {
                  selOrganId = v.toString();
                  setState(() {});
                },
                items: [
                  DropdownMenuItem(value: '', child: Text('指定なし')),
                  ...organs.map((e) => DropdownMenuItem(
                      value: e.organId, child: Text(e.organName)))
                ])),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _getChatListContent() {
    return Expanded(
      child: ListView(
        controller: _scrollController,
        reverse: true,
        shrinkWrap: true,
        children: [
          ...messages.map(
            (e) => Container(
              padding: e.type == '1'
                  ? EdgeInsets.only(left: 120, right: 20, top: 20)
                  : EdgeInsets.only(left: 20, right: 120, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (e.staffName != '')
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 4),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.red,
                            ),
                            child: Row(children: [
                              Text('from'),
                              SizedBox(width: 4),
                              Text(e.staffName + 'さん',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ]))
                      ],
                    ),
                  if (e.organName != '')
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 4),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color(0xff00856a),
                            ),
                            child: Row(children: [
                              Icon(Icons.send, size: 18, color: Colors.white),
                              SizedBox(width: 4),
                              Text(e.organName,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ]))
                      ],
                    ),
                  if (e.fileType != '') _getChatAttachContent(e),
                  if (e.content != '')
                    ChatListContent(
                        content: e.content, type: e.type, readflag: e.readflag),
                  ChatListDate(date: e.createDate),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getChatAttachContent(attach) {
    TaskInfo? _task = findAttachTask(attach);
    DownloadTaskStatus? _status =
        (_task == null) ? DownloadTaskStatus.undefined : _task.status;
    if (_status == null) _status = DownloadTaskStatus.undefined;
    return Container(
        // height: 130,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
              width: 170,
              height: 120,
              child: Image.network(
                  apiBase + '/assets/messages/' + attach.fileUrl)),
          onTap: () => attach.fileType == '2'
              ? pushPreviewAttach(attach.fileType,
                  attach.videoUrl == null ? '' : attach.videoUrl!)
              : pushPreviewAttach(attach.fileType, attach.fileUrl),
        ),
        Container(
            child: Row(
          children: [
            TextButton(
                onPressed: () => attach.fileType == '2'
                    ? pushPreviewAttach(attach.fileType,
                        attach.videoUrl == null ? '' : attach.videoUrl!)
                    : pushPreviewAttach(attach.fileType, attach.fileUrl),
                child: Text(attach.fileName.length > 18
                    ? (attach.fileName.substring(0, 14) +
                        '...' +
                        attach.fileName.substring(attach.fileName.length - 4))
                    : attach.fileName)),
            Row(
              children: [
                if (_status == DownloadTaskStatus.running)
                  Container(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator()),
                SizedBox(width: 6),
                if (_status == DownloadTaskStatus.undefined)
                  UserBtnCircleIcon(
                      tapFunc: () {
                        requestDownload(
                            attach.fileType == '2'
                                ? attach.videoUrl!
                                : attach.fileUrl!,
                            attach.fileName);
                      },
                      icon: Icons.download),
                if (_status == DownloadTaskStatus.running)
                  UserBtnCircleIcon(
                      tapFunc: () => _pauseDownload(_task!), icon: Icons.pause),
                if (_status == DownloadTaskStatus.paused)
                  UserBtnCircleIcon(
                      tapFunc: () => _resumeDownload(_task!),
                      icon: Icons.restore),
                if (_status == DownloadTaskStatus.failed)
                  UserBtnCircleIcon(
                      tapFunc: () => _retryDownload(_task!),
                      icon: Icons.refresh),
                if (_status != DownloadTaskStatus.undefined)
                  UserBtnCircleIcon(
                      tapFunc: () => _cancelDownload(_task!),
                      icon: Icons.close),
              ],
            ),
          ],
        )),
      ],
    ));
  }

  void requestDownload(String link, String fileName) async {
    String savePath = '';
    String uriLink = apiBase + '/assets/messages/' + link;
    if (Platform.isAndroid) {
      savePath = (await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS));
    } else {
      savePath = (await getApplicationDocumentsDirectory()).absolute.path;
    }

    final savedDir = Directory(savePath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    String filePath = savePath + '/' + fileName;
    String saveFileName = fileName;
    var ext = path.extension(filePath);

    int i = 0;
    while (File(filePath).existsSync()) {
      i++;
      saveFileName = fileName.substring(0, fileName.length - ext.length) +
          '[' +
          i.toString() +
          ']' +
          fileName.substring(fileName.length - ext.length);
      filePath = savePath + '/' + saveFileName;
    }

    await FlutterDownloader.enqueue(
      url: uriLink,
      savedDir: savedDir.path,
      fileName: saveFileName,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    loadDownLoadTask();
  }

  Future<Null> loadDownLoadTask() async {
    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) return;
    taskInfos = [];
    for (var item in tasks) {
      if (item.status == DownloadTaskStatus.complete) {
        String tempPath = item.savedDir + '/' + item.filename!;
        File(tempPath).setLastModified(DateTime.now());
        /* only IOS
        if (Platform.isIOS) {
          // String tempPath = item.savedDir + '/' + item.filename!;
          var ext = path.extension(tempPath);
          if (['.jpg', '.png', '.gif', '.jpeg', '.bmp']
              .contains(ext.toLowerCase())) {
            await GallerySaver.saveImage(tempPath);
          }
          if (['.mov', '.mp4', '.avi'].contains(ext.toLowerCase())) {
            await GallerySaver.saveVideo(tempPath);
          }
        }*/
        Fluttertoast.showToast(msg: 'ダウンロードされました。- ${item.filename}');
      }

      if (item.status == DownloadTaskStatus.complete ||
          item.status == DownloadTaskStatus.canceled) {
        await FlutterDownloader.remove(taskId: item.taskId);
      } else {
        var task = TaskInfo(name: item.taskId, link: item.url);
        task.status = item.status;
        task.taskId = item.taskId;
        taskInfos!.add(task);
      }
    }
    setState(() {});
  }

  TaskInfo? findAttachTask(attach) {
    if (taskInfos == null) return null;
    String url = attach.fileType == '2'
        ? (attach.videoUrl == null ? '' : attach.videoUrl!)
        : attach.fileUrl;
    for (var item in taskInfos!) {
      if (item.link == apiBase + '/assets/messages/' + url) {
        return item;
      }
    }
    return null;
  }

  void _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  void _resumeDownload(TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _retryDownload(TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _cancelDownload(TaskInfo task) async {
    await FlutterDownloader.remove(taskId: task.taskId!);
    loadDownLoadTask();
  }

  Future<bool> sendMessageControl(context, userId, companyId, organId, content,
      attachType, fileName, filePath, videoPath) async {
    String attachFileUrl = '';
    String attachVideoFile = '';
    if (attachType != '') {
      attachFileUrl = 'msg_attach_file_' +
          DateTime.now()
              .toString()
              .replaceAll(':', '')
              .replaceAll('-', '')
              .replaceAll('.', '')
              .replaceAll(' ', '') +
          '.jpg';
      await Webservice().callHttpMultiPart(
          apiUploadMessageAttachFileUrl, filePath, attachFileUrl);

      if (attachType == '2') {
        attachVideoFile = 'msg_video_file_' +
            DateTime.now()
                .toString()
                .replaceAll(':', '')
                .replaceAll('-', '')
                .replaceAll('.', '')
                .replaceAll(' ', '') +
            '.mp4';
        await callHttpMultiPartWithProgressOwn(context, 'upload',
            apiUploadMessageAttachFileUrl, File(videoPath), attachVideoFile);
      }
    }
    String apiURL = apiBase + '/apimessages/sendUserMessage';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiURL, {
      'company_id': APPCOMANYID,
      'user_id': userId,
      'organ_id': organId,
      'content': content,
      'file_type': attachType,
      'file_name': fileName,
      'file_url': attachFileUrl,
      'video_url': attachVideoFile,
    }).then((value) => results = value);

    return results['isSend'];
  }

  Future<String> callHttpMultiPartWithProgressOwn(
      context, String type, String url, File assetFile, saveName) async {
    // var stream = http.ByteStream(DelegatingStream.typed(assetFile.openRead()));

    final stream = assetFile.openRead();
    var length = await assetFile.length();
    int byteCount = 0;

    Stream<List<int>> stream2 = stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;
          globals.isUpload = true;
          globals.progressPercent = (byteCount / length * 100).toInt();
          setState(() {});
          sink.add(data);
        },
        handleError: (error, stack, sink) {},
        handleDone: (sink) {
          globals.isUpload = false;
          globals.progressPercent = 0;
          setState(() {});
          sink.close();
        },
      ),
    );
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files
        .add(http.MultipartFile(type, stream2, length, filename: saveName));

    var response = await request.send();

    return response.statusCode.toString();
  }
}

class TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  TaskInfo({this.name, this.link});
}
