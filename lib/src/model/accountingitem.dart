class AccountingItem {
  final String title;
  final bool check;
  final String position;

  const AccountingItem(
      {required this.title, required this.check, required this.position});

  factory AccountingItem.fromJson(Map<String, dynamic> json) {
    return AccountingItem(
      title: json['data']['title'],
      check: json['ischeck'],
      position: json['position'].toString(),
    );
  }
}
