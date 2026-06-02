sealed class UpdatePasswordState {}

final class UpdatePasswordInitial extends UpdatePasswordState {}

final class UpdatePasswordLoading extends UpdatePasswordState {}

final class UpdatePasswordSuccess extends UpdatePasswordState {
  UpdatePasswordSuccess({required this.message});

  final String message;
}

final class UpdatePasswordFailure extends UpdatePasswordState {
  UpdatePasswordFailure({required this.errorMessage});

  final String errorMessage;
}