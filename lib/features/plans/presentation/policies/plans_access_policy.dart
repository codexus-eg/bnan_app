class PlansAccessPolicy {
  const PlansAccessPolicy({
    required this.showClassroomFilter,
    required this.showChildFilter,
    required this.showWeekFilter,
    required this.showManagementActions,
    required this.canAddDailyPlan,
    required this.canEditPlan,
    required this.canDeletePlan,
    required this.canUploadPlan,
    required this.showTeacherFieldInAddDialog,
    required this.isReadOnly,
    this.isGulfStudent = false,
  });

  final bool showClassroomFilter;
  final bool showChildFilter;
  final bool showWeekFilter;
  final bool showManagementActions;
  final bool canAddDailyPlan;
  final bool canEditPlan;
  final bool canDeletePlan;
  final bool canUploadPlan;
  final bool showTeacherFieldInAddDialog;
  final bool isReadOnly;
  final bool isGulfStudent;

  factory PlansAccessPolicy.fromRole(
    String? role, {
    bool isGulfStudent = false,
  }) {
    final normalizedRole = role?.trim().toLowerCase();
    final isSupervisor = normalizedRole == 'supervisor';
    final isAdmin = normalizedRole == 'admin';
    final isParent = normalizedRole == 'parent';
    final canManage = isSupervisor || isAdmin || normalizedRole == 'teacher';
    final hasClassrooms = canManage || normalizedRole == 'student';
    return PlansAccessPolicy(
      showClassroomFilter: hasClassrooms,
      showChildFilter: isParent,
      showWeekFilter: true,
      showManagementActions: canManage,
      canAddDailyPlan: canManage,
      canEditPlan: canManage,
      canDeletePlan: canManage,
      canUploadPlan: canManage,
      showTeacherFieldInAddDialog: isSupervisor || isAdmin,
      isReadOnly: !canManage,
      isGulfStudent: normalizedRole == 'student' && isGulfStudent,
    );
  }
}
