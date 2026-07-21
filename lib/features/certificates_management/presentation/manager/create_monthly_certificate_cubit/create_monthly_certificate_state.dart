import 'package:bnan_app/features/certificates_management/data/models/responses/create_monthly_certificate_response_model.dart';

sealed class CreateMonthlyCertificateState {}

final class CreateMonthlyCertificateInitial
    extends CreateMonthlyCertificateState {}

final class CreateMonthlyCertificateLoading
    extends CreateMonthlyCertificateState {}

final class CreateMonthlyCertificateSuccess
    extends CreateMonthlyCertificateState {
  final CreateMonthlyCertificateResponseModel response;

  CreateMonthlyCertificateSuccess(this.response);
}

final class CreateMonthlyCertificateFailure
    extends CreateMonthlyCertificateState {
  final String message;

  CreateMonthlyCertificateFailure(this.message);
}
