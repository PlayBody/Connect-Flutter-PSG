class RankModel {
  final String rankId;
  final String companyId;
  final String maxStamp;
  final String rankName;
  final String level;

  RankModel({
    required this.rankId,
    required this.companyId,
    required this.maxStamp,
    required this.rankName,
    required this.level,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) {
    return RankModel(
        rankId: json['rank_id'].toString(),
        companyId: json['company_id'].toString(),
        maxStamp: json['max_stamp'].toString(),
        rankName: json['rank_name'].toString(),
        level: json['level'] == null ? '' : json['level'].toString());
  }
}
