
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_grade_model.dart';

class TeacherGradesResponseModel {
  final List<TeacherGradeModel> grades;

  const TeacherGradesResponseModel({
    required this.grades,
  });

  factory TeacherGradesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return TeacherGradesResponseModel(
      grades: data.map((item) => TeacherGradeModel.fromJson(item)).toList(),
    );
  }

  factory TeacherGradesResponseModel.placeholder() {
    return TeacherGradesResponseModel(
      grades: List.generate(
        3,
        (_) => TeacherGradeModel.placeholder(),
      ),
    );
  }
}