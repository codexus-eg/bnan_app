import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_requests_page.dart';
import 'package:dartz/dartz.dart';

abstract class AdminSubjectRequestsRepo {
  Future<Either<Failure, AdminSubjectRequestsPage>> getRequests({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, String>> approve({
    required String requestId,
    required AdminSubjectRequestApproval approval,
  });
  Future<Either<Failure, String>> reject(String requestId);
}
