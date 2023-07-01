class AccountingMenu {
  final String id;
  final String title;
  final String quantity;
  final String amount;
  final String? menuId;

  const AccountingMenu(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.amount,
      this.menuId});

  factory AccountingMenu.fromJson(Map<String, dynamic> json) {
    return AccountingMenu(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      amount: json['amount'],
      menuId: json['menu_id'],
    );
  }
}
