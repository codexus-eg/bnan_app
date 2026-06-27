abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordLoading extends UpdatePasswordState {}

class UpdatePasswordVisibilityChanged extends UpdatePasswordState {}

class UpdatePasswordSuccess extends UpdatePasswordState {
  final String message;

  UpdatePasswordSuccess({required this.message});
}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String errorMessage;

  UpdatePasswordFailure({required this.errorMessage});
}