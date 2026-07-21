import 'package:bnan_app/features/certificates_management/data/models/responses/monthly_certificates_response_model.dart';

sealed class GetMonthlyCertificatesState {}

final class GetMonthlyCertificatesInitial extends GetMonthlyCertificatesState {}

final class GetMonthlyCertificatesLoading extends GetMonthlyCertificatesState {}

final class GetMonthlyCertificatesSuccess extends GetMonthlyCertificatesState {
  final MonthlyCertificatesResponseModel response;

  GetMonthlyCertificatesSuccess(this.response);
}

final class GetMonthlyCertificatesFailure extends GetMonthlyCertificatesState {
  final String message;

  GetMonthlyCertificatesFailure(this.message);
}
