import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';

class TeacherClassroomsResponseModel {
  final List<TeacherClassroomModel> classrooms;

  const TeacherClassroomsResponseModel({
    required this.classrooms,
  });

  factory TeacherClassroomsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return TeacherClassroomsResponseModel(
      classrooms: data
          .map((item) => TeacherClassroomModel.fromJson(item))
          .toList(),
    );
  }

  factory TeacherClassroomsResponseModel.placeholder() {
    return TeacherClassroomsResponseModel(
      classrooms: List.generate(
        3,
        (_) => TeacherClassroomModel.placeholder(),
      ),
    );
  }
}