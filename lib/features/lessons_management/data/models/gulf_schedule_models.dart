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

  GulfSchedulesData copyWithClassrooms(List<GulfClassroom> newClassrooms) =>
      GulfSchedulesData(
        classrooms: newClassrooms,
        currentWeek: currentWeek,
        currentWeekStart: currentWeekStart,
        timezone: timezone,
      );

  factory GulfSchedulesData.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic> metadata = const {},
  }) {
    final students = _maps(json['students']);
    final studentClassrooms = students.expand((s) {
      final sName = _string(s['name']);
      return _maps(s['classrooms']).map((cr) {
        final crMap = Map<String, dynamic>.from(cr);
        if (_string(crMap['name']).isEmpty && sName.isNotEmpty) {
          crMap['name'] = sName;
        }
        return crMap;
      });
    }).toList();

    final directClassrooms = [
      ..._maps(json['classrooms']),
      ..._maps(json['teacherClassrooms']),
      ..._maps(json['myClassrooms']),
      ..._maps(json['classes']),
      ..._maps(json['groups']),
      ..._maps(json['schedules'])
          .map((s) => _map(s['classroom']))
          .where((m) => m.isNotEmpty),
    ];
    final rawClassrooms = [...studentClassrooms, ...directClassrooms];

    final classroomById = <String, GulfClassroom>{};
    for (final raw in rawClassrooms) {
      final item = GulfClassroom.fromJson(raw);
      if (item.id.isNotEmpty) {
        classroomById[item.id] = item;
      }
    }

    final unifiedDays = _maps(json['days']);
    final topLevelLessons = _maps(json['lessons']);
    final allDaysList = [
      ...unifiedDays,
      if (topLevelLessons.isNotEmpty) {'lessons': topLevelLessons},
    ];

    final dayEntriesByClassroom = <String, List<GulfScheduleEntry>>{};
    final dayClassroomMap = <String, Map<String, dynamic>>{};

    for (final dayObj in allDaysList) {
      final dayName = _normalizeDay(_string(dayObj['day'] ?? dayObj['date']));
      for (final lesson in _maps(dayObj['lessons'])) {
        final cr = _map(lesson['classroom']);
        final crId = _id(cr).isNotEmpty
            ? _id(cr)
            : _string(lesson['classroomId'] ?? lesson['classroom_id']);
        if (crId.isEmpty) continue;

        dayClassroomMap.putIfAbsent(crId, () => {
          'id': crId,
          'name': _string(cr['name']).isNotEmpty
              ? _string(cr['name'])
              : _string(lesson['classroomName']),
          'subject': lesson['subject'],
          'classroomSubject':
              lesson['classroomSubjectId'] ?? lesson['classroomSubject'],
          'chatRoomId': lesson['chatRoomId'] ?? lesson['chatRoom'],
          'curriculum': {
            'id': _string(cr['curriculumId'] ?? lesson['curriculumId']),
            'name': '',
            'registrationMode': _string(lesson['system']).isNotEmpty
                ? _string(lesson['system'])
                : 'gulf',
          },
        });

        final lessonData = Map<String, dynamic>.from(lesson);
        if (_string(lessonData['day']).isEmpty && dayName.isNotEmpty) {
          lessonData['day'] = dayName;
        }
        if (_string(lessonData['classroomId']).isEmpty && crId.isNotEmpty) {
          lessonData['classroomId'] = crId;
        }
        final entry = GulfScheduleEntry.fromJson(lessonData);
        if (entry.isValid) {
          dayEntriesByClassroom.putIfAbsent(crId, () => []).add(entry);
        }
      }
    }

    for (final entry in dayClassroomMap.entries) {
      if (!classroomById.containsKey(entry.key)) {
        final data = Map<String, dynamic>.from(entry.value);
        classroomById[entry.key] = GulfClassroom.fromJson(data);
      }
    }

    final resolvedClassrooms = classroomById.values.map((classroom) {
      final dayEntries = dayEntriesByClassroom[classroom.id] ?? const [];
      if (dayEntries.isEmpty) {
        return classroom;
      }

      final existingEntries = classroom.entries;
      final combined = [...existingEntries];
      for (final de in dayEntries) {
        if (!combined.any((e) => e.day == de.day && e.startTime == de.startTime)) {
          combined.add(de);
        }
      }

      return classroom.copyWithSchedule(
        GulfSchedule(
          id: classroom.schedule?.id ?? classroom.id,
          classroomSubject: classroom.classroomSubjectId ?? '',
          entries: combined,
          isActive: true,
        ),
      );
    }).toList(growable: false);
    return GulfSchedulesData(
      classrooms: resolvedClassrooms,
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
    this.classroomKind,
    this.type,
  });

  final String id, name;
  final GulfGrade? grade;
  final GulfCurriculum? curriculum;
  final GulfSubject? subject;
  final GulfSchedule? schedule;
  final String? classroomSubject;
  final String? chatRoomId;
  final bool hasSubjectConflict;
  final String? classroomKind;
  final String? type;

  bool get isCourse =>
      classroomKind?.toLowerCase().trim() == 'course' ||
      type?.toLowerCase().trim() == 'course' ||
      (grade == null &&
          (name.toLowerCase().contains('دورة') ||
              name.toLowerCase().contains('course')));

  String? get classroomSubjectId =>
      _nonEmpty(classroomSubject) ?? _nonEmpty(schedule?.classroomSubject);
  List<GulfScheduleEntry> get entries =>
      schedule?.isActive == false ? const [] : schedule?.entries ?? const [];

  GulfClassroom copyWith({
    String? id,
    String? name,
    GulfGrade? grade,
    GulfCurriculum? curriculum,
    GulfSubject? subject,
    GulfSchedule? schedule,
    String? classroomSubject,
    String? chatRoomId,
    bool? hasSubjectConflict,
    String? classroomKind,
    String? type,
  }) => GulfClassroom(
    id: id ?? this.id,
    name: name ?? this.name,
    grade: grade ?? this.grade,
    curriculum: curriculum ?? this.curriculum,
    subject: subject ?? this.subject,
    schedule: schedule ?? this.schedule,
    classroomSubject: classroomSubject ?? this.classroomSubject,
    chatRoomId: chatRoomId ?? this.chatRoomId,
    hasSubjectConflict: hasSubjectConflict ?? this.hasSubjectConflict,
    classroomKind: classroomKind ?? this.classroomKind,
    type: type ?? this.type,
  );

  GulfClassroom copyWithSchedule(GulfSchedule newSchedule) => GulfClassroom(
    id: id,
    name: name,
    grade: grade,
    curriculum: curriculum,
    subject: subject,
    schedule: newSchedule,
    classroomSubject: classroomSubject,
    chatRoomId: chatRoomId,
    hasSubjectConflict: hasSubjectConflict,
    classroomKind: classroomKind,
    type: type,
  );

  factory GulfClassroom.fromJson(Map<String, dynamic> json) {
    final nestedClassroom = json['classroom'];
    final data = nestedClassroom is Map
        ? Map<String, dynamic>.from(nestedClassroom)
        : json;
    final classroomSubject =
        _map(data['classroomSubject'] ?? json['classroomSubject']);
    final schedule = _map(data['schedule'] ?? json['schedule']);
    final crSubId = _referenceId(
      data['classroomSubjectId'] ??
          data['classroomSubject'] ??
          json['classroomSubjectId'] ??
          json['classroomSubject'] ??
          schedule['classroomSubjectId'] ??
          schedule['classroomSubject'],
    );
    final student = _map(data['student'] ?? json['student']);
    final subject = _map(data['subject'] ?? json['subject']);
    String name = _string(data['name'] ?? json['name']);
    if (name.isEmpty) {
      name = _string(data['title'] ?? json['title']);
    }
    if (name.isEmpty && student.isNotEmpty) {
      final sName = _string(student['name'] ?? student['fullName']);
      final subName = _string(subject['name']);
      if (sName.isNotEmpty && subName.isNotEmpty) {
        name = '$sName - $subName';
      } else if (sName.isNotEmpty) {
        name = sName;
      }
    }
    return GulfClassroom(
      id: _id(data).isNotEmpty ? _id(data) : _id(json),
      name: name,
      grade: _nullable(data['grade'] ?? json['grade'], GulfGrade.fromJson),
      curriculum: _nullable(
        data['curriculum'] ?? json['curriculum'],
        GulfCurriculum.fromJson,
      ),
      subject: _nullable(
        data['subject'] ?? json['subject'],
        GulfSubject.fromJson,
      ) ??
          (name.contains(' - ') && name.split(' - ').last.trim().isNotEmpty
              ? GulfSubject(id: '', name: name.split(' - ').last.trim())
              : null),
      schedule: _nullable(
        data['schedule'] ?? json['schedule'],
        GulfSchedule.fromJson,
      ),
      classroomSubject: crSubId,
      chatRoomId: _referenceId(
        data['chatRoomId'] ??
            data['chatRoom'] ??
            json['chatRoomId'] ??
            json['chatRoom'] ??
            classroomSubject['chatRoomId'] ??
            classroomSubject['chatRoom'] ??
            schedule['chatRoomId'] ??
            schedule['chatRoom'],
      ),
      hasSubjectConflict:
          (data['hasSubjectConflict'] ?? json['hasSubjectConflict']) == true,
      classroomKind: _nonEmpty(
        data['classroomKind'] ?? json['classroomKind'],
      ),
      type: _nonEmpty(
        data['type'] ?? json['type'] ?? data['kind'] ?? json['kind'],
      ),
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
    this.id,
    this.slotId,
    required this.day,
    required this.startTime,
    this.endTime,
    this.activeSession,
    this.chatRoomId,
    this.classroomSubjectId,
    this.occurrenceKey,
    this.classroomId,
    this.weeklySlotKey,
  });
  final String? id;
  final String? slotId;
  final String day, startTime;
  final String? endTime;
  final StartedSession? activeSession;
  final String? chatRoomId;
  final String? classroomSubjectId;
  final String? occurrenceKey;
  final String? classroomId;
  final String? weeklySlotKey;
  bool get isValid => day.isNotEmpty && startTime.isNotEmpty;

  GulfScheduleEntry copyWith({
    String? id,
    String? slotId,
    String? day,
    String? startTime,
    String? endTime,
    StartedSession? activeSession,
    String? chatRoomId,
    String? classroomSubjectId,
    String? occurrenceKey,
    String? classroomId,
    String? weeklySlotKey,
  }) => GulfScheduleEntry(
    id: id ?? this.id,
    slotId: slotId ?? this.slotId,
    day: day ?? this.day,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    activeSession: activeSession ?? this.activeSession,
    chatRoomId: chatRoomId ?? this.chatRoomId,
    classroomSubjectId: classroomSubjectId ?? this.classroomSubjectId,
    occurrenceKey: occurrenceKey ?? this.occurrenceKey,
    classroomId: classroomId ?? this.classroomId,
    weeklySlotKey: weeklySlotKey ?? this.weeklySlotKey,
  );

  factory GulfScheduleEntry.fromJson(Map<String, dynamic> json) {
    final classroomSubject = _map(json['classroomSubject']);
    final rawClassroomId = _referenceId(
      json['classroomId'] ??
          json['classroom_id'] ??
          json['classroom'] ??
          classroomSubject['classroomId'] ??
          classroomSubject['classroom'],
    );
    final activeJson = _map(json['activeSession']);
    final activeSession = activeJson.isNotEmpty
        ? StartedSession.fromJson({
            ...activeJson,
            if (_string(activeJson['classroomId']).isEmpty &&
                rawClassroomId != null)
              'classroomId': rawClassroomId,
          })
        : _nullable(
            json['activeSession'],
            StartedSession.fromJson,
          );
    final rawSlotId = _nonEmpty(_string(json['slotId'] ?? json['slot_id']));
    final rawId = _referenceId(json['id'] ?? json['_id']);
    return GulfScheduleEntry(
      id: rawId ?? rawSlotId,
      slotId: rawSlotId ?? (rawId?.startsWith('csl_') == true ? rawId : null),
      day: _normalizeDay(_string(json['day'] ?? json['date'])),
      startTime: _string(json['startTime']),
      endTime: _nonEmpty(_string(json['endTime'])),
      activeSession: activeSession,
      chatRoomId: _referenceId(
        json['chatRoomId'] ??
            json['chatRoom'] ??
            classroomSubject['chatRoomId'] ??
            classroomSubject['chatRoom'],
      ),
      classroomSubjectId: _referenceId(
        json['classroomSubjectId'] ?? json['classroomSubject'],
      ),
      occurrenceKey: _nonEmpty(_string(json['occurrenceKey'])),
      classroomId: rawClassroomId,
      weeklySlotKey: _nonEmpty(_string(json['weeklySlotKey'] ?? json['slotKey'])),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (slotId != null) 'slotId': slotId,
    'day': day,
    'startTime': startTime,
    if (endTime != null) 'endTime': endTime,
    if (classroomSubjectId != null) 'classroomSubjectId': classroomSubjectId,
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

class UnifiedScheduleEntryInput {
  const UnifiedScheduleEntryInput({
    required this.day,
    required this.classroomSubjectId,
    required this.startTime,
    required this.endTime,
  });
  final String day, classroomSubjectId, startTime, endTime;

  Map<String, dynamic> toJson() => {
    'day': day.toLowerCase().trim(),
    'classroomSubjectId': classroomSubjectId.trim(),
    'startTime': startTime.trim(),
    'endTime': endTime.trim(),
  };
}

class UnifiedScheduleMutationResponse {
  const UnifiedScheduleMutationResponse({
    required this.success,
    required this.data,
  });
  final bool success;
  final UnifiedScheduleMutationData data;

  factory UnifiedScheduleMutationResponse.fromJson(Map<String, dynamic> json) =>
      UnifiedScheduleMutationResponse(
        success: json['success'] == true,
        data: UnifiedScheduleMutationData.fromJson(
          _map(json['data']),
        ),
      );
}

class UnifiedScheduleMutationData {
  const UnifiedScheduleMutationData({
    required this.id,
    required this.system,
    required this.classroomId,
  });
  final String id, system, classroomId;

  factory UnifiedScheduleMutationData.fromJson(Map<String, dynamic> json) =>
      UnifiedScheduleMutationData(
        id: _id(json),
        system: _string(json['system']),
        classroomId: _string(json['classroomId']),
      );
}

String _normalizeDay(String? value) {
  final day = (value ?? '').trim().toLowerCase();
  if (day.isEmpty) return '';
  const validDays = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];
  if (validDays.contains(day)) return day;
  final arabicDay = switch (day) {
    'السبت' || 'سبت' => 'saturday',
    'الأحد' || 'الاحد' || 'أحد' || 'احد' => 'sunday',
    'الاثنين' || 'الإثنين' || 'اثنين' || 'إثنين' => 'monday',
    'الثلاثاء' || 'ثلاثاء' => 'tuesday',
    'الأربعاء' || 'الاربعاء' || 'أربعاء' || 'اربعاء' => 'wednesday',
    'الخميس' || 'خميس' => 'thursday',
    'الجمعة' || 'جمعة' => 'friday',
    _ => null,
  };
  return arabicDay ?? day;
}
