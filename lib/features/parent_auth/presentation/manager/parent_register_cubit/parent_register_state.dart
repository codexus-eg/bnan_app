import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';

sealed class ParentRegisterState {
  const ParentRegisterState();
}

final class ParentRegisterInitial extends ParentRegisterState {
  const ParentRegisterInitial();
}

final class ParentRegisterLoading extends ParentRegisterState {
  const ParentRegisterLoading();
}

final class ParentRegisterSuccess extends ParentRegisterState {
  const ParentRegisterSuccess(this.response);

  final ParentRegisterResponseModel response;
}

final class ParentRegisterFailure extends ParentRegisterState {
  const ParentRegisterFailure(this.errorMessage);

  final String errorMessage;
}
