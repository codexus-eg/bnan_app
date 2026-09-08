class ClassroomRequestModel {
  const ClassroomRequestModel({
    required this.name,
    this.curriculumId,
    this.gradeId,
    this.supervisorId,
    this.meetingLink,
  });

  final String name;
  final String? curriculumId;
  final String? gradeId;
  final String? supervisorId;
  final String? meetingLink;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (curriculumId != null) 'curriculum': curriculumId,
      if (gradeId != null) 'grade': gradeId,
      if (supervisorId != null) 'supervisorId': supervisorId,
      if (meetingLink != null && meetingLink!.trim().isNotEmpty)
        'meetingLink': meetingLink!.trim(),
    };
  }
}
