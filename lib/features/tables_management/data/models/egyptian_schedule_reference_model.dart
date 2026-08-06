class EgyptianScheduleReferenceModel {
  const EgyptianScheduleReferenceModel({this.id, this.name});

  final String? id;
  final String? name;

  factory EgyptianScheduleReferenceModel.fromJson(Map<String, dynamic> json) {
    return EgyptianScheduleReferenceModel(
      id: _text(json['id'] ?? json['_id']),
      name: _text(json['name']),
    );
  }
}

String? _text(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
