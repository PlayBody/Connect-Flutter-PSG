import 'package:intl/intl.dart';

class StampModel {
  final String stampId;
  final String userId;
  final String organId;
  final String staffId;
  final String useflag;
  final String createDate;

  const StampModel({
    required this.stampId,
    required this.userId,
    required this.organId,
    required this.staffId,
    required this.useflag,
    required this.createDate,
  });

  factory StampModel.fromJson(Map<String, dynamic> json) {
    return StampModel(
      stampId: json['stamp_id'],
      userId: json['user_id'],
      organId: json['organ_id'],
      staffId: json['staff_id'] == null ? '' : json['staff_id'],
      useflag: json['use_flag'] == null ? '1' : json['use_flag'],
      createDate: DateFormat('MM/dd').format(DateTime.parse(json['date'])),
    );
  }
}
