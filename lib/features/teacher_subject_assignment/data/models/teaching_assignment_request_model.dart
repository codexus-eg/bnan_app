class TeachingAssignmentRequestModel {
  final String classroomId;
  final List<String> subjects;

  TeachingAssignmentRequestModel({
    required this.classroomId,
    required this.subjects,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroom': classroomId,
      'subjects': subjects,
    };
  }
}
