import 'package:connect/src/http/webservice.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../apiendpoint.dart';

class ClNotification {
  Future<void> sendNotification(
    context,
    type,
    title,
    content,
    senderId,
    senderType,
    receiverIds,
    receiverType,
  ) async {
    // Map<dynamic, dynamic> results = {};
    String apiUrl = apiBase + '/apinotifications/sendNotifications';
    await Webservice().loadHttp(context, apiUrl, {
      'type': type,
      'title': title,
      'content': content,
      'sender_id': senderId,
      'sender_type': senderType,
      'receiver_ids': receiverIds,
      'receiver_type': receiverType,
    });

    // return results['isSend'];
  }

  Future<String> getBageCount(context, userId) async {
    String apiUrl = apiBase + '/apimessages/getStaffUnreadCount';

    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'receiver_id': userId,
      'receiver_type': '2',
    }).then((value) => results = value);

    return results['count'].toString();
  }

  Future<void> removeBadge(context, receiverId, notificationType) async {
    String apiUrl = apiBase + '/apinotifications/removeBadge';

    String badgeCount = '0';

    await Webservice().loadHttp(context, apiUrl, {
      'receiver_id': receiverId,
      'receiver_type': '2',
      'notification_type': notificationType,
      'badge_count': badgeCount
    });

    String badge = await this.getBageCount(context, receiverId);

    FlutterAppBadger.updateBadgeCount(int.parse(badge == 'null' ? '0' : badge));
  }
}
