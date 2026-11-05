import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:dartz/dartz.dart';

class StartSessionRepoImpl implements StartSessionRepo {
  const StartSessionRepoImpl(this.api);
  final ApiConsumer api;

  @override
  Future<Either<Failure, StartSessionData>> startSession({
    required String classroomId,
    required String subjectId,
    String? classroomSubjectId,
    String? lessonId,
    String? occurrenceDate,
    String? system,
  }) => repoGuard(() async {
    final isGulf = system?.trim().toLowerCase() == 'gulf';
    final cleanLessonId = isGulf ? null : lessonId?.trim();
    final body = <String, dynamic>{
      'subjectId': subjectId.trim(),
      if (classroomSubjectId != null && classroomSubjectId.trim().isNotEmpty)
        'classroomSubjectId': classroomSubjectId.trim(),
      if (cleanLessonId != null && cleanLessonId.isNotEmpty)
        'lessonId': cleanLessonId,
      if (occurrenceDate != null && occurrenceDate.trim().isNotEmpty)
        'occurrenceDate': occurrenceDate.trim(),
    };
    final response = await api.post(
      EndPoints.startClassroomSession(classroomId),
      data: body,
      isProtected: true,
    );
    return StartSessionResponse.fromJson(asMap(response)).data;
  });

  @override
  Future<Either<Failure, StartSessionData?>> getActiveSession({
    required String classroomId,
  }) async {
    final result = await repoGuard(() async {
      final response = await api.get(
        EndPoints.activeClassroomSession(classroomId),
        isProtected: true,
      );
      final root = asMap(response);
      final data = root['data'];
      if (data == null) return null;
      return StartSessionData.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : root,
      );
    });
    return result.fold(
      (failure) =>
          failure.statusCode == 404 || failure.code == 'SESSION_NOT_ACTIVE'
          ? const Right(null)
          : Left(failure),
      Right.new,
    );
  }

  @override
  Future<Either<Failure, String>> joinActiveSession({
    required String classroomId,
    String? weeklySlotKey,
  }) => repoGuard(() async {
    final slot = weeklySlotKey?.trim();
    final path = (slot != null && slot.isNotEmpty)
        ? EndPoints.weeklySlotEntry(classroomId, slot)
        : EndPoints.joinActiveClassroomSession(classroomId);
    final response = asMap(
      await api.get(
        path,
        isProtected: true,
      ),
    );
    final data = response['data'];
    final map = data is Map ? Map<String, dynamic>.from(data) : response;
    final sessionMap =
        map['session'] is Map ? Map<String, dynamic>.from(map['session']) : const {};
    final link = (map['meetingLink'] ??
            map['link'] ??
            map['joinUrl'] ??
            map['meetingUrl'] ??
            map['url'] ??
            sessionMap['meetingLink'] ??
            sessionMap['link'] ??
            sessionMap['joinUrl'] ??
            sessionMap['url'] ??
            '')
        .toString()
        .trim();
    if (link.isEmpty) {
      throw const AppException(
        'رابط الحصة غير متوفر حالياً',
        code: 'LINK_UNAVAILABLE',
      );
    }
    return link;
  });

  @override
  Future<Either<Failure, String>> getTeacherEntry({
    required String classroomId,
    required String sessionId,
  }) => repoGuard(() async {
    final response = asMap(
      await api.get(
        EndPoints.teacherEntryClassroomSession(
          classroomId.trim(),
          sessionId.trim(),
        ),
        isProtected: true,
      ),
    );
    final data = asMap(response['data']);
    final url = (data['teacherStartUrl'] ?? response['teacherStartUrl'] ?? '')
        .toString()
        .trim();
    if (url.isEmpty) {
      throw const AppException(
        'رابط بدء المعلم غير متوفر',
        code: 'TEACHER_START_URL_UNAVAILABLE',
      );
    }
    return url;
  });

  @override
  Future<Either<Failure, void>> endSession({required String sessionId}) =>
      repoGuard(() async {
        final id = sessionId.trim();
        if (id.isEmpty) {
          throw const AppException(
           'معرّف الجلسة غير صالح',
            code: 'INVALID_SESSION_ID',
          );
        }
        await api.post(EndPoints.endSession(id), isProtected: true);
      });
}
