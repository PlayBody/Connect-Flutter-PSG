class OrganModel {
  final String organId;
  final String organName;
  final String isNoReserve;
  final String? organAddress;
  final String? organPhone;
  final String? organComment;
  final String? organImage;
  final String? organZipCode;
  final String? distance;
  final bool distance_status;
  final String? snsurl;
  final int checkTicketConsumtion;
  final String? lat;
  final String? lon;
  final String? access;
  final String? parking;
  final bool isOpen;

  const OrganModel(
      {required this.organId,
      required this.organName,
      required this.isNoReserve,
      this.organAddress,
      this.organPhone,
      this.organComment,
      this.organImage,
      this.organZipCode,
      this.distance,
      this.distance_status = false,
      this.snsurl,
      this.lat,
      this.lon,
      this.access,
      this.parking,
      required this.checkTicketConsumtion,
      required this.isOpen});

  factory OrganModel.fromJson(Map<String, dynamic> json) {
    return OrganModel(
        organId: json['organ_id'],
        organName: json['organ_name'],
        isNoReserve: json['is_no_reserve'] == null
            ? '0'
            : json['is_no_reserve'].toString(),
        organAddress: json['address'] == null ? '' : json['address'],
        organPhone: json['phone'],
        organComment: json['comment'] ?? '',
        organImage: json['image'],
        organZipCode: json['zip_code'],
        snsurl: json['sns_url'],
        lat: json['lat'],
        lon: json['lon'],
        access: json['access'],
        parking: json['parking'],
        distance: json['distance'].toString(),
        distance_status: (json['distance_status'] == null || json['distance_status'] == '0') ? false : true,
        checkTicketConsumtion: (json['checkin_ticket_consumption'] == null ||
                json['checkin_ticket_consumption'] == '')
            ? 0
            : int.parse(json['checkin_ticket_consumption']),
        isOpen: json['is_open'] ?? false);
  }
}
