class MessageUserModel {
  final String userName;
  final String userId;
  final String content;
  final String unreadCnt;

  const MessageUserModel(
      {required this.content,
      required this.userId,
      required this.userName,
      required this.unreadCnt});

  factory MessageUserModel.fromJson(Map<String, dynamic> json) {
    return MessageUserModel(
      content: json['content'],
      userId: json['user_id'],
      userName: json['user_nick'] == null
          ? (json['user_first_name'] == null
              ? ''
              : json['user_first_name'] + '　' + json['user_last_name'] == null
                  ? ''
                  : json['user_last_name'])
          : json['user_nick'],
      unreadCnt: json['unread_message_count'] == null
          ? '0'
          : json['unread_message_count'],
    );
  }
}
