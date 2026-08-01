class WeeklyEvaluationsAccessPolicy {
  const WeeklyEvaluationsAccessPolicy({
    required this.canAdd,
    required this.canEdit,
    required this.canFilterByClassroom,
    required this.isStudent,
    required this.isReadOnly,
  });

  final bool canAdd;
  final bool canEdit;
  final bool canFilterByClassroom;
  final bool isStudent;
  final bool isReadOnly;

  factory WeeklyEvaluationsAccessPolicy.fromRole(String? role) {
    final normalizedRole = role?.trim().toLowerCase();
    final isSupervisor = normalizedRole == 'supervisor';
    final isTeacher = normalizedRole == 'teacher';
    final isStudent = normalizedRole == 'student';
    final canManage = isSupervisor || isTeacher;
    return WeeklyEvaluationsAccessPolicy(
      canAdd: canManage,
      canEdit: canManage,
      canFilterByClassroom: canManage,
      isStudent: isStudent,
      isReadOnly: !canManage,
    );
  }
}
