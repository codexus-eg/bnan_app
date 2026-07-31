class PlansAccessPolicy {
  const PlansAccessPolicy({
    required this.showClassroomFilter,
    required this.showWeekFilter,
    required this.showManagementActions,
    required this.canAddDailyPlan,
    required this.canEditPlan,
    required this.canDeletePlan,
    required this.canUploadPlan,
    required this.showTeacherFieldInAddDialog,
    required this.isReadOnly,
  });

  final bool showClassroomFilter;
  final bool showWeekFilter;
  final bool showManagementActions;
  final bool canAddDailyPlan;
  final bool canEditPlan;
  final bool canDeletePlan;
  final bool canUploadPlan;
  final bool showTeacherFieldInAddDialog;
  final bool isReadOnly;

  factory PlansAccessPolicy.fromRole(String? role) {
    final normalizedRole = role?.trim().toLowerCase();
    final isSupervisor = normalizedRole == 'supervisor';
    final isAdmin = normalizedRole == 'admin';
    final canManage = isSupervisor || isAdmin || normalizedRole == 'teacher';
    final hasClassrooms = canManage || normalizedRole == 'student';
    return PlansAccessPolicy(
      showClassroomFilter: hasClassrooms,
      showWeekFilter: true,
      showManagementActions: canManage,
      canAddDailyPlan: canManage,
      canEditPlan: canManage,
      canDeletePlan: canManage,
      canUploadPlan: canManage,
      showTeacherFieldInAddDialog: isSupervisor || isAdmin,
      isReadOnly: !canManage,
    );
  }
}
