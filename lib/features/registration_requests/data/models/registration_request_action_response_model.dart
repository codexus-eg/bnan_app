import 'registration_json_parsing.dart';
import 'registration_request_student_model.dart';

class RegistrationRequestActionResponseModel {
  const RegistrationRequestActionResponseModel({
    required this.success,
    required this.message,
    required this.student,
  });

  final bool success;
  final String message;
  final RegistrationRequestStudentModel? student;

  factory RegistrationRequestActionResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = registrationMap(json['data']);
    final student = registrationMap(data?['student']);

    return RegistrationRequestActionResponseModel(
      success: json['success'] == true,
      message: registrationString(json['message']),
      student: student == null
          ? null
          : RegistrationRequestStudentModel.fromJson(student),
    );
  }
}
