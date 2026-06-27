// import 'package:bnan_app/features/teacher_shared/data/models/teacher_curriculum_model.dart';

// class TeacherCurriculumsResponseModel {
//   final List<TeacherCurriculumModel> curriculums;

//   TeacherCurriculumsResponseModel({required this.curriculums});

//   factory TeacherCurriculumsResponseModel.fromJson(Map<String, dynamic> json) {
//     return TeacherCurriculumsResponseModel(
//       curriculums: (json['data']['curriculums'] as List? ?? [])
//           .map((item) => TeacherCurriculumModel.fromJson(item))
//           .toList(),
//     );
//   }
// }