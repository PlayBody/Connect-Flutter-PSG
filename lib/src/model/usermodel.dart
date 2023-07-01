import 'package:intl/intl.dart';

class UserModel {
  final String userId;
  final String userNo;
  final String qrCode;
  final String grade;
  final String userFirstName;
  final String userLastName;
  final String userNick;
  final String userEmail;
  final String userBirth;
  final String userTel;
  final String userSex;
  final String userTicket;
  final String? deviceToken;
  final String? groupId;
  final String password;
  final bool isPushMesseage;
  final bool isPushReserveRequest;
  final bool isPushReserveApply;

  const UserModel({
    required this.userId,
    required this.userNo,
    required this.qrCode,
    required this.grade,
    required this.userFirstName,
    required this.userLastName,
    required this.userNick,
    required this.userEmail,
    required this.userTel,
    required this.userBirth,
    required this.userSex,
    required this.userTicket,
    required this.password,
    required this.isPushMesseage,
    required this.isPushReserveRequest,
    required this.isPushReserveApply,
    this.groupId,
    this.deviceToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_no'] == null ? '' : json['user_id'].toString(),
      userNo: json['user_no'] == null ? '' : json['user_no'],
      qrCode: json['user_qrcode'] == null ? '1' : json['user_qrcode'],
      grade: json['user_grade'] == null ? '' : json['user_grade'],
      userFirstName:
          json['user_first_name'] == null ? '' : json['user_first_name'],
      userLastName:
          json['user_last_name'] == null ? '' : json['user_last_name'],
      userNick: json['user_nick'] == null ? '' : json['user_nick'],
      userEmail: json['user_email'] == null ? '' : json['user_email'],
      userTel: json['user_tel'] == null ? '' : json['user_tel'],
      userBirth: json['user_birthday'] == null
          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
          : json['user_birthday'],
      userSex: json['user_sex'] == null ? '1' : json['user_sex'],
      userTicket: json['user_ticket'] == null ? '' : json['user_ticket'],
      password: json['user_password'] == null ? '' : json['user_password'],
      groupId: json['group_id'],
      deviceToken: json['user_device_token'],
      isPushMesseage: (json['is_message_push'] == null ||
          json['is_message_push'].toString() == '1'),
      isPushReserveRequest: (json['is_reserve_request_push'] == null ||
          json['is_reserve_request_push'].toString() == '1'),
      isPushReserveApply: (json['is_reserve_apply_push'] == null ||
          json['is_reserve_apply_push'].toString() == '1'),
    );
  }
}
