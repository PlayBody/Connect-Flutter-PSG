class TicketModel {
  final String id;
  final String ticketId;
  final String title;
  final String detail;
  final String? image;
  final String price;
  final String price02;
  final String cost;
  final String tax;
  final String disamount;
  final String cnt;
  final int userCnt;

  int? cartCount;

  TicketModel({
    required this.id,
    required this.ticketId,
    required this.title,
    this.image,
    required this.price,
    required this.price02,
    required this.detail,
    required this.cost,
    required this.tax,
    required this.disamount,
    required this.cnt,
    required this.userCnt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    TicketModel tmp = TicketModel(
      id: json['id'],
      ticketId: json['ticket_id'],
      title: json['ticket_title'] == null ? '' : json['ticket_title'],
      price: json['ticket_price'] == null ? '0' : json['ticket_price'],
      image: json['ticket_image'],
      price02: json['ticket_price02'] == null ? '0' : json['ticket_price02'],
      detail: json['ticket_detail'] == null ? '' : json['ticket_detail'],
      cost: json['ticket_cost'] == null ? '' : json['ticket_cost'],
      tax: json['ticket_tax'] == null ? '' : json['ticket_tax'],
      cnt: json['ticket_count'] == null ? '1' : json['ticket_count'],
      disamount:
          json['ticket_disamount'] == null ? '0' : json['ticket_disamount'],
      userCnt: json['count'] == null ? 0 : int.parse(json['count']),
    );
    tmp.cartCount = 1;
    return tmp;
  }
}
