class FireBaseMessageListModel {
  final String type;
  final String content;
  final String userId;
  final String userName;

  FireBaseMessageListModel(this.type, this.content, this.userId, this.userName);

  FireBaseMessageListModel.fromJson(Map<dynamic, dynamic> json)
      : type = json['type'] as String,
        content = json['text'] as String,
        userId = json['user_id'] as String,
        userName = json['user_name'] as String;

  // Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
  //       'type': type,
  //       'content': content,
  //       'time': time,
  //       'unread': unread,
  //     };
}
