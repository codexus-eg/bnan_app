import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';

class GulfRenewalRequest {
  const GulfRenewalRequest({
    this.studentId,
    required this.packageId,
    required this.paymentAddress,
    this.subjectId,
    this.discountCode,
    this.locale = 'ar_SA',
    this.isMobile = true,
  });
  final String? studentId;
  final String packageId;
  final String? subjectId, discountCode;
  final ParentPaymentAddress paymentAddress;
  final String locale;
  final bool isMobile;

  Map<String, dynamic> toJson() => {
    if (_has(studentId)) 'studentId': studentId!.trim(),
    'packageId': packageId,
    if (_has(subjectId)) 'subjectId': subjectId!.trim(),
    if (_has(discountCode)) 'discountCode': discountCode!.trim(),
    'paymentAddress': paymentAddress.toJson(),
    'locale': locale,
    'isMobile': isMobile,
  };

  static bool _has(String? value) => value?.trim().isNotEmpty == true;
}
