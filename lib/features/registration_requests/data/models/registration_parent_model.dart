import 'registration_json_parsing.dart';

class RegistrationParentModel {
  const RegistrationParentModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.whatsappNumber,
  });

  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String whatsappNumber;

  factory RegistrationParentModel.fromJson(Map<String, dynamic> json) {
    return RegistrationParentModel(
      id: registrationString(json['id'] ?? json['_id']),
      userId: registrationString(json['userId']),
      fullName: registrationString(json['fullName']),
      email: registrationString(json['email']),
      phone: registrationString(json['phone']),
      whatsappNumber: registrationString(json['whatsappNumber']),
    );
  }
}
