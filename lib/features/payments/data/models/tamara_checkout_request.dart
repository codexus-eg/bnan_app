import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/models/registration_item.dart';

class TamaraCheckoutRequest {
  const TamaraCheckoutRequest({
    required this.parentEmail,
    required this.parentPassword,
    required this.student,
    required this.curriculumId,
    required this.packageId,
    required this.address,
    this.provider = GulfPaymentProvider.tamara,
    this.items = const [],
    this.discountCode,
    this.locale = 'ar_SA',
  });

  final String parentEmail;
  final String parentPassword;
  final RegisterStudentModel student;
  final String curriculumId;
  final String packageId;
  final PaymentAddress address;
  final GulfPaymentProvider provider;
  final List<RegistrationItem> items;
  final String? discountCode;
  final String locale;

  Map<String, dynamic> toJson() => {
    'provider': provider.apiValue,
    'parent': {'email': parentEmail.trim(), 'password': parentPassword},
    'student': student.toJson(),
    'curriculum': curriculumId,
    if (items.isEmpty) 'packageId': packageId,
    if (items.isNotEmpty)
      'items': items.map((item) => item.toJson()).toList(growable: false),
    if (discountCode?.trim().isNotEmpty == true)
      'discountCode': discountCode!.trim(),
    if (provider == GulfPaymentProvider.tamara)
      'paymentAddress': address.toJson(),
    'locale': locale,
    'isMobile': true,
  };
}

class PaymentAddress {
  const PaymentAddress({
    required this.city,
    required this.region,
    required this.line1,
    this.line2 = '',
  });

  final String city;
  final String region;
  final String line1;
  final String line2;

  Map<String, dynamic> toJson() => {
    'city': city.trim(),
    'region': region.trim(),
    'line1': line1.trim(),
    'line2': line2.trim(),
  };
}
