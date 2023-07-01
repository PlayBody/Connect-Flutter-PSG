class HomeMenuModel {
  final String menuKey;
  final String label;
  final bool isFree;

  const HomeMenuModel({
    required this.menuKey,
    required this.label,
    required this.isFree,
  });

  factory HomeMenuModel.fromJson(Map<String, dynamic> json) {
    return HomeMenuModel(
      menuKey: json['menu_key'],
      label: json['menu_name'],
      isFree: json['is_use'].toString() == '1',
    );
  }
}
