class CompanySiteModel {
  final String siteId;
  final String companyId;
  final String title;
  final String url;
  final String visible;

  const CompanySiteModel({
    required this.siteId,
    required this.companyId,
    required this.title,
    required this.url,
    required this.visible,
  });

  factory CompanySiteModel.fromJson(Map<String, dynamic> json) {
    return CompanySiteModel(
      siteId: json['id'],
      companyId: json['company_id'],
      title: json['site_title'] == null ? '' : json['site_title'],
      url: json['site_url'] == null ? '' : json['site_url'],
      visible: json['visible'] == null ? '0' : json['visible'].toString(),
    );
  }
}
