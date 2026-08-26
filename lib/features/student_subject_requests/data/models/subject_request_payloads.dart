import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';

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
    required this.curriculumId,
    required this.paymentAddress,
    this.provider = GulfPaymentProvider.tamara,
    this.notes,
    this.discountCode,
  });

  final String subjectId;
  final String packageId;
  final String curriculumId;
  final PaymentAddress paymentAddress;
  final GulfPaymentProvider provider;
  final String? notes;
  final String? discountCode;

  Map<String, dynamic> toJson() => {
    'provider': provider.apiValue,
    'subjectId': subjectId,
    'packageId': packageId,
    'curriculumId': curriculumId,
    if (_optional(notes) case final value?) 'notes': value,
    if (_optional(discountCode) case final value?) 'discountCode': value,
    if (provider == GulfPaymentProvider.tamara)
      'paymentAddress': paymentAddress.toJson(),
    'locale': 'ar_SA',
    'isMobile': true,
  };
}

String? _optional(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}
