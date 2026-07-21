import 'package:bnan_app/features/certificates_management/data/models/responses/issue_monthly_certificates_response_model.dart';

sealed class IssueMonthlyCertificatesState {}

final class IssueMonthlyCertificatesInitial
    extends IssueMonthlyCertificatesState {}

final class IssueMonthlyCertificatesLoading
    extends IssueMonthlyCertificatesState {}

final class IssueMonthlyCertificatesSuccess
    extends IssueMonthlyCertificatesState {
  final IssueMonthlyCertificatesResponseModel response;

  IssueMonthlyCertificatesSuccess(this.response);
}

final class IssueMonthlyCertificatesFailure
    extends IssueMonthlyCertificatesState {
  final String message;

  IssueMonthlyCertificatesFailure(this.message);
}
