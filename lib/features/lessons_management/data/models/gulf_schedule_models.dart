import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';

class GulfSchedulesResponse {
  const GulfSchedulesResponse({required this.success, required this.data});

  final bool success;
  final GulfSchedulesData data;

  factory GulfSchedulesResponse.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    return GulfSchedulesResponse(
      success: json['success'] == true,
      data: GulfSchedulesData.fromJson(
        data,
        metadata: data.containsKey('currentWeek') ? data : json,
      ),
    );
  }
}

class GulfSchedulesData {
  const GulfSchedulesData({
    required this.classrooms,
    this.currentWeek,
    this.currentWeekStart,
    this.timezone,
  });
  final List<GulfClassroom> classrooms;
  final int? currentWeek;
  final DateTime? currentWeekStart;
  final String? timezone;

  factory GulfSchedulesData.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic> metadata = const {},
  }) {
    final students = _maps(json['students']);
    final classrooms = students.isNotEmpty
        ? _maps(students.first['classrooms'])
        : _maps(json['classrooms']);
    return GulfSchedulesData(
      classrooms: classrooms
          .map(GulfClassroom.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList(growable: false),
      currentWeek: int.tryParse(_stringValue(metadata['currentWeek'])),
      currentWeekStart: DateTime.tryParse(
        _stringValue(metadata['currentWeekStart']),
      ),
      timezone: _nonEmpty(_stringValue(metadata['timezone'])),
    );
  }
}

class GulfClassroom {
  const GulfClassroom({
    required this.id,
    required this.name,
    this.grade,
    this.curriculum,
    this.subject,
    this.schedule,
    this.classroomSubject,
    this.chatRoomId,
    this.hasSubjectConflict = false,
  });

  final String id, name;
  final GulfGrade? grade;
  final GulfCurriculum? curriculum;
  final GulfSubject? subject;
  final GulfSchedule? schedule;
  final String? classroomSubject;
  final String? chatRoomId;
  final bool hasSubjectConflict;

  String? get classroomSubjectId =>
      _nonEmpty(classroomSubject) ?? _nonEmpty(schedule?.classroomSubject);
  List<GulfScheduleEntry> get entries =>
      schedule?.isActive == false ? const [] : schedule?.entries ?? const [];

  factory GulfClassroom.fromJson(Map<String, dynamic> json) {
    final classroomSubject = _map(json['classroomSubject']);
    final schedule = _map(json['schedule']);
    return GulfClassroom(
      id: _id(json),
      name: _string(json['name']),
      grade: _nullable(json['grade'], GulfGrade.fromJson),
      curriculum: _nullable(json['curriculum'], GulfCurriculum.fromJson),
      subject: _nullable(json['subject'], GulfSubject.fromJson),
      schedule: _nullable(json['schedule'], GulfSchedule.fromJson),
      classroomSubject: _referenceId(json['classroomSubject']),
      chatRoomId: _referenceId(
        json['chatRoomId'] ??
            json['chatRoom'] ??
            classroomSubject['chatRoomId'] ??
            classroomSubject['chatRoom'] ??
            schedule['chatRoomId'] ??
            schedule['chatRoom'],
      ),
      hasSubjectConflict: json['hasSubjectConflict'] == true,
    );
  }
}

class GulfGrade extends GulfReference {
  const GulfGrade({required super.id, required super.name});
  factory GulfGrade.fromJson(Map<String, dynamic> json) =>
      GulfGrade(id: _id(json), name: _string(json['name']));
}

class GulfCurriculum extends GulfReference {
  const GulfCurriculum({
    required super.id,
    required super.name,
    required this.registrationMode,
  });
  final String registrationMode;
  factory GulfCurriculum.fromJson(Map<String, dynamic> json) => GulfCurriculum(
    id: _id(json),
    name: _string(json['name']),
    registrationMode: _string(json['registrationMode']).toLowerCase(),
  );
}

class GulfSubject extends GulfReference {
  const GulfSubject({required super.id, required super.name});
  factory GulfSubject.fromJson(Map<String, dynamic> json) =>
      GulfSubject(id: _id(json), name: _string(json['name']));
}

abstract class GulfReference {
  const GulfReference({required this.id, required this.name});
  final String id, name;
}

class GulfSchedule {
  const GulfSchedule({
    required this.id,
    required this.classroomSubject,
    required this.entries,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String id, classroomSubject;
  final List<GulfScheduleEntry> entries;
  final bool isActive;
  final String? createdAt, updatedAt;

  factory GulfSchedule.fromJson(Map<String, dynamic> json) => GulfSchedule(
    id: _id(json),
    classroomSubject: _referenceId(json['classroomSubject']) ?? '',
    entries: _maps(json['entries'])
        .map(GulfScheduleEntry.fromJson)
        .where((item) => item.isValid)
        .toList(growable: false),
    isActive: json['isActive'] != false,
    createdAt: _nonEmpty(_string(json['createdAt'])),
    updatedAt: _nonEmpty(_string(json['updatedAt'])),
  );
}

class GulfScheduleEntry {
  const GulfScheduleEntry({
    required this.day,
    required this.startTime,
    this.endTime,
    this.activeSession,
    this.chatRoomId,
    this.classroomSubjectId,
    this.occurrenceKey,
  });
  final String day, startTime;
  final String? endTime;
  final StartedSession? activeSession;
  final String? chatRoomId;
  final String? classroomSubjectId;
  final String? occurrenceKey;
  bool get isValid => day.isNotEmpty && startTime.isNotEmpty;

  factory GulfScheduleEntry.fromJson(Map<String, dynamic> json) =>
      GulfScheduleEntry(
        day: _string(json['day']).toLowerCase(),
        startTime: _string(json['startTime']),
        endTime: _nonEmpty(_string(json['endTime'])),
        activeSession: _nullable(
          json['activeSession'],
          StartedSession.fromJson,
        ),
        chatRoomId: _referenceId(json['chatRoomId'] ?? json['chatRoom']),
        classroomSubjectId: _referenceId(
          json['classroomSubjectId'] ?? json['classroomSubject'],
        ),
        occurrenceKey: _nonEmpty(_string(json['occurrenceKey'])),
      );

  Map<String, dynamic> toJson() => {
    'day': day,
    'startTime': startTime,
    if (endTime != null) 'endTime': endTime,
  };
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
List<Map<String, dynamic>> _maps(Object? value) => value is List
    ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
    : const [];
String _string(Object? value) => value is String ? value.trim() : '';
String _stringValue(Object? value) => value?.toString().trim() ?? '';
String _id(Map<String, dynamic> json) =>
    _string(json['id']).isNotEmpty ? _string(json['id']) : _string(json['_id']);
String? _nonEmpty(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();
String? _referenceId(Object? value) => value is String
    ? _nonEmpty(value)
    : value is Map
    ? _nonEmpty(_id(Map<String, dynamic>.from(value)))
    : null;
T? _nullable<T>(Object? value, T Function(Map<String, dynamic>) parser) =>
    value is Map ? parser(Map<String, dynamic>.from(value)) : null;
