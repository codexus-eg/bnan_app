import 'package:bnan_app/core/enums/registration_mode.dart';

class CurrentUser {
  const CurrentUser({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.role,
    this.registrationMode,
    this.registrationModes = const [],
  });

  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? role;
  final RegistrationMode? registrationMode;
  final List<RegistrationMode> registrationModes;

  CurrentUser merge({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
  }) => CurrentUser(
    id: _present(id) ?? this.id,
    fullName: _present(fullName) ?? this.fullName,
    email: _present(email) ?? this.email,
    phone: _present(phone) ?? this.phone,
    role: _present(role) ?? this.role,
    registrationMode: registrationMode,
    registrationModes: registrationModes,
  );
}

String? _present(String? value) {
  final trimmed = value?.trim();
  return trimmed?.isNotEmpty == true ? trimmed : null;
}
