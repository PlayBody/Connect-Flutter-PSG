class FireBaseMessageModel {
  final String type;
  final String content;
  final String time;
  final String unread;

  FireBaseMessageModel(this.type, this.content, this.time, this.unread);

  FireBaseMessageModel.fromJson(Map<dynamic, dynamic> json)
      : type = json['type'] as String,
        content = json['text'] as String,
        time = json['time'] as String,
        unread = json['unread'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'type': type,
        'text': content,
        'time': time,
        'unread': unread,
      };
}
