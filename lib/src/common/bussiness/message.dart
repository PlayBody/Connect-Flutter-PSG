import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/messagemodel.dart';

import '../apiendpoint.dart';
import '../const.dart';

class ClMessage {
  Future<int> loadUnreadMessageCount(context, userId, companyId) async {
    Map<dynamic, dynamic> results = {};
    String apiUrl = apiBase + '/apimessages/getUserUnreadCount';
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': userId,
    }).then((v) => {results = v});

    return int.parse(results['count'].toString());
  }

  Future<List<MessageModel>> loadMessageList(context, userId, companyId) async {
    Map<dynamic, dynamic> results = {};
    List<MessageModel> messages = [];
    String apiUrl = apiBase + '/apimessages/loadUserMessages';
    await Webservice().loadHttp(context, apiUrl, {
      'user_id': userId,
      'company_id': companyId
    }).then((v) => {results = v});

    if (results['isLoad']) {
      for (var item in results['messages']) {
        messages.add(MessageModel.fromJson(item));
      }
    }
    return messages;
  }

  Future<bool> sendMessage(context, userId, companyId, organId, content,
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
        await Webservice().callHttpMultiPart(
            apiUploadMessageAttachFileUrl, videoPath, attachVideoFile);
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
}
