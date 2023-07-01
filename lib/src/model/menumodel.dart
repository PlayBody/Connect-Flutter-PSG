class MenuModel {
  final String menuId;
  final String menuTitle;
  final String menuPrice;
  final String menuCost;
  final String menuTax;
  final String menuInterval;
  final String menuDetail;
  final String menuTime;

  final List<String>? variations;

  String? multiNumber;

  MenuModel({
    required this.menuId,
    required this.menuTitle,
    required this.menuPrice,
    required this.menuCost,
    required this.menuTax,
    required this.menuDetail,
    required this.menuTime,
    required this.menuInterval,
    this.multiNumber,
    this.variations,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
        menuId: json['menu_id'],
        menuTitle: json['menu_title'] == null ? '' : json['menu_title'],
        menuPrice: json['menu_price'] == null ? '' : json['menu_price'],
        menuCost: json['menu_cost'] == null ? '' : json['menu_cost'],
        menuTax: json['menu_tax'] == null ? '' : json['menu_tax'],
        menuDetail: json['menu_detail'] == null ? '' : json['menu_detail'],
        menuTime: json['menu_time'] == null ? '0' : json['menu_time'],
        // multiNumber: json['multi_number'] == null
        //     ? '1'
        //     : json['multi_number'].toString(),
        menuInterval:
            json['menu_interval'] == null ? '0' : json['menu_interval'],
        variations: json['variation_titles'] == null
            ? null
            : json['variation_titles'].split(','));
  }
}
