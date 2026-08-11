import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';

class GulfRenewalRequest {
  const GulfRenewalRequest({
    required this.studentId,
    required this.packageId,
    required this.paymentAddress,
    this.subjectId,
    this.discountCode,
    this.locale = 'ar_SA',
  });
  final String studentId, packageId;
  final String? subjectId, discountCode;
  final ParentPaymentAddress paymentAddress;
  final String locale;

  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'packageId': packageId,
    if (_has(subjectId)) 'subjectId': subjectId!.trim(),
    if (_has(discountCode)) 'discountCode': discountCode!.trim(),
    'paymentAddress': paymentAddress.toJson(),
    'locale': locale,
  };

  static bool _has(String? value) => value?.trim().isNotEmpty == true;
}
