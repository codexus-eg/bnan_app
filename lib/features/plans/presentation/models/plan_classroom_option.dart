import 'package:bnan_app/core/enums/registration_mode.dart';

class PlanClassroomOption {
  const PlanClassroomOption({
    required this.id,
    required this.name,
    this.registrationMode,
  });

  final String id;
  final String name;
  final RegistrationMode? registrationMode;
}
