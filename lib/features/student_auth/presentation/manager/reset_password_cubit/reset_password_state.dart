sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordVisibilityChanged extends ResetPasswordState {}

final class VerifyResetCodeSuccess extends ResetPasswordState {
  VerifyResetCodeSuccess({required this.message});

  final String message;
}

final class ResetPasswordSuccess extends ResetPasswordState {
  ResetPasswordSuccess({required this.message});

  final String message;
}

final class ResetPasswordFailure extends ResetPasswordState {
  ResetPasswordFailure({required this.errorMessage});

  final String errorMessage;
}

final class VerifyAccountSuccess extends ResetPasswordState {
  VerifyAccountSuccess({required this.message});

  final String message;
}
