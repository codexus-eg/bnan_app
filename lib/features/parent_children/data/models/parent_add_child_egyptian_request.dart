import 'package:bnan_app/features/parent_children/data/models/parent_child_student_request.dart';

class ParentAddChildEgyptianRequest {
  const ParentAddChildEgyptianRequest({
    required this.student,
    required this.curriculumId,
    required this.packageId,
    this.discountCode,
  });

  final ParentChildStudentRequest student;
  final String curriculumId;
  final String packageId;
  final String? discountCode;

  Map<String, dynamic> toJson() => {
    'student': student.toJson(),
    'curriculum': curriculumId,
    'packageId': packageId,
    if (_has(discountCode)) 'discountCode': discountCode!.trim(),
  };

  static bool _has(String? value) => value?.trim().isNotEmpty == true;
}
