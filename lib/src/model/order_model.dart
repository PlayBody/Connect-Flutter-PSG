import 'order_menu_model.dart';

class OrderModel {
  final String orderId;
  final String organName;
  final String organId;
  final String userId;
  final String tableTitle;
  final String staffName;
  final String staffId;
  final String staffType;
  final String userName;
  final String userInputName;
  final String seatno;
  final int amount;
  final String status;
  final String fromTime;
  final String toTime;
  final String payMethod;
  final String couponAmount;
  final int flowTime;
  final String createTime;
  final List<OrderMenuModel> menus;

  const OrderModel({
    required this.orderId,
    required this.userId,
    required this.organName,
    required this.organId,
    required this.tableTitle,
    required this.staffName,
    required this.staffId,
    required this.staffType,
    required this.userName,
    required this.userInputName,
    required this.status,
    required this.seatno,
    required this.fromTime,
    required this.toTime,
    required this.amount,
    required this.payMethod,
    required this.couponAmount,
    required this.flowTime,
    required this.menus,
    required this.createTime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderMenuModel> menus = [];
    if (json['menus'] != null)
      for (var item in json['menus']) menus.add(OrderMenuModel.fromJson(item));
    return OrderModel(
        orderId: json['id'].toString(),
        userId: json['user_id'] == null ? '0' : json['user_id'].toString(),
        tableTitle: json['table_name'] == null ? '' : json['table_name'],
        organName: json['organ_name'] == null ? '' : json['organ_name'],
        organId: json['organ_id'] == null ? '' : json['organ_id'],
        staffName: json['staff_name'] == null ? '' : json['staff_name'],
        staffId: json['staff_id'] == null ? '' : json['staff_id'],
        staffType: json['select_staff_type'] == null
            ? '0'
            : json['select_staff_type'].toString(),
        userName: json['user_name'] == null ? '' : json['user_name'],
        userInputName:
            json['user_input_name'] == null ? '' : json['user_input_name'],
        seatno: json['table_position'].toString(),
        status: json['status'].toString(),
        fromTime: json['from_time'] == null ? '' : json['from_time'].toString(),
        toTime: json['to_time'] == null ? '' : json['to_time'].toString(),
        payMethod:
            json['pay_method'] != null && json['pay_method'].toString() == '1'
                ? '1'
                : '2',
        amount: json['amount'] == null
            ? 0
            : double.parse(json['amount'].toString()).toInt(),
        couponAmount: json['coupon_use_amount'] == null
            ? '0'
            : json['coupon_use_amount'].toString(),
        flowTime: json['flow_time'] == null
            ? 0
            : int.parse(json['flow_time'].toString()),
        createTime: json['create_date'].toString(),
        menus: menus);
  }
}
