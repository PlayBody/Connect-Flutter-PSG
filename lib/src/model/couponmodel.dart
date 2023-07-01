class CouponModel {
  final String couponId;
  final String userCouponId;
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
  final bool isUserUseFlag;

  const CouponModel(
      {required this.couponId,
      required this.userCouponId,
      required this.couponName,
      required this.couponCode,
      required this.useDate,
      required this.condition,
      required this.useOrgan,
      required this.comment,
      this.discountRate,
      this.discountAmount,
      this.upperAmount,
      this.isUserUseFlag = false,
      required this.isUse});

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: json['coupon_id'],
      userCouponId: json['user_coupon_id'],
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
      isUserUseFlag: json['use_flag'] == '1' ? false : true,
    );
  }
}
