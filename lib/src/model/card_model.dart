class CardModel {
  final String id;
  final String userId;
  final String brand;
  final String cardNum;
  final String expDate;
  final String type;
  final String postalCode;
  final String customerId;
  final String sourceId;

  const CardModel(
      {required this.id,
      required this.userId,
      required this.brand,
      required this.cardNum,
      required this.expDate,
      required this.type,
      required this.postalCode,
      required this.customerId,
      required this.sourceId,
      });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    int month = int.parse(json['exp_month'].toString());
    int year = int.parse(json['exp_year'].toString()) - 2000;
    String expDate = (month<10 ? '0' : '') + month.toString() +'/'+(year<10 ? '0' : '') + year.toString();
    return CardModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      brand: json['brand'].toString(),
      cardNum: '**** **** **** **** ' + json['last_num'].toString(),
      expDate: expDate,
      type: json['type'].toString(),
      postalCode: json['postal_code'].toString(),
      customerId: json['customer_id'].toString(),
      sourceId: json['source_id'].toString(),
    );
  }
}
