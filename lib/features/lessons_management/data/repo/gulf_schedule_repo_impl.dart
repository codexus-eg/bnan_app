import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:dartz/dartz.dart';

class GulfScheduleRepoImpl implements GulfScheduleRepo {
  GulfScheduleRepoImpl(this.api);
  final ApiConsumer api;
  GulfSchedulesResponse? _cached;
  String? _cacheOwner, _cacheStudentId, _inFlightOwner, _inFlightStudentId;
  Future<Either<Failure, GulfSchedulesResponse>>? _inFlight;

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule({
    String? studentId,
  }) {
    final owner = SessionManager.instance.accessToken;
    final id = _studentId(studentId);
    if (_cacheOwner == owner && _cacheStudentId == id && _cached != null) {
      return Future.value(Right(_cached!));
    }
    if (_inFlightOwner == owner &&
        _inFlightStudentId == id &&
        _inFlight != null) {
      return _inFlight!;
    }
    final request = _load(owner, id);
    _inFlightOwner = owner;
    _inFlightStudentId = id;
    _inFlight = request;
    request.whenComplete(() {
      if (!identical(_inFlight, request)) return;
      _inFlight = null;
      _inFlightOwner = null;
      _inFlightStudentId = null;
    });
    return request;
  }

  Future<Either<Failure, GulfSchedulesResponse>> _load(
    String? owner,
    String? studentId,
  ) => repoGuard(() async {
    final response = await api.get(
      EndPoints.myGulfSchedule,
      queryParameter: studentId == null ? null : {'studentId': studentId},
      isProtected: true,
    );
    final parsed = GulfSchedulesResponse.fromJson(asMap(response));
    if (SessionManager.instance.accessToken == owner) {
      _cacheOwner = owner;
      _cacheStudentId = studentId;
      _cached = parsed;
    }
    return parsed;
  });

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getParentGulfSchedule({
    required String studentId,
    String? weekStart,
  }) => repoGuard(() async {
    final response = await api.get(
      EndPoints.myGulfSchedule,
      queryParameter: {
        'studentId': studentId.trim(),
        if (weekStart != null) 'weekStart': weekStart,
      },
      isProtected: true,
    );
    return GulfSchedulesResponse.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, Unit>> createClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => _save(
    () => api.post(
      EndPoints.gulfScheduleByClassroom(classroomId),
      data: request.toJson(),
      isProtected: true,
    ),
  );

  @override
  Future<Either<Failure, Unit>> updateClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => _save(
    () => api.put(
      EndPoints.gulfScheduleByClassroom(classroomId),
      data: request.toJson(),
      isProtected: true,
    ),
  );

  @override
  Future<Either<Failure, Unit>> deleteClassroomSchedule(String classroomId) =>
      _save(
        () => api.delete(
          EndPoints.gulfScheduleByClassroom(classroomId),
          isProtected: true,
        ),
      );

  Future<Either<Failure, Unit>> _save(Future<Object?> Function() call) =>
      repoGuard(() async {
        await call();
        _cached = null;
        _cacheOwner = null;
        _cacheStudentId = null;
        return unit;
      });

  String? _studentId(String? value) {
    final id = value?.trim();
    return id == null || id.isEmpty ? null : id;
  }
}
