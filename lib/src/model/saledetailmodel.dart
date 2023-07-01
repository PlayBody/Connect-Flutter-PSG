class SaleDetailModel {
  final String historyId;
  final String startTime;
  final String position;
  final String amount;
  final String menuCount;
  final String userSort;
  final String personCount;

  const SaleDetailModel(
      {required this.historyId,
      required this.startTime,
      required this.position,
      required this.amount,
      required this.menuCount,
      required this.userSort,
      required this.personCount});

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    String _hour = DateTime.parse(json['start_time']).hour < 10
        ? '0' + DateTime.parse(json['start_time']).hour.toString()
        : DateTime.parse(json['start_time']).hour.toString();
    String _minute = DateTime.parse(json['start_time']).minute < 10
        ? '0' + DateTime.parse(json['start_time']).minute.toString()
        : DateTime.parse(json['start_time']).minute.toString();
    return SaleDetailModel(
      historyId: json['order_table_history_id'],
      startTime: _hour + ':' + _minute,
      position: json['table_position'],
      amount: json['amount'],
      menuCount: json['menu_count'],
      userSort: json['user_sort'],
      personCount: json['person_count'] == null ? '' : json['person_count'],
    );
  }
}
