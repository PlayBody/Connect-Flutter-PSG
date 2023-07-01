class CompanyModel {
  final String companyId;
  final String companyName;
  final String companyDomain;
  final String ecUrl;
  final String companyReceiptNumber;
  final String companyPrintOrder;
  final String licensText;
  final String squareApplicationId;
  final String squareLocationId;
  final String squareToken;

  const CompanyModel({
    required this.companyId,
    required this.companyName,
    required this.companyDomain,
    required this.ecUrl,
    required this.companyReceiptNumber,
    required this.companyPrintOrder,
    required this.licensText,
    required this.squareApplicationId,
    required this.squareLocationId,
    required this.squareToken,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['company_id'],
      companyName: json['company_name'],
      companyDomain: json['company_domain'],
      ecUrl: json['ec_site_url'] == null ? '' : json['ec_site_url'],
      companyReceiptNumber: json['company_receipt_number'] == null
          ? ''
          : json['company_receipt_number'],
      companyPrintOrder: json['print_order_number'] == null
          ? ''
          : json['print_order_number'].toString(),
      licensText: json['license_text'] == null ? '' : json['license_text'],
      squareApplicationId: json['square_application_id'] == null
          ? 'not set'
          : json['square_application_id'],
      squareLocationId: json['square_location_id'] == null
          ? 'not set'
          : json['square_location_id'],
      squareToken: json['square_token'] == null
          ? ''
          : json['square_token'],
    );
  }
}
