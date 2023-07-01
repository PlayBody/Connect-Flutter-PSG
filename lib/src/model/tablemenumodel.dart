class TableMenuModel {
  final String tableMenuId;
  final String menuTitle;
  final String quantity;
  final String menuPrice;
  final String? menuId;
  final String? variationId;

  const TableMenuModel(
      {required this.tableMenuId,
      required this.menuTitle,
      required this.quantity,
      required this.menuPrice,
      this.menuId,
      this.variationId});

  factory TableMenuModel.fromJson(Map<String, dynamic> json) {
    return TableMenuModel(
      tableMenuId: json['table_menu_id'],
      menuTitle: json['menu_title'],
      quantity: json['quantity'],
      menuPrice: json['menu_price'],
      menuId: json['menu_id'],
      variationId: json['variation_id'],
    );
  }
}
