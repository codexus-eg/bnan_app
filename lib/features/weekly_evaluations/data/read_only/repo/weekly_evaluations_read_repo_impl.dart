import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/read_evaluations_repo_guard.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:dartz/dartz.dart';

class WeeklyEvaluationsReadRepoImpl implements WeeklyEvaluationsReadRepo {
  const WeeklyEvaluationsReadRepoImpl(this.apiConsumer);
  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> getMyEvaluations({
    int? week,
    String? studentId,
    String? classroomId,
  }) => readEvaluationsRepoGuard(() async {
    final id = studentId?.trim();
    final scopedClassroomId = classroomId?.trim();
    final query = <String, dynamic>{
      if (week != null) 'week': week,
      if (id != null && id.isNotEmpty) 'studentId': id,
      if (scopedClassroomId != null && scopedClassroomId.isNotEmpty)
        'classroomId': scopedClassroomId,
    };
    final response = await apiConsumer.get(
      EndPoints.myEvaluations,
      queryParameter: query.isEmpty ? null : query,
      isProtected: true,
    );
    return MeWeeklyEvaluationsResponseModel.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, List<ParentEvaluationChildModel>>>
  getParentChildren() => readEvaluationsRepoGuard(() async {
    final response = asMap(
      await apiConsumer.get(EndPoints.parentChildren, isProtected: true),
    );
    return ReadEvaluationJsonParser.maps(
      response['data'],
    ).map(ParentEvaluationChildModel.fromJson).toList(growable: false);
  });

  @override
  Future<Either<Failure, List<ReadEvaluationReferenceModel>>>
  getMyClassrooms() => readEvaluationsRepoGuard(() async {
    final response = ChatRoomsResponseModel.fromJson(
      asMap(await apiConsumer.get(EndPoints.getMyChatRooms, isProtected: true)),
    );
    final ids = <String>{};
    return [
      for (final room in response.rooms)
        if (room.classroomId case final String id
            when id.isNotEmpty && ids.add(id))
          ReadEvaluationReferenceModel(id: id, name: room.displayName),
    ];
  });
}
