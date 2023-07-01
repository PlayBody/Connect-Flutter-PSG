class GroupModel {
  final String groupId;
  final String groupName;
  final String? userCnt;

  const GroupModel(
      {required this.groupId, required this.groupName, this.userCnt});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['group_id'],
      groupName: json['group_name'],
      userCnt: json['user_cnt'] == null ? '0' : json['user_cnt'],
    );
  }
}
