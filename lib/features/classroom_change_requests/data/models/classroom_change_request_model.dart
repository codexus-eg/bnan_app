class ClassroomChangeRequestModel {
  const ClassroomChangeRequestModel({
    required this.id,
    required this.status,
    required this.requesterName,
    required this.requesterType,
    required this.classroomName,
    required this.subjectName,
    required this.notes,
    required this.requestType,
    this.createdAt,
  });

  final String id, status, requesterName, requesterType;
  final String classroomName, subjectName, notes, requestType;
  final DateTime? createdAt;

  factory ClassroomChangeRequestModel.fromJson(Map<String, dynamic> json) {
    final requester = _map(
      json['requestedBy'] ??
          json['requester'] ??
          json['student'] ??
          json['teacher'],
    );
    final user = _map(requester['user']);
    final classroom = _map(json['classroom']);
    final classroomSubject = _map(json['classroomSubject']);
    final subject = _map(
      json['subject'] ?? classroomSubject['subject'] ?? classroom['subject'],
    );
    final requesterType = _text(
      json['requesterType'] ?? requester['role'] ?? user['role'],
    );
    final requestType = _text(json['requestType'] ?? json['type']);
    return ClassroomChangeRequestModel(
      id: _text(json['id'] ?? json['_id']),
      status: _text(json['status']),
      requesterName: _text(
        requester['fullName'] ??
            requester['name'] ??
            user['fullName'] ??
            user['name'] ??
            json['requesterName'],
      ),
      requesterType: requesterType,
      classroomName: _text(classroom['name'] ?? json['classroomName']),
      subjectName: _text(subject['name'] ?? json['subjectName']),
      notes: _text(json['notes']),
      requestType: requestType.isEmpty && requesterType == 'teacher'
          ? 'teacher_withdrawal'
          : requestType,
      createdAt: DateTime.tryParse(
        _text(json['createdAt'] ?? json['requestedAt']),
      ),
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
String _text(Object? value) => value?.toString().trim() ?? '';
