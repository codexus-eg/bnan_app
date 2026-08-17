import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/certificate_details_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/create_monthly_certificate_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/issue_monthly_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/monthly_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/responses/update_monthly_certificate_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/student_subjects_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificates_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class CertificatesManagementRepo {
  Future<Either<Failure, MonthlyCertificatesResponseModel>>
  getMonthlyCertificates({String? classroomId});

  Future<Either<Failure, CertificateDetailsResponseModel>> getCertificateById({
    required String certificateId,
  });

  Future<Either<Failure, CreateMonthlyCertificateResponseModel>>
  createMonthlyCertificate({
    required CreateMonthlyCertificateRequestModel request,
  });

  Future<Either<Failure, UpdateMonthlyCertificateResponseModel>>
  updateMonthlyCertificate({
    required String certificateId,
    required UpdateMonthlyCertificateRequestModel request,
  });

  Future<Either<Failure, IssueMonthlyCertificatesResponseModel>>
  issueMonthlyCertificates();

  Future<Either<Failure, void>> deleteMonthlyCertificate({
    required String certificateId,
  });
  Future<Either<Failure, ClassroomStudentsResponseModel>> getClassroomStudents({
    required String classroomId,
  });

  Future<Either<Failure, StudentSubjectsResponseModel>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  });

  Future<Either<Failure, TeacherCertificatesResponseModel>>
  getTeacherCertificates({required int page, int limit = 20});

  Future<Either<Failure, TeacherCertificatesResponseModel>>
  getMyTeacherCertificates();

  Future<Either<Failure, void>> issueGeneralTeacherCertificate({
    required String teacherId,
    required String signerName,
  });
}
