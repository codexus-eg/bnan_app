import 'package:bnan_app/features/registration_requests/data/models/registration_request_student_model.dart';

enum RegistrationRequestActionType { confirmPayment, approve, reject }

sealed class RegistrationRequestActionsState {}

final class RegistrationRequestActionsInitial
    extends RegistrationRequestActionsState {}

final class RegistrationRequestActionLoading
    extends RegistrationRequestActionsState {
  RegistrationRequestActionLoading({
    required this.studentId,
    required this.actionType,
  });

  final String studentId;
  final RegistrationRequestActionType actionType;
}

final class RegistrationRequestActionSuccess
    extends RegistrationRequestActionsState {
  RegistrationRequestActionSuccess({
    required this.studentId,
    required this.actionType,
    required this.message,
    required this.student,
  });

  final String studentId;
  final RegistrationRequestActionType actionType;
  final String message;
  final RegistrationRequestStudentModel? student;
}

final class RegistrationRequestActionFailure
    extends RegistrationRequestActionsState {
  RegistrationRequestActionFailure({
    required this.studentId,
    required this.actionType,
    required this.errorMessage,
  });

  final String studentId;
  final RegistrationRequestActionType actionType;
  final String errorMessage;
}
