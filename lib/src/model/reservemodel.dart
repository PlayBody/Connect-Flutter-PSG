import 'menumodel.dart';

class ReserveModel {
  final String reserveId;
  final String organId;
  final String organName;
  final String staffName;
  final String userId;
  final String reserveTime;
  final String reserveExitTime;
  final String reserveStatus;
  final String updateDate;
  final String sumAmount;
  final String couponAmount;
  final String payMethod;
  final String updateUserName;
  final String createTime;
  final List<MenuModel> menus;

  const ReserveModel({
    required this.reserveId,
    required this.organId,
    required this.organName,
    required this.staffName,
    required this.userId,
    required this.reserveTime,
    required this.reserveExitTime,
    required this.reserveStatus,
    required this.updateDate,
    required this.sumAmount,
    required this.couponAmount,
    required this.payMethod,
    required this.createTime,
    required this.updateUserName,
    required this.menus,
  });

  factory ReserveModel.fromJson(Map<String, dynamic> json) {
    var sum = '0';
    List<MenuModel> menuList = [];
    if (json['menus'] != null) {
      for (var item in json['menus']) {
        sum = (int.parse(sum) +
                int.parse(
                    item['menu_price'] == null ? '0' : item['menu_price']))
            .toString();
        menuList.add(MenuModel.fromJson(item));
      }
    }

    return ReserveModel(
      reserveId: json['reserve_id'],
      organId: json['organ_id'].toString(),
      organName: json['organ_name'] == null ? '' : json['organ_name'],
      staffName: json['staff_name'] == null ? '' : json['staff_name'],
      userId: json['user_id'].toString(),
      reserveTime: json['reserve_time'],
      reserveExitTime: json['reserve_exit_time'],
      reserveStatus: (json['reserve_status'] == null)
          ? '1'
          : json['reserve_status'].toString(),
      updateDate: json['update_date'],
      sumAmount: json['amount'] == null ? '0' : json['amount'].toString(),
      couponAmount: json['coupon_use_amount'] == null
          ? '0'
          : json['coupon_use_amount'].toString(),
      payMethod: json['pay_method'] == null ? '2' : json['pay_method'],
      menus: menuList,
      createTime: json['create_date'].toString(),
      updateUserName: json['update_user_name'] == null
          ? ''
          : json['update_user_name'].toString(),
    );
  }
}
