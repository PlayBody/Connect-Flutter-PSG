class MenuVariationModel {
  final String variationId;
  final String menuId;
  final String variationTitle;
  final String variationPrice;
  final String? variationbackStaff;
  final String? variationAmount;
  final String? staffName;

  const MenuVariationModel({
    required this.variationId,
    required this.menuId,
    required this.variationTitle,
    required this.variationPrice,
    this.variationbackStaff,
    this.variationAmount,
    this.staffName,
  });

  factory MenuVariationModel.fromJson(Map<String, dynamic> json) {
    return MenuVariationModel(
        variationId: json['variation_id'],
        menuId: json['menu_id'],
        variationTitle: json['variation_title'],
        variationPrice: json['variation_price'],
        variationbackStaff: json['variation_back_staff'] == null
            ? null
            : json['variation_back_staff'],
        variationAmount: json['variation_back_amount'] == null
            ? ''
            : json['variation_back_amount'],
        staffName: json['staff_name'] == null ? null : json['staff_name']);
  }
}
