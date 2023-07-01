class OrganSpecialTimeModel {
  final String organId;
  final DateTime fromTime;
  final DateTime toTime;

  const OrganSpecialTimeModel({
    required this.organId,
    required this.fromTime,
    required this.toTime,
  });

  factory OrganSpecialTimeModel.fromJson(Map<String, dynamic> json) {
    return OrganSpecialTimeModel(
        organId: json['organ_id'],
        fromTime: DateTime.parse(json['from_time']),
        toTime: DateTime.parse(json['to_time']));
  }
}
