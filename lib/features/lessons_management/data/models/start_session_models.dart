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
  const StartSessionData({required this.session, required this.meetingLink});
  final StartedSession session;
  final String meetingLink;

  factory StartSessionData.fromJson(Map<String, dynamic> json) =>
      StartSessionData(
        session: StartedSession.fromJson(_sessionMap(json)),
        meetingLink: _string(
          json['meetingLink'] ?? _sessionMap(json)['meetingLink'],
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
  });

  final String id, status;
  final String classroomId, subjectId, classroomSubjectId, occurrenceKey;
  final bool activeOccurrence;
  final DateTime? startAt;
  final bool? joinPermission;

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
      startAt: DateTime.tryParse(
        _string(_nonEmpty(json['startAt']) ?? sessionMap['startAt']),
      ),
    );
  }

  bool get isActive => const {
    'starting',
    'live',
    'awaiting_zoom_end',
  }.contains(status.toLowerCase());

  bool get canJoin =>
      const {'starting', 'live'}.contains(status.toLowerCase()) &&
      joinPermission != false;
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
