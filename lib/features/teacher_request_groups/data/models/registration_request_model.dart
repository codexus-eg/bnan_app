class RegistrationRequestModel {
  const RegistrationRequestModel({
    required this.requestId,
    required this.subjectRequestId,
    required this.studentId,
    required this.studentName,
    required this.curriculumId,
    required this.curriculumName,
    required this.gradeId,
    required this.gradeName,
    required this.subjectId,
    required this.subjectName,
    this.notes,
    this.requestedAt,
    required this.requestStatus,
  });

  final String requestId;
  final String subjectRequestId;
  final String studentId;
  final String studentName;
  final String curriculumId;
  final String curriculumName;
  final String gradeId;
  final String gradeName;
  final String subjectId;
  final String subjectName;
  final String? notes;
  final DateTime? requestedAt;
  final String requestStatus;
  factory RegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    String text(String key) => json[key]?.toString().trim() ?? '';
    final notes = text('notes');
    return RegistrationRequestModel(
      requestId: text('requestId'),
      subjectRequestId: text('subjectRequestId'),
      studentId: text('studentId'),
      studentName: text('studentName'),
      curriculumId: text('curriculumId'),
      curriculumName: text('curriculumName'),
      gradeId: text('gradeId'),
      gradeName: text('gradeName'),
      subjectId: text('subjectId'),
      subjectName: text('subjectName'),
      notes: notes.isEmpty ? null : notes,
      requestedAt: DateTime.tryParse(text('requestedAt')),
      requestStatus: text('requestStatus'),
    );
  }
}
