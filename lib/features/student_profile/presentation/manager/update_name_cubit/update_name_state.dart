abstract class UpdateNameState {}

class UpdateNameInitial extends UpdateNameState {}

class UpdateNameLoading extends UpdateNameState {}

class UpdateNameSuccess extends UpdateNameState {
  final String message;

  UpdateNameSuccess({required this.message});
}

class UpdateNameFailure extends UpdateNameState {
  final String errorMessage;

  UpdateNameFailure({required this.errorMessage});
}