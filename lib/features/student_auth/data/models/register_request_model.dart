import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/models/registration_item.dart';

class RegisterRequestModel {
  const RegisterRequestModel({
    required this.parent,
    required this.student,
    required this.curriculum,
    this.packageId,
    this.items = const [],
  });

  final RegisterParentModel parent;
  final RegisterStudentModel student;
  final String curriculum;
  final String? packageId;
  final List<RegistrationItem> items;

  Map<String, dynamic> toJson() {
    return {
      'parent': parent.toJson(),
      'student': student.toJson(),
      'curriculum': curriculum,
      if (packageId != null) 'packageId': packageId,
      if (items.isNotEmpty)
        'items': items.map((item) => item.toJson()).toList(growable: false),
    };
  }
}
