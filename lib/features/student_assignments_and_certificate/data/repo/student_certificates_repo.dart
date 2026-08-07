import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentCertificatesRepo {
  Future<Either<Failure, List<CertificateModel>>> getMyCertificates({
    String? studentId,
  });
}
