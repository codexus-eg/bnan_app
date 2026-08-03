class AssignSupervisorRequestModel {
  const AssignSupervisorRequestModel({required this.assignments});

  final List<AssignSupervisorClassroomRequestModel> assignments;

  Map<String, dynamic> toJson() {
    return {
      'assignments': assignments
          .map((assignment) => assignment.toJson())
          .toList(growable: false),
    };
  }
}

class AssignSupervisorClassroomRequestModel {
  const AssignSupervisorClassroomRequestModel({required this.classroomId});

  final String classroomId;

  Map<String, dynamic> toJson() => {'classroom': classroomId};
}
