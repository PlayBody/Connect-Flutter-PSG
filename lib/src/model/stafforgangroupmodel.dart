import 'stafflistmodel.dart';

class StaffOrganGroupModel {
  final String organId;
  final String organName;
  final List staffs;

  const StaffOrganGroupModel(
      {required this.organName, required this.organId, required this.staffs});

  factory StaffOrganGroupModel.fromJson(Map<String, dynamic> json) {
    List<StaffListModel> staffList = [];
    for (var item in json['staffs']) {
      staffList.add(StaffListModel.fromJson(item));
    }

    return StaffOrganGroupModel(
      organId: json['organ_id'],
      organName: json['organ_name'],
      staffs: staffList,
    );
  }
}
