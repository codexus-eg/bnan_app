import 'teacher_assigned_subject_model.dart';
import 'teacher_class_room_model.dart';

class TeacherAssignedSubjectsDataModel {
  const TeacherAssignedSubjectsDataModel({
    required this.classroom,
    required this.subjects,
  });

  final TeacherClassroomModel? classroom;
  final List<TeacherAssignedSubjectModel> subjects;

  factory TeacherAssignedSubjectsDataModel.fromJson(Map<String, dynamic> json) {
    final classroom = json['classroom'];
    final subjects = json['subjects'];

    return TeacherAssignedSubjectsDataModel(
      classroom: classroom is Map
          ? TeacherClassroomModel.fromJson(Map<String, dynamic>.from(classroom))
          : null,
      subjects: subjects is List
          ? subjects
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .map(TeacherAssignedSubjectModel.fromJson)
                .where((item) => item.id.isNotEmpty)
                .toList()
          : const [],
    );
  }
}
