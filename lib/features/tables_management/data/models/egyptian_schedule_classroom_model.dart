class EgyptianScheduleClassroomModel {
  const EgyptianScheduleClassroomModel({this.id, this.name});

  final String? id;
  final String? name;

  factory EgyptianScheduleClassroomModel.fromJson(Map<String, dynamic> json) {
    return EgyptianScheduleClassroomModel(
      id: _text(json['id'] ?? json['_id']),
      name: _text(json['name']),
    );
  }

  static const placeholder = EgyptianScheduleClassroomModel(
    id: 'placeholder-classroom-1',
    name: 'الصف الدراسي',
  );
}

String? _text(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
