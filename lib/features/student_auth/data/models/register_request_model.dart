import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';

class RegisterRequestModel {
  const RegisterRequestModel({
    required this.parent,
    required this.student,
    required this.curriculum,
    required this.packageId,
  });

  final RegisterParentModel parent;
  final RegisterStudentModel student;
  final String curriculum;
  final String packageId;

  Map<String, dynamic> toJson() {
    return {
      'parent': parent.toJson(),
      'student': student.toJson(),
      'curriculum': curriculum,
      'packageId': packageId,
    };
  }
}