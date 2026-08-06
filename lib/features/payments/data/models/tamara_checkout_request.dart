import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';

class TamaraCheckoutRequest {
  const TamaraCheckoutRequest({
    required this.parentEmail,
    required this.parentPassword,
    required this.student,
    required this.curriculumId,
    required this.packageId,
    required this.address,
    this.locale = 'ar_SA',
  });

  final String parentEmail;
  final String parentPassword;
  final RegisterStudentModel student;
  final String curriculumId;
  final String packageId;
  final PaymentAddress address;
  final String locale;

  Map<String, dynamic> toJson() => {
    'parent': {'email': parentEmail.trim(), 'password': parentPassword},
    'student': student.toJson(),
    'curriculum': curriculumId,
    'packageId': packageId,
    'paymentAddress': address.toJson(),
    'locale': locale,
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
