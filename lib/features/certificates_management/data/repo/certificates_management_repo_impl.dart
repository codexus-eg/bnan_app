import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/certificate_details_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/create_monthly_certificate_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/issue_monthly_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/monthly_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/update_monthly_certificate_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/student_subjects_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class CertificatesManagementRepoImpl implements CertificatesManagementRepo {
  const CertificatesManagementRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;
  @override
  Future<Either<Failure, MonthlyCertificatesResponseModel>>
  getMonthlyCertificates({String? classroomId}) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.monthlyCertificates(classroomId: classroomId),
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
      final endpoint = EndPoints.createMonthlyStudentCertificate(
        request.studentId,
      );
      final body = request.toJson();
      _logCreateRequest(endpoint, request, body);
      final response = await apiConsumer.post(
        endpoint,
        data: body,
        isProtected: true,
      );

      return CreateMonthlyCertificateResponseModel.fromJson(asMap(response));
    });
  }

  void _logCreateRequest(
    String endpoint,
    CreateMonthlyCertificateRequestModel request,
    Map<String, dynamic> body,
  ) {
    if (!kDebugMode) return;
    debugPrint('Certificate create endpoint: ${EndPoints.baseUrl}$endpoint');
    debugPrint('Certificate create studentId path param: ${request.studentId}');
    debugPrint('Certificate create subjects count: ${request.subjects.length}');
    for (final subject in request.subjects) {
      debugPrint(
        'subjectId=${subject.subjectId}, scoreType=${subject.score.runtimeType}, '
        'maxScoreType=${subject.maxScore.runtimeType}',
      );
    }
    debugPrint('Certificate create body keys: ${body.keys.toList()}');
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

  @override
  Future<Either<Failure, ClassroomStudentsResponseModel>> getClassroomStudents({
    required String classroomId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.classroomStudents(classroomId),
        isProtected: true,
      );

      return ClassroomStudentsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, StudentSubjectsResponseModel>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.studentSubjects(
          classroomId: classroomId,
          studentId: studentId,
        ),
        isProtected: true,
      );

      return StudentSubjectsResponseModel.fromJson(asMap(response));
    });
  }
}
