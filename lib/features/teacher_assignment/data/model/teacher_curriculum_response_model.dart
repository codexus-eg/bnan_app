import 'package:bnan_app/features/teacher_assignment/data/model/teacher_curriculum_model.dart';

class TeacherCurriculumsResponseModel {
  final List<TeacherCurriculumModel> curriculums;

  const TeacherCurriculumsResponseModel({
    required this.curriculums,
  });

  factory TeacherCurriculumsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as List? ?? [];
    final firstTeacher = data.isNotEmpty ? data.first : {};
    final curriculumsData = firstTeacher['curriculums'] as List? ?? [];

    return TeacherCurriculumsResponseModel(
      curriculums: curriculumsData
          .map((e) => TeacherCurriculumModel.fromJson(e))
          .toList(),
    );
  }

  factory TeacherCurriculumsResponseModel.placeholder() {
    return TeacherCurriculumsResponseModel(
      curriculums: [
        TeacherCurriculumModel.placeholder(),
        TeacherCurriculumModel.placeholder(),
      ],
    );
  }
}