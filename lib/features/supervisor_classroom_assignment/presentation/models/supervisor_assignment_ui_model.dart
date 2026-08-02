class SupervisorAssignmentUiModel {
  const SupervisorAssignmentUiModel({
    required this.id,
    required this.name,
    required this.assignments,
  });

  final String id;
  final String name;
  final List<SupervisorClassroomAssignmentUiModel> assignments;
}

class SupervisorClassroomAssignmentUiModel {
  const SupervisorClassroomAssignmentUiModel({
    required this.id,
    required this.classroomName,
    required this.curriculumName,
  });

  final String id;
  final String classroomName;
  final String curriculumName;
}
