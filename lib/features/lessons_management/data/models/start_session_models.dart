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
  });

  final String id, status;
  final bool activeOccurrence;
  final DateTime? startAt;

  factory StartedSession.fromJson(Map<String, dynamic> json) => StartedSession(
    id: _string(json['id']).isNotEmpty
        ? _string(json['id'])
        : _string(json['_id']),
    status: _string(json['status']),
    activeOccurrence: json['activeOccurrence'] == true,
    startAt: DateTime.tryParse(_string(json['startAt'])),
  );

  bool get isActive => const {
    'starting',
    'live',
    'awaiting_zoom_end',
  }.contains(status.toLowerCase());

  bool get canJoin => const {'starting', 'live'}.contains(status.toLowerCase());
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
String _string(Object? value) => value is String ? value.trim() : '';

Map<String, dynamic> _sessionMap(Map<String, dynamic> json) {
  final nested = _map(json['session'] ?? json['activeSession']);
  return nested.isNotEmpty ? nested : json;
}
