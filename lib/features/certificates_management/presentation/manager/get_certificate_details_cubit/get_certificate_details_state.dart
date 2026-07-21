import 'package:bnan_app/features/certificates_management/data/models/responses/certificate_details_response_model.dart';

sealed class GetCertificateDetailsState {}

final class GetCertificateDetailsInitial extends GetCertificateDetailsState {}

final class GetCertificateDetailsLoading extends GetCertificateDetailsState {}

final class GetCertificateDetailsSuccess extends GetCertificateDetailsState {
  final CertificateDetailsResponseModel response;

  GetCertificateDetailsSuccess(this.response);
}

final class GetCertificateDetailsFailure extends GetCertificateDetailsState {
  final String message;

  GetCertificateDetailsFailure(this.message);
}
