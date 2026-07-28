import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';

class TeacherClassroomsResponseModel {
  final List<TeacherClassroomModel> classrooms;

  const TeacherClassroomsResponseModel({required this.classrooms});

  factory TeacherClassroomsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final items = data is List ? data : const [];

    return TeacherClassroomsResponseModel(
      classrooms: items
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(TeacherClassroomModel.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList(),
    );
  }

  factory TeacherClassroomsResponseModel.placeholder() {
    return TeacherClassroomsResponseModel(
      classrooms: List.generate(3, (_) => TeacherClassroomModel.placeholder()),
    );
  }
}
