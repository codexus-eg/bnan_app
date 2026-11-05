import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_payloads.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';
import 'package:dartz/dartz.dart';

class GulfScheduleRepoImpl implements GulfScheduleRepo {
  GulfScheduleRepoImpl(this.api);
  final ApiConsumer api;
  GulfSchedulesResponse? _cached;
  DateTime? _cachedAt;
  static const _cacheDuration = Duration(minutes: 5);
  String? _cacheOwner, _cacheStudentId, _inFlightOwner, _inFlightStudentId;
  Future<Either<Failure, GulfSchedulesResponse>>? _inFlight;
  int _cacheGeneration = 0;

  @override
  void invalidateScheduleCache() {
    _cacheGeneration++;
    _cached = null;
    _cachedAt = null;
    _cacheOwner = null;
    _cacheStudentId = null;
    _inFlight = null;
    _inFlightOwner = null;
    _inFlightStudentId = null;
  }

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule({
    String? studentId,
  }) {
    final owner = SessionManager.instance.accessToken;
    final id = _studentId(studentId);
    final isExpired = _cachedAt == null ||
        DateTime.now().difference(_cachedAt!) > _cacheDuration;
    if (_cacheOwner == owner &&
        _cacheStudentId == id &&
        _cached != null &&
        !isExpired) {
      return Future.value(Right(_cached!));
    }
    if (_inFlightOwner == owner &&
        _inFlightStudentId == id &&
        _inFlight != null) {
      return _inFlight!;
    }
    final request = _load(owner, id, _cacheGeneration);
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
    int generation,
  ) => repoGuard(() async {
    final isTeacher =
        studentId == null && SessionManager.instance.role == UserRole.teacher;

    final scheduleFuture = api.get(
      EndPoints.myGulfSchedule,
      queryParameter: {
        'registrationMode': 'gulf',
        if (studentId != null) 'studentId': studentId,
      },
      isProtected: true,
    );

    Future<ChatRoomsResponseModel?> fetchChatRooms() async {
      try {
        final res = await api.get(EndPoints.getMyChatRooms, isProtected: true);
        return ChatRoomsResponseModel.fromJson(asMap(res));
      } catch (_) {
        return null;
      }
    }

    Future<TeacherClassroomsResponseModel?> fetchTeacherClassrooms() async {
      try {
        final res =
            await api.get(EndPoints.teacherClassrooms, isProtected: true);
        return TeacherClassroomsResponseModel.fromJson(asMap(res));
      } catch (_) {
        return null;
      }
    }

    final chatRoomsFuture = isTeacher
        ? fetchChatRooms()
        : Future<ChatRoomsResponseModel?>.value(null);

    final teacherClassroomsFuture = isTeacher
        ? fetchTeacherClassrooms()
        : Future<TeacherClassroomsResponseModel?>.value(null);

    final scheduleRaw = await scheduleFuture;
    final parsed = GulfSchedulesResponse.fromJson(asMap(scheduleRaw));

    ChatRoomsResponseModel? chatRooms;
    TeacherClassroomsResponseModel? teacherClassrooms;
    if (isTeacher) {
      chatRooms = await chatRoomsFuture;
      teacherClassrooms = await teacherClassroomsFuture;
    }

    final merged = _mergeTeacherClassrooms(
      existing: parsed.data.classrooms,
      chatRooms: chatRooms?.rooms,
      teacherClassrooms: teacherClassrooms?.classrooms,
    );

    final result = merged != null
        ? GulfSchedulesResponse(
            success: parsed.success,
            data: parsed.data.copyWithClassrooms(merged),
          )
        : parsed;

    if (SessionManager.instance.accessToken == owner &&
        generation == _cacheGeneration) {
      _cacheOwner = owner;
      _cacheStudentId = studentId;
      _cached = result;
      _cachedAt = DateTime.now();
    }
    return result;
  });

  List<GulfClassroom>? _mergeTeacherClassrooms({
    required List<GulfClassroom> existing,
    List<ChatRoomSummaryModel>? chatRooms,
    List<TeacherClassroomModel>? teacherClassrooms,
  }) {
    if (chatRooms == null && teacherClassrooms == null) return null;
    final map = <String, GulfClassroom>{
      for (final item in existing)
        if (item.id.isNotEmpty) item.id: item,
    };

    if (chatRooms != null) {
      for (final room in chatRooms) {
        final cid = room.classroomId?.trim();
        if (cid == null || cid.isEmpty) continue;
        final isClassroom = room.subtitle == 'فصل دراسي' ||
            room.type == 'classroom' ||
            room.type == 'classroom_group';
        if (!isClassroom && !map.containsKey(cid)) continue;

        final current = map[cid];
        if (current == null) {
          final displayName = room.displayName.trim();
          GulfSubject? roomSubject;
          if (displayName.contains(' - ')) {
            final subName = displayName.split(' - ').last.trim();
            if (subName.isNotEmpty) {
              roomSubject = GulfSubject(id: '', name: subName);
            }
          }
          map[cid] = GulfClassroom(
            id: cid,
            name: displayName.isNotEmpty ? displayName : 'فصل دراسي',
            classroomSubject: room.classroomSubjectId,
            chatRoomId: room.id,
            subject: roomSubject,
            curriculum: const GulfCurriculum(
              id: '',
              name: '',
              registrationMode: 'gulf',
            ),
            schedule: GulfSchedule(
              id: cid,
              classroomSubject: room.classroomSubjectId ?? '',
              entries: const [],
              isActive: true,
            ),
          );
        } else if (current.chatRoomId == null ||
            current.classroomSubject == null ||
            current.subject == null) {
          GulfSubject? resolvedSubject = current.subject;
          if (resolvedSubject == null && current.name.contains(' - ')) {
            final subName = current.name.split(' - ').last.trim();
            if (subName.isNotEmpty) {
              resolvedSubject = GulfSubject(id: '', name: subName);
            }
          }
          map[cid] = GulfClassroom(
            id: current.id,
            name: current.name,
            grade: current.grade,
            curriculum: current.curriculum,
            subject: resolvedSubject,
            schedule: current.schedule,
            classroomSubject:
                current.classroomSubject ?? room.classroomSubjectId,
            chatRoomId: current.chatRoomId ?? room.id,
            hasSubjectConflict: current.hasSubjectConflict,
          );
        }
      }
    }

    if (teacherClassrooms != null) {
      for (final tc in teacherClassrooms) {
        final cid = tc.id.trim();
        if (cid.isEmpty) continue;
        if (tc.registrationMode != null &&
            tc.registrationMode != RegistrationMode.gulf) {
          continue;
        }
        if (!map.containsKey(cid)) {
          map[cid] = GulfClassroom(
            id: cid,
            name: tc.name.trim().isNotEmpty ? tc.name.trim() : 'فصل دراسي',
            curriculum: const GulfCurriculum(
              id: '',
              name: '',
              registrationMode: 'gulf',
            ),
            schedule: GulfSchedule(
              id: cid,
              classroomSubject: '',
              entries: const [],
              isActive: true,
            ),
          );
        }
      }
    }

    return map.values.toList(growable: false);
  }

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getParentGulfSchedule({
    required String studentId,
  }) => repoGuard(() async {
    final response = await api.get(
      EndPoints.myGulfSchedule,
      queryParameter: {
        'registrationMode': 'gulf',
        'studentId': studentId.trim(),
      },
      isProtected: true,
    );
    return GulfSchedulesResponse.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, Unit>> createClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => updateClassroomSchedule(classroomId, request);

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

  @override
  Future<Either<Failure, CourseScheduleResponse>> getCourseSchedule(
    String classroomId,
  ) => repoGuard(() async {
    final response = await api.get(
      EndPoints.courseClassroomSchedule(classroomId.trim()),
      isProtected: true,
    );
    return CourseScheduleResponse.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, Unit>> updateCourseSchedule(
    String classroomId,
    CourseScheduleUpdateRequest request,
  ) => _save(
    () => api.put(
      EndPoints.courseClassroomSchedule(classroomId.trim()),
      data: request.toJson(),
      isProtected: true,
    ),
  );

  @override
  Future<Either<Failure, Unit>> deleteCourseScheduleSlot(
    String classroomId,
    String slotId,
  ) => _save(
    () => api.delete(
      EndPoints.classroomScheduleEntry(classroomId.trim(), slotId.trim()),
      isProtected: true,
    ),
  );

  Future<Either<Failure, Unit>> _save(Future<Object?> Function() call) =>
      repoGuard(() async {
        await call();
        invalidateScheduleCache();
        return unit;
      });

  String? _studentId(String? value) {
    final id = value?.trim();
    return id == null || id.isEmpty ? null : id;
  }
}
