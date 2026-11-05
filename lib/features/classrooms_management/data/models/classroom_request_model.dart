import 'package:bnan_app/features/classrooms_management/data/models/shared_academic_target.dart';

class ClassroomRequestModel {
  const ClassroomRequestModel({
    required this.name,
    this.curriculumId,
    this.gradeId,
    this.supervisorId,
    this.meetingLink,
    this.classroomKind,
    this.sharedAcademicTargets,
    this.subjects,
  });

  final String name;
  final String? curriculumId;
  final String? gradeId;
  final String? supervisorId;
  final String? meetingLink;
  final String? classroomKind;
  final List<SharedAcademicTarget>? sharedAcademicTargets;
  final List<String>? subjects;

  Map<String, dynamic> toJson() {
    final isShared = classroomKind == 'shared';
    return {
      'name': name,
      if (curriculumId != null) 'curriculum': curriculumId,
      if (gradeId != null) 'grade': gradeId,
      if (supervisorId != null) 'supervisorId': supervisorId,
      if (!isShared && meetingLink != null && meetingLink!.trim().isNotEmpty)
        'meetingLink': meetingLink!.trim(),
      if (classroomKind != null) 'classroomKind': classroomKind,
      if (sharedAcademicTargets != null)
        'sharedAcademicTargets':
            sharedAcademicTargets!.map((t) => t.toJson()).toList(),
      if (subjects != null) 'subjects': subjects,
    };
  }
}
