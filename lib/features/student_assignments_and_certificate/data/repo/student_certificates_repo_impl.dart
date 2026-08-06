import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificates_response_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_certificates_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:bnan_app/core/error/failure.dart';

class StudentCertificatesRepoImpl implements StudentCertificatesRepo {
  const StudentCertificatesRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, List<CertificateModel>>> getMyCertificates() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.myCertificates,
        isProtected: true,
      );
      final items = CertificatesResponseModel.fromJson(response).data.toList();
      items.sort(_newestFirst);
      return items;
    });
  }

  int _newestFirst(CertificateModel first, CertificateModel second) {
    final firstDate = first.issuedAt;
    final secondDate = second.issuedAt;
    if (firstDate == null) return secondDate == null ? 0 : 1;
    if (secondDate == null) return -1;
    return secondDate.compareTo(firstDate);
  }
}
