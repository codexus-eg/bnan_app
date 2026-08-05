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
  String? _cacheOwner, _inFlightOwner;
  Future<Either<Failure, GulfSchedulesResponse>>? _inFlight;

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule() {
    final owner = SessionManager.instance.accessToken;
    if (_cacheOwner == owner && _cached != null) {
      return Future.value(Right(_cached!));
    }
    if (_inFlightOwner == owner && _inFlight != null) return _inFlight!;
    final request = _load(owner);
    _inFlightOwner = owner;
    _inFlight = request;
    request.whenComplete(() {
      if (!identical(_inFlight, request)) return;
      _inFlight = null;
      _inFlightOwner = null;
    });
    return request;
  }

  Future<Either<Failure, GulfSchedulesResponse>> _load(String? owner) =>
      repoGuard(() async {
        final response = await api.get(
          EndPoints.myGulfSchedule,
          isProtected: true,
        );
        final parsed = GulfSchedulesResponse.fromJson(asMap(response));
        if (SessionManager.instance.accessToken == owner) {
          _cacheOwner = owner;
          _cached = parsed;
        }
        return parsed;
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
        return unit;
      });
}
