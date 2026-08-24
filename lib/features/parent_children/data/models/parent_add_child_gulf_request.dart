import 'package:bnan_app/features/parent_children/data/models/parent_child_student_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/student_auth/data/models/registration_item.dart';

class ParentAddChildGulfRequest {
  const ParentAddChildGulfRequest({
    required this.student,
    required this.curriculumId,
    required this.packageId,
    required this.paymentAddress,
    this.items = const [],
    this.discountCode,
    this.locale = 'ar_SA',
  });

  final ParentChildStudentRequest student;
  final String curriculumId;
  final String packageId;
  final List<RegistrationItem> items;
  final String? discountCode;
  final ParentPaymentAddress paymentAddress;
  final String locale;

  Map<String, dynamic> toJson() => {
    'student': student.toJson(),
    'curriculum': curriculumId,
    if (items.isEmpty) 'packageId': packageId,
    if (items.isNotEmpty) 'items': items.map((item) => item.toJson()).toList(),
    if (discountCode?.trim().isNotEmpty == true)
      'discountCode': discountCode!.trim(),
    'paymentAddress': paymentAddress.toJson(),
    'locale': locale,
  };
}
