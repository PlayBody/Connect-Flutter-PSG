class TableModel {
  final String tableId;
  final String tableTitle;
  final String seatno;
  final String status;
  final String? startTime;
  final String? endTime;

  const TableModel({
    required this.tableId,
    required this.tableTitle,
    required this.status,
    required this.seatno,
    this.startTime,
    this.endTime,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      tableId: json['table_id'].toString(),
      tableTitle: json['table_title'],
      seatno: json['seat_no'],
      status: json['status'],
      startTime: json['start_time'] == null ? '' : json['start_time'],
      endTime: json['end_time'] == null ? '' : json['end_time'],
    );
  }
}
