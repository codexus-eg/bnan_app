import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/certificate_details_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/create_monthly_certificate_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/issue_monthly_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/monthly_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/update_monthly_certificate_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class CertificatesManagementRepoImpl implements CertificatesManagementRepo {
  const CertificatesManagementRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;
  @override
  Future<Either<Failure, MonthlyCertificatesResponseModel>>
  getMonthlyCertificates({String? gradeId}) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.monthlyCertificates(gradeId: gradeId),
        isProtected: true,
      );

      return Right(MonthlyCertificatesResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, CertificateDetailsResponseModel>> getCertificateById({
    required String certificateId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.certificateById(certificateId),
        isProtected: true,
      );

      return CertificateDetailsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, CreateMonthlyCertificateResponseModel>>
  createMonthlyCertificate({
    required CreateMonthlyCertificateRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.post(
        EndPoints.studentMonthlyCertificates,
        data: request.toJson(),
        isProtected: true,
      );

      return CreateMonthlyCertificateResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, UpdateMonthlyCertificateResponseModel>>
  updateMonthlyCertificate({
    required String certificateId,
    required UpdateMonthlyCertificateRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(
        EndPoints.updateMonthlyCertificate(certificateId),
        data: request.toJson(),
        isProtected: true,
      );

      return UpdateMonthlyCertificateResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, IssueMonthlyCertificatesResponseModel>>
  issueMonthlyCertificates() {
    return repoGuard(() async {
      final response = await apiConsumer.post(
        EndPoints.issueMonthlyCertificates,
        isProtected: true,
      );

      return IssueMonthlyCertificatesResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, void>> deleteMonthlyCertificate({
    required String certificateId,
  }) {
    return repoGuard(() async {
      await apiConsumer.delete(
        EndPoints.certificateById(certificateId),
        isProtected: true,
      );
    });
  }
}
