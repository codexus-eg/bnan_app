import 'egyptian_schedule_classroom_model.dart';

class EgyptianScheduleModel {
  const EgyptianScheduleModel({this.id, this.classroom, this.image});

  final String? id;
  final EgyptianScheduleClassroomModel? classroom;
  final String? image;

  factory EgyptianScheduleModel.fromJson(Map<String, dynamic> json) {
    final classroomMap = _mapOf(json['classroom']);

    return EgyptianScheduleModel(
      id: _text(json['id'] ?? json['_id']),
      classroom: classroomMap == null
          ? null
          : EgyptianScheduleClassroomModel.fromJson(classroomMap),
      image: _text(json['image']),
    );
  }

  static const placeholder = EgyptianScheduleModel(
    id: 'placeholder-1',
    classroom: EgyptianScheduleClassroomModel.placeholder,
    image: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
  );

  static const placeholders = [
    placeholder,
    EgyptianScheduleModel(
      id: 'placeholder-2',
      classroom: EgyptianScheduleClassroomModel.placeholder,
      image: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    ),
  ];
}

Map<String, dynamic>? _mapOf(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String? _text(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
