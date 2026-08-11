import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';

class EgyptianSubjectRequestPayload {
  const EgyptianSubjectRequestPayload({
    required this.subjectId,
    required this.packageId,
    this.notes,
  });

  final String subjectId;
  final String packageId;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'subjectIds': [subjectId],
    'packageId': packageId,
    if (_optional(notes) case final value?) 'notes': value,
  };
}

class GulfSubjectRequestPayload {
  const GulfSubjectRequestPayload({
    required this.subjectId,
    required this.packageId,
    required this.paymentAddress,
    this.notes,
    this.discountCode,
  });

  final String subjectId;
  final String packageId;
  final PaymentAddress paymentAddress;
  final String? notes;
  final String? discountCode;

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'packageId': packageId,
    if (_optional(notes) case final value?) 'notes': value,
    if (_optional(discountCode) case final value?) 'discountCode': value,
    'paymentAddress': paymentAddress.toJson(),
    'locale': 'ar_SA',
    'isMobile': true,
  };
}

String? _optional(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}
