import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/accepted_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_response_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/repo/teacher_registration_requests_repo.dart';
import 'package:dartz/dartz.dart';

class FakeTeacherRequestsRepo implements TeacherRegistrationRequestsRepo {
  final pages = <int, Either<Failure, TeacherRequestsResponseModel>>{};
  Either<Failure, AcceptedTeacherRequestModel> acceptResult = Right(
    const AcceptedTeacherRequestModel(
      requestId: 'one',
      classroomId: 'classroom',
      chatRoomId: 'chat',
    ),
  );
  final requestedPages = <int>[];
  final acceptedIds = <String>[];

  @override
  Future<Either<Failure, TeacherRequestsResponseModel>> getRequests({
    required int page,
    int limit = 20,
  }) async {
    requestedPages.add(page);
    return pages[page]!;
  }

  @override
  Future<Either<Failure, AcceptedTeacherRequestModel>> acceptRequest(
    String requestId,
  ) async {
    acceptedIds.add(requestId);
    return acceptResult;
  }
}
