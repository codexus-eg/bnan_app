class EgyptianScheduleDay {
  const EgyptianScheduleDay({required this.date, this.lessons = const []});

  final String date;
  final List<EgyptianDigitalLesson> lessons;

  factory EgyptianScheduleDay.fromJson(Map<String, dynamic> json) =>
      EgyptianScheduleDay(
        date: _text(json['day'] ?? json['date']),
        lessons: _maps(
          json['lessons'],
        ).map(EgyptianDigitalLesson.fromJson).toList(growable: false),
      );
}

class EgyptianScheduleWeek {
  const EgyptianScheduleWeek({
    this.days = const [],
    this.currentWeek,
    this.currentWeekStart,
    this.timezone,
  });

  final List<EgyptianScheduleDay> days;
  final int? currentWeek;
  final DateTime? currentWeekStart;
  final String? timezone;

  factory EgyptianScheduleWeek.fromResponse(Object? response) {
    final root = _map(response);
    final data = _map(root['data']);
    final metadata = data.containsKey('currentWeek') ? data : root;
    return EgyptianScheduleWeek(
      days: parseEgyptianScheduleDays(root['data'] ?? response),
      currentWeek: int.tryParse(_text(metadata['currentWeek'])),
      currentWeekStart: DateTime.tryParse(_text(metadata['currentWeekStart'])),
      timezone: _optional(metadata['timezone']),
    );
  }
}

class EgyptianDigitalLesson {
  const EgyptianDigitalLesson({
    required this.id,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.classroomId,
    required this.classroomName,
    required this.subjectId,
    required this.subjectName,
    this.classroomSubjectId,
    this.teacherName,
    this.teacherId,
    this.chatRoomId,
    this.activeSession,
    this.scheduledAt,
  });

  final String id, date, startTime, classroomId, classroomName;
  final String subjectId, subjectName;
  final String? endTime, classroomSubjectId, teacherName, teacherId;
  final String? chatRoomId;
  final EgyptianLessonActiveSession? activeSession;
  final DateTime? scheduledAt;

  factory EgyptianDigitalLesson.fromJson(Map<String, dynamic> json) {
    final classroom = _map(json['classroom']);
    final classroomSubject = _map(json['classroomSubject']);
    final directSubject = _map(json['subject']);
    final subject = directSubject.isEmpty
        ? _map(classroomSubject['subject'])
        : directSubject;
    final directTeacher = _map(json['teacher']);
    final teacher = directTeacher.isEmpty
        ? _map(classroomSubject['teacher'])
        : directTeacher;
    return EgyptianDigitalLesson(
      id: _id(json),
      date: _text(json['day'] ?? json['date']),
      startTime: _text(json['startTime']),
      endTime: _optional(json['endTime']),
      classroomId: _referenceId(
            json['classroomId'] ?? json['classroom_id'] ?? json['classroom'],
          ) ??
          '',
      classroomName: _text(classroom['name']),
      subjectId: _id(subject),
      subjectName: _text(subject['name']),
      classroomSubjectId: _referenceId(
        json['classroomSubjectId'] ?? json['classroomSubject'],
      ),
      teacherName: _optional(teacher['name'] ?? teacher['fullName']),
      teacherId: _optional(teacher['id'] ?? teacher['_id']),
      chatRoomId: _referenceId(
        json['chatRoomId'] ??
            json['chatRoom'] ??
            classroomSubject['chatRoomId'] ??
            classroomSubject['chatRoom'],
      ),
      activeSession: json['activeSession'] is Map
          ? EgyptianLessonActiveSession.fromJson(
              Map<String, dynamic>.from(json['activeSession']),
            )
          : null,
      scheduledAt: DateTime.tryParse(_text(json['scheduledAt'])),
    );
  }
}

class EgyptianLessonActiveSession {
  const EgyptianLessonActiveSession({
    this.id = '',
    required this.status,
    this.canJoin,
    this.weeklySlotKey,
    this.recordingUrl,
    this.summaryUrl,
  });

  final String id;
  final String status;
  final bool? canJoin;
  final String? weeklySlotKey;
  final String? recordingUrl;
  final String? summaryUrl;

  factory EgyptianLessonActiveSession.fromJson(Map<String, dynamic> json) =>
      EgyptianLessonActiveSession(
        id: _id(json),
        status: _text(json['status']).toLowerCase(),
        canJoin: json['canJoin'] is bool ? json['canJoin'] as bool : null,
        weeklySlotKey: _optional(json['weeklySlotKey']),
        recordingUrl: _optional(json['recordingUrl']),
        summaryUrl: _optional(json['summaryUrl']),
      );

  bool get studentCanJoin => status == 'live' && canJoin == true;
  bool get isEnded => status == 'ended';
}

class EgyptianClassroomSubject {
  const EgyptianClassroomSubject({
    required this.classroomSubjectId,
    required this.subjectId,
    required this.subjectName,
    this.teacherNames = const [],
    this.isActive = true,
    this.chatRoomId,
  });

  final String classroomSubjectId, subjectId, subjectName;
  final List<String> teacherNames;
  final bool isActive;
  final String? chatRoomId;
  String get id => classroomSubjectId;

  factory EgyptianClassroomSubject.fromJson(Map<String, dynamic> json) {
    final subject = _map(json['subject']);
    final explicitClassroomSubjectId = _text(json['classroomSubjectId']);
    final explicitSubjectId = _text(json['subjectId']);
    final explicitName = _text(json['name']);
    final teachers = json['teachers'] is List
        ? json['teachers'] as List
        : json['teacher'] == null
        ? const []
        : [json['teacher']];
    return EgyptianClassroomSubject(
      classroomSubjectId: explicitClassroomSubjectId.isNotEmpty
          ? explicitClassroomSubjectId
          : _id(json),
      subjectId: explicitSubjectId.isNotEmpty
          ? explicitSubjectId
          : _id(subject),
      subjectName: explicitName.isNotEmpty
          ? explicitName
          : _text(subject['name']),
      teacherNames: teachers
          .whereType<Map>()
          .map((item) => _text(item['name'] ?? item['fullName']))
          .where((name) => name.isNotEmpty)
          .toList(growable: false),
      isActive: json['isActive'] != false,
      chatRoomId: _referenceId(json['chatRoomId'] ?? json['chatRoom']),
    );
  }
}

class EgyptianLessonRequest {
  const EgyptianLessonRequest({
    required this.classroomSubjectId,
    required this.startTime,
    required this.endTime,
  });

  final String classroomSubjectId, startTime, endTime;

  Map<String, dynamic> toJson() => {
    'classroomSubject': classroomSubjectId,
    'startTime': startTime,
    'endTime': endTime,
  };
}

class EgyptianDayRequest {
  const EgyptianDayRequest({required this.day, required this.lessons});

  final String day;
  final List<EgyptianLessonRequest> lessons;

  Map<String, dynamic> createJson(String classroomId) => {
    'classroom': classroomId,
    'day': day,
    'lessons': lessons.map((item) => item.toJson()).toList(),
  };

  Map<String, dynamic> replaceJson() => {
    'lessons': lessons.map((item) => item.toJson()).toList(),
  };
}

List<EgyptianClassroomSubject> parseEgyptianClassroomSubjects(Object? data) {
  final map = _map(data);
  final values = data is List ? data : map['subjects'] ?? map['data'];
  return _maps(values)
      .map(EgyptianClassroomSubject.fromJson)
      .where(
        (item) =>
            item.id.isNotEmpty && item.subjectName.isNotEmpty && item.isActive,
      )
      .toList(growable: false);
}

List<EgyptianScheduleDay> parseEgyptianScheduleDays(Object? data) {
  if (data is List) {
    return _maps(data)
        .where((item) => item['lessons'] is List)
        .map(EgyptianScheduleDay.fromJson)
        .toList(growable: false);
  }
  final map = _map(data);
  if ((map['day'] ?? map['date']) != null && map['lessons'] is List) {
    return [EgyptianScheduleDay.fromJson(map)];
  }
  for (final value in [map['days'], map['schedule'], map['schedules']]) {
    final nested = _map(value);
    if (nested.isNotEmpty) {
      final days = parseEgyptianScheduleDays(nested);
      if (days.isNotEmpty) return days;
    }
    final days = _maps(value)
        .where((item) => item['lessons'] is List)
        .map(EgyptianScheduleDay.fromJson)
        .toList(growable: false);
    if (days.isNotEmpty) return days;
  }
  final lessons = _maps(map['lessons']);
  final grouped = <String, List<EgyptianDigitalLesson>>{};
  for (final json in lessons) {
    final lesson = EgyptianDigitalLesson.fromJson(json);
    grouped.putIfAbsent(lesson.date, () => []).add(lesson);
  }
  return grouped.entries
      .map((item) => EgyptianScheduleDay(date: item.key, lessons: item.value))
      .toList(growable: false);
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

List<Map<String, dynamic>> _maps(Object? value) => value is List
    ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false)
    : const [];

String _id(Map<String, dynamic> json) => _text(json['id'] ?? json['_id']);
String _text(Object? value) => value?.toString().trim() ?? '';
String? _optional(Object? value) {
  final text = _text(value);
  return text.isEmpty ? null : text;
}

String? _referenceId(Object? value) {
  if (value is Map) return _optional(value['id'] ?? value['_id']);
  return _optional(value);
}
