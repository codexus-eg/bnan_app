sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordCooldown extends ForgotPasswordState {
  ForgotPasswordCooldown(this.seconds);

  final int seconds;
}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  ForgotPasswordSuccess({required this.message});

  final String message;
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  ForgotPasswordFailure({required this.errorMessage});

  final String errorMessage;
}
