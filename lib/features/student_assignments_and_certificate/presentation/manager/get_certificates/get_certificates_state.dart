import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';

sealed class GetCertificatesState {
  const GetCertificatesState();
}

class GetCertificatesInitial extends GetCertificatesState {}

class GetCertificatesLoading extends GetCertificatesState {}

class GetCertificatesSuccess extends GetCertificatesState {
  const GetCertificatesSuccess(this.certificates);

  final List<CertificateModel> certificates;
}

class GetCertificatesEmpty extends GetCertificatesState {}

class GetCertificatesFailure extends GetCertificatesState {
  const GetCertificatesFailure();
}

class GetCertificatesUnauthorized extends GetCertificatesState {}

class GetCertificatesStudentNotFound extends GetCertificatesState {}
