import 'package:bnan_app/features/classrooms_management/data/models/classroom_assigned_subject.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_eligible_subject.dart';

class ClassroomSubjectsResponseModel {
  const ClassroomSubjectsResponseModel({
    this.classroomKind = 'standard',
    this.subjects = const [],
    this.eligibleSubjects = const [],
  });

  final String classroomKind;
  final List<ClassroomAssignedSubject> subjects;
  final List<ClassroomEligibleSubject> eligibleSubjects;

  bool get isShared => classroomKind == 'shared';

  List<ClassroomEligibleSubject> get unassignedEligibleSubjects =>
      eligibleSubjects.where((s) => !s.isAssigned).toList();

  factory ClassroomSubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final Map<String, dynamic> data;
    List<dynamic> subjectsRaw = const [];

    if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
      subjectsRaw = (data['subjects'] as List<dynamic>?) ?? const [];
    } else if (rawData is List) {
      data = json;
      subjectsRaw = rawData;
    } else {
      data = json;
      subjectsRaw = (data['subjects'] as List<dynamic>?) ?? const [];
    }

    final subjectsList = subjectsRaw
        .whereType<Map>()
        .map((e) => ClassroomAssignedSubject.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final eligibleList = (data['eligibleSubjects'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => ClassroomEligibleSubject.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return ClassroomSubjectsResponseModel(
      classroomKind: data['classroomKind']?.toString() ?? 'standard',
      subjects: subjectsList,
      eligibleSubjects: eligibleList,
    );
  }
}
