import 'package:bnan_app/core/utils/schedule_time_utils.dart';

class StartSessionResponse {
  const StartSessionResponse({required this.success, required this.data});
  final bool success;
  final StartSessionData data;

  factory StartSessionResponse.fromJson(Map<String, dynamic> json) =>
      StartSessionResponse(
        success: json['success'] == true,
        data: StartSessionData.fromJson(_map(json['data'])),
      );
}

class StartSessionData {
  const StartSessionData({
    required this.session,
    required this.meetingLink,
    this.teacherStartUrl = '',
    this.chatRoomId = '',
  });
  final StartedSession session;
  final String meetingLink;
  final String teacherStartUrl;
  final String chatRoomId;

  factory StartSessionData.fromJson(Map<String, dynamic> json) =>
      StartSessionData(
        session: StartedSession.fromJson(_sessionMap(json)),
        meetingLink: _string(
          json['meetingLink'] ?? _sessionMap(json)['meetingLink'],
        ),
        teacherStartUrl: _string(
          json['teacherStartUrl'] ?? _sessionMap(json)['teacherStartUrl'],
        ),
        chatRoomId: _string(
          json['chatRoomId'] ?? json['chatRoom'] ?? _sessionMap(json)['chatRoomId'],
        ),
      );
}

class StartedSession {
  const StartedSession({
    required this.id,
    required this.status,
    required this.activeOccurrence,
    this.startAt,
    this.joinPermission,
    this.classroomId = '',
    this.subjectId = '',
    this.classroomSubjectId = '',
    this.occurrenceKey = '',
    this.chatRoomId = '',
    this.canStart = false,
    this.startStatus = '',
    this.scheduledStartAt,
    this.scheduledEndAt,
    this.startWindowOpensAt,
    this.startWindowClosesAt,
    this.weeklySlotKey = '',
  });

  final String id, status;
  final String classroomId, subjectId, classroomSubjectId, occurrenceKey;
  final String chatRoomId;
  final String weeklySlotKey;
  final bool activeOccurrence;
  final DateTime? startAt;
  final bool? joinPermission;
  final bool canStart;
  final String startStatus;
  final DateTime? scheduledStartAt;
  final DateTime? scheduledEndAt;
  final DateTime? startWindowOpensAt;
  final DateTime? startWindowClosesAt;

  String get sessionId => id;

  factory StartedSession.fromJson(Map<String, dynamic> json) {
    final sessionMap = _sessionMap(json);
    final rawId = _string(
      json['id'] ??
          json['_id'] ??
          json['sessionId'] ??
          sessionMap['id'] ??
          sessionMap['_id'] ??
          sessionMap['sessionId'],
    );
    final startWindow = _map(json['startWindow'] ?? sessionMap['startWindow']);
    final weeklyZoom = _map(json['weeklyZoom'] ?? sessionMap['weeklyZoom']);
    return StartedSession(
      id: rawId,
      status: _string(_nonEmpty(json['status']) ?? sessionMap['status']),
      activeOccurrence:
          json['activeOccurrence'] == true ||
          sessionMap['activeOccurrence'] == true,
      joinPermission: json['canJoin'] is bool
          ? json['canJoin'] as bool
          : sessionMap['canJoin'] is bool
          ? sessionMap['canJoin'] as bool
          : null,
      classroomId: _string(json['classroomId'] ?? sessionMap['classroomId']),
      subjectId: _string(json['subjectId'] ?? sessionMap['subjectId']),
      classroomSubjectId: _string(
        json['classroomSubjectId'] ?? sessionMap['classroomSubjectId'],
      ),
      occurrenceKey: _string(
        json['occurrenceKey'] ?? sessionMap['occurrenceKey'],
      ),
      chatRoomId: _string(
        json['chatRoomId'] ??
            json['chatRoom'] ??
            sessionMap['chatRoomId'] ??
            sessionMap['chatRoom'],
      ),
      startAt: DateTime.tryParse(
        _string(_nonEmpty(json['startAt']) ?? sessionMap['startAt']),
      ),
      canStart: json['canStart'] == true || sessionMap['canStart'] == true,
      startStatus: _string(json['startStatus'] ?? sessionMap['startStatus']),
      scheduledStartAt: DateTime.tryParse(
        _string(json['scheduledStartAt'] ?? sessionMap['scheduledStartAt']),
      ),
      scheduledEndAt: DateTime.tryParse(
        _string(json['scheduledEndAt'] ?? sessionMap['scheduledEndAt']),
      ),
      startWindowOpensAt: DateTime.tryParse(_string(startWindow['opensAt'])),
      startWindowClosesAt: DateTime.tryParse(_string(startWindow['closesAt'])),
      weeklySlotKey: _string(
        json['weeklySlotKey'] ??
            sessionMap['weeklySlotKey'] ??
            weeklyZoom['weeklySlotKey'],
      ),
    );
  }

  bool get isLive => status.trim().toLowerCase() == 'live';

  bool get isStarting => status.trim().toLowerCase() == 'starting';

  bool get isLiveOrStarting => isLive || isStarting;

  bool get isAwaitingZoomEnd =>
      status.trim().toLowerCase() == 'awaiting_zoom_end';

  bool get isActive => isLiveOrStarting || isAwaitingZoomEnd;

  bool get isScheduled => status.trim().toLowerCase() == 'scheduled';

  bool get isStartAvailable =>
      canStart || startStatus.trim().toUpperCase() == 'AVAILABLE';

  bool get isDueNow => isStartAvailable;

  bool get canJoin => isLiveOrStarting && joinPermission != false;

  bool get studentCanJoin => isLive && joinPermission == true;

  String? get resolvedOccurrenceDate {
    if (occurrenceKey.isNotEmpty) {
      final match = RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(occurrenceKey);
      if (match != null) return match.group(0);
    }
    if (scheduledStartAt != null) {
      return ScheduleTimeUtils.resolveOccurrenceDateFromUtc(scheduledStartAt!);
    }
    return null;
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
String _string(Object? value) => value is String ? value.trim() : '';
String? _nonEmpty(Object? value) {
  final str = value?.toString().trim();
  return (str != null && str.isNotEmpty) ? str : null;
}

Map<String, dynamic> _sessionMap(Map<String, dynamic> json) {
  final nested = _map(json['session'] ?? json['activeSession']);
  return nested.isNotEmpty ? nested : json;
}
