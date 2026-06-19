import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';

sealed class RegisterState {
  const RegisterState({this.currentStep = 1});

  final int currentStep;
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial() : super(currentStep: 1);
}

final class RegisterStepChanged extends RegisterState {
  const RegisterStepChanged({required super.currentStep});
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading({required super.currentStep});
}

final class RegisterSuccess extends RegisterState {
  const RegisterSuccess({
    required this.user,
    required super.currentStep,
  });

  final AuthUserModel user;
}

final class RegisterFailure extends RegisterState {
  const RegisterFailure({
    required this.errorMessage,
    required super.currentStep,
  });

  final String errorMessage;
}