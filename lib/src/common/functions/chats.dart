import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../apiendpoint.dart';

class ChatsFunc {
  Future<void> downloadAttachFile(fileUrl, String fileName) async {
    try {
      Dio dio = Dio();

      String savePath = (await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS));
      String filePath = savePath + '/' + fileName;

      int i = 0;
      while (File(filePath).existsSync()) {
        i++;
        filePath = savePath +
            '/' +
            fileName.substring(0, fileName.length - 4) +
            '[' +
            i.toString() +
            ']' +
            fileName.substring(fileName.length - 4);
      }
      await dio.download(apiBase + '/assets/messages/' + fileUrl, filePath,
          onReceiveProgress: (rec, total) {
        // setState(() {
        //   isDownLoading = true;
        //   // download = (rec / total) * 100;
        //   downloadingStr = "Downloading : $rec";
        // });
      });

      Fluttertoast.showToast(msg: 'ダウンロードされました。$filePath');
    } catch (e) {
      print(e.toString());
    }
  }
}
