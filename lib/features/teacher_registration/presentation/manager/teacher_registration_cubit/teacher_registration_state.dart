import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';

sealed class TeacherRegistrationState {
  const TeacherRegistrationState({this.currentStep = 1});

  final int currentStep;
}

final class TeacherRegistrationInitialState extends TeacherRegistrationState {
  const TeacherRegistrationInitialState() : super(currentStep: 1);
}

final class TeacherRegistrationStepChange extends TeacherRegistrationState {
  const TeacherRegistrationStepChange({required super.currentStep});
}

final class TeacherRegistrationLoadingState extends TeacherRegistrationState {
  const TeacherRegistrationLoadingState({required super.currentStep});
}

final class TeacherRegistrationSuccessState extends TeacherRegistrationState {
  const TeacherRegistrationSuccessState({
    required this.user,
    required this.message,
    required super.currentStep,
  });

  final AuthUserModel user;
  final String message;
}

final class TeacherRegistrationFailureState extends TeacherRegistrationState {
  const TeacherRegistrationFailureState({
    required this.errorMessage,
    required super.currentStep,
  });

  final String errorMessage;
}

final class TeacherRegistrationDataChanged extends TeacherRegistrationState {
  const TeacherRegistrationDataChanged({required super.currentStep});
}
