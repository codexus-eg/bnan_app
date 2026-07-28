import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';

class ClassroomSubjectsResponseModel {
  const ClassroomSubjectsResponseModel({required this.subjects});

  final List<SubjectDetailsModel> subjects;

  factory ClassroomSubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassroomSubjectsResponseModel(
      subjects: _subjectsFrom(json['data'])
          .map(SubjectDetailsModel.fromJson)
          .where((subject) => subject.id.isNotEmpty)
          .toList(),
    );
  }

  factory ClassroomSubjectsResponseModel.placeholder() {
    return const ClassroomSubjectsResponseModel(subjects: []);
  }
}

List<Map<String, dynamic>> _subjectsFrom(dynamic data) {
  if (data is Map && data['subjects'] is List) {
    return _mapList(data['subjects'] as List);
  }
  if (data is List) {
    return data.whereType<Map>().expand((item) {
      final subject = item['subject'];
      if (subject is Map) return [Map<String, dynamic>.from(subject)];
      if (item['name'] != null) return [Map<String, dynamic>.from(item)];
      return const <Map<String, dynamic>>[];
    }).toList();
  }
  return const [];
}

List<Map<String, dynamic>> _mapList(List<dynamic> items) {
  return items
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
