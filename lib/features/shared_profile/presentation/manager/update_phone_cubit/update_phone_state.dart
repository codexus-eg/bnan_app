abstract class UpdatePhoneState {}

class UpdatePhoneInitial extends UpdatePhoneState {}

class UpdatePhoneLoading extends UpdatePhoneState {}

class UpdatePhoneSuccess extends UpdatePhoneState {
  final String message;

  UpdatePhoneSuccess({required this.message});
}

class UpdatePhoneFailure extends UpdatePhoneState {
  final String errorMessage;

  UpdatePhoneFailure({required this.errorMessage});
}