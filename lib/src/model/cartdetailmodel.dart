class CartDetailModel {
  final String id;
  final String ticketId;
  final String title;
  final String detail;
  final String? image;
  final String price;
  final String tax;
  final String cnt;

  int? cartCount;

  CartDetailModel({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.price,
    required this.image,
    required this.detail,
    required this.tax,
    required this.cnt,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    CartDetailModel tmp = CartDetailModel(
      id: json['cart_detail_id'],
      title: json['ticket_title'] == null ? '' : json['ticket_title'],
      ticketId: json['ticket_id'],
      price: json['ticket_price'],
      image: json['ticket_image'],
      detail: json['ticket_detail'] == null ? '' : json['ticket_detail'],
      tax: json['ticket_tax'],
      cnt: json['ticket_count'],
    );
    tmp.cartCount = int.parse(json['count']);
    return tmp;
  }
}
