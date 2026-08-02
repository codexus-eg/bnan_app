class WeeklyEvaluationsAccessPolicy {
  const WeeklyEvaluationsAccessPolicy({
    required this.canAdd,
    required this.canEdit,
    required this.canFilterByClassroom,
    required this.isStudent,
    required this.isParent,
    required this.isReadOnly,
  });

  final bool canAdd;
  final bool canEdit;
  final bool canFilterByClassroom;
  final bool isStudent;
  final bool isParent;
  final bool isReadOnly;

  factory WeeklyEvaluationsAccessPolicy.fromRole(String? role) {
    final normalizedRole = role?.trim().toLowerCase();
    final isSupervisor = normalizedRole == 'supervisor';
    final isTeacher = normalizedRole == 'teacher';
    final isStudent = normalizedRole == 'student';
    final isParent = normalizedRole == 'parent';
    final canManage = isSupervisor || isTeacher;
    return WeeklyEvaluationsAccessPolicy(
      canAdd: canManage,
      canEdit: canManage,
      canFilterByClassroom: canManage,
      isStudent: isStudent,
      isParent: isParent,
      isReadOnly: !canManage,
    );
  }
}
