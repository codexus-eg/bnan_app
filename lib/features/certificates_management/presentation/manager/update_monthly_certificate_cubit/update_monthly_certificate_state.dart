import 'package:bnan_app/features/certificates_management/data/models/responses/update_monthly_certificate_response_model.dart';

sealed class UpdateMonthlyCertificateState {}

final class UpdateMonthlyCertificateInitial
    extends UpdateMonthlyCertificateState {}

final class UpdateMonthlyCertificateLoading
    extends UpdateMonthlyCertificateState {}

final class UpdateMonthlyCertificateSuccess
    extends UpdateMonthlyCertificateState {
  final UpdateMonthlyCertificateResponseModel response;

  UpdateMonthlyCertificateSuccess(this.response);
}

final class UpdateMonthlyCertificateFailure
    extends UpdateMonthlyCertificateState {
  final String message;

  UpdateMonthlyCertificateFailure(this.message);
}
