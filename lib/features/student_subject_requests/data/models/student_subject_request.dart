import 'subject_request_availability.dart';

class StudentSubjectRequest {
  const StudentSubjectRequest({
    required this.id,
    required this.status,
    this.notes,
    this.subject,
    this.teacher,
    this.classroom,
    this.chatRoom,
  });

  final String id;
  final String status;
  final String? notes;
  final SubjectRequestLookup? subject;
  final SubjectRequestLookup? teacher;
  final SubjectRequestLookup? classroom;
  final SubjectRequestLookup? chatRoom;

  factory StudentSubjectRequest.fromJson(Map<String, dynamic> json) {
    SubjectRequestLookup? lookup(dynamic value) {
      if (value is Map) {
        return SubjectRequestLookup.fromJson(Map<String, dynamic>.from(value));
      }
      final id = value?.toString().trim() ?? '';
      return id.isEmpty ? null : SubjectRequestLookup(id: id, name: '');
    }

    return StudentSubjectRequest(
      id: (json['subjectRequestId'] ?? json['id'] ?? json['_id'] ?? '')
          .toString(),
      status: (json['status'] ?? '').toString(),
      notes: json['notes']?.toString(),
      subject: lookup(json['subject']),
      teacher: lookup(json['teacher']),
      classroom: lookup(json['classroom']),
      chatRoom: lookup(json['chatRoom']),
    );
  }
}
