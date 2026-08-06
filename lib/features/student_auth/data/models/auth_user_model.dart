import 'package:bnan_app/core/enums/registration_mode.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
    this.registrationMode,
    this.registrationModes = const [],
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final String status;
  final RegistrationMode? registrationMode;
  final List<RegistrationMode> registrationModes;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      registrationMode: RegistrationMode.fromValue(json['registrationMode']),
      registrationModes: RegistrationMode.fromList(json['registrationModes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'status': status,
      'registrationMode': registrationMode?.name,
      'registrationModes': registrationModes.map((mode) => mode.name).toList(),
    };
  }
}
