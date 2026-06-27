import 'package:bnan_app/features/teacher_assignment/data/model/classroom_subject_model.dart';

class ClassroomSubjectsResponseModel {
  final List<ClassroomSubjectModel> classroomSubjects;

  const ClassroomSubjectsResponseModel({
    required this.classroomSubjects,
  });

  factory ClassroomSubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return ClassroomSubjectsResponseModel(
      classroomSubjects: data
          .map((item) => ClassroomSubjectModel.fromJson(item))
          .toList(),
    );
  }

  factory ClassroomSubjectsResponseModel.placeholder() {
    return ClassroomSubjectsResponseModel(
      classroomSubjects: [
        ClassroomSubjectModel(
          id: '',
          classroom: '',
          subjects: [''],
        ),
      ],
    );
  }

  Map<String, String> get subjectToClassroomSubjectId {
    final map = <String, String>{};

    for (final item in classroomSubjects) {
      for (final subjectId in item.subjects) {
        map[subjectId] = item.id;
      }
    }

    return map;
  }

  List<String> get subjectIds => subjectToClassroomSubjectId.keys.toList();
}