import 'package:connect/src/common/const.dart';

class OrganTimeModel {
  final String organId;
  final String weekday;
  final String fromTime;
  final String toTime;

  const OrganTimeModel({
    required this.organId,
    required this.weekday,
    required this.fromTime,
    required this.toTime,
  });

  factory OrganTimeModel.fromJson(Map<String, dynamic> json) {
    String weekDay = weekAry[int.parse(json['weekday']) - 1];
    return OrganTimeModel(
        organId: json['organ_id'],
        weekday: weekDay,
        fromTime: json['from_time'],
        toTime: json['to_time']);
  }
}
