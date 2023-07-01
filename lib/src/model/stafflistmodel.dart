class StaffListModel {
  final String? staffId;
  final String? staffFirstName;
  final String? staffLastName;
  final String staffNick;
  final String staffLabel;
  final String staffSex;
  final String comment;
  final String? auth;

  const StaffListModel(
      {this.staffId,
      this.staffFirstName,
      this.staffLastName,
      required this.staffSex,
      required this.staffNick,
      required this.staffLabel,
      required this.comment,
      this.auth});

  factory StaffListModel.fromJson(Map<String, dynamic> json) {
    return StaffListModel(
      staffId: json['staff_id'],
      staffFirstName: json['staff_first_name'],
      staffLastName: json['staff_last_name'],
      staffSex: json['staff_sex'] == null ? '1' : json['staff_sex'].toString(),
      staffNick: json['staff_nick'] == null ? '' : json['staff_nick'],
      staffLabel: json['sort_name'] == null ? '' : json['sort_name'],
      comment: json['staff_comment'] == null ? '' : json['staff_comment'],
      auth: json['auth'],
    );
  }
}
