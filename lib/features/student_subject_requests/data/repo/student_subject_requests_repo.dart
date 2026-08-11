import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';
import 'package:dartz/dartz.dart';

abstract class StudentSubjectRequestsRepo {
  Future<Either<Failure, SubjectRequestAvailability>> getAvailableSubjects();
  Future<Either<Failure, List<PackageModel>>> getPackages(String curriculumId);
  Future<Either<Failure, List<StudentSubjectRequest>>> getRequests();
  Future<Either<Failure, StudentSubjectRequest>> submitEgyptian(
    EgyptianSubjectRequestPayload payload,
  );
  Future<Either<Failure, SubjectRequestPayment>> checkout({
    required GulfSubjectRequestPayload payload,
    required String idempotencyKey,
  });
  Future<Either<Failure, SubjectRequestPayment>> status(String paymentId);
  Future<Either<Failure, SubjectRequestPayment>> reconcile(String paymentId);
}
