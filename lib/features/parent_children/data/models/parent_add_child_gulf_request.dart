import 'package:bnan_app/features/parent_children/data/models/parent_child_student_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';

class ParentAddChildGulfRequest {
  const ParentAddChildGulfRequest({
    required this.student,
    required this.curriculumId,
    required this.packageId,
    required this.paymentAddress,
    this.discountCode,
    this.locale = 'ar_SA',
  });

  final ParentChildStudentRequest student;
  final String curriculumId;
  final String packageId;
  final String? discountCode;
  final ParentPaymentAddress paymentAddress;
  final String locale;

  Map<String, dynamic> toJson() => {
    'student': student.toJson(),
    'curriculum': curriculumId,
    'packageId': packageId,
    if (discountCode?.trim().isNotEmpty == true)
      'discountCode': discountCode!.trim(),
    'paymentAddress': paymentAddress.toJson(),
    'locale': locale,
  };
}
