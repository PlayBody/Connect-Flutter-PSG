class UserCouponModel {
  final String id;
  final String couponId;
  final String couponName;
  final String couponCode;
  final String useDate;
  final String condition;
  final String useOrgan;
  final String comment;
  final String? discountRate;
  final String? upperAmount;
  final String? discountAmount;
  final bool isUse;

  const UserCouponModel(
      {required this.id,
      required this.couponId,
      required this.couponName,
      required this.couponCode,
      required this.useDate,
      required this.condition,
      required this.useOrgan,
      required this.comment,
      this.discountRate,
      this.discountAmount,
      this.upperAmount,
      required this.isUse});

  factory UserCouponModel.fromJson(Map<String, dynamic> json) {
    return UserCouponModel(
      id: json['user_coupon_id'],
      couponId: json['coupon_id'],
      couponName: json['coupon_name'],
      couponCode: json['coupon_code'] == null ? '' : json['coupon_code'],
      useDate: json['use_date'],
      condition: json['condition'],
      useOrgan: json['use_organ_id'],
      comment: json['comment'],
      discountRate: json['discount_rate'],
      discountAmount: json['discount_amount'],
      upperAmount: json['upper_amount'],
      isUse: json['is_use'] == '1' ? true : false,
    );
  }
}
