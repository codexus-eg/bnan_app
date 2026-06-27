enum TeacherAssignmentFilterType { all, active, finished }

extension TeacherAssignmentFilterTypeX on TeacherAssignmentFilterType {
  String? get statusValue {
    if (this == TeacherAssignmentFilterType.all) return null;
    if (this == TeacherAssignmentFilterType.active) return 'active';
    return 'finished';
  }
}

enum TeacherAssignmentStatus { active, finished }
