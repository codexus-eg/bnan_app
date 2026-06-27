import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';

class TeacherAssignmentsResponseModel {
  final List<AssignmentModel> assignments;

  const TeacherAssignmentsResponseModel({required this.assignments});

  factory TeacherAssignmentsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return TeacherAssignmentsResponseModel(
      assignments: data.map((item) => AssignmentModel.fromJson(item)).toList(),
    );
  }

  factory TeacherAssignmentsResponseModel.placeholder() {
    return TeacherAssignmentsResponseModel(
      assignments: List.generate(5, (_) => AssignmentModel.placeholder()),
    );
  }
}
