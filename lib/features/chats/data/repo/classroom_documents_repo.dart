import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recordings_response.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summaries_response.dart';
import 'package:dartz/dartz.dart';

abstract class ClassroomDocumentsRepo {
  Future<Either<Failure, ClassroomRecordingsResponse>> getRecordings(
    String classroomId,
  );

  Future<Either<Failure, ClassroomSummariesResponse>> getSummaries(
    String classroomId,
  );
}
