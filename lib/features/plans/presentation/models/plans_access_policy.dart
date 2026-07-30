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
    final canManage = isSupervisor || normalizedRole == 'teacher';
    return PlansAccessPolicy(
      showClassroomFilter: canManage,
      showWeekFilter: true,
      showManagementActions: canManage,
      canAddDailyPlan: canManage,
      canEditPlan: canManage,
      canDeletePlan: canManage,
      canUploadPlan: canManage,
      showTeacherFieldInAddDialog: isSupervisor,
      isReadOnly: !canManage,
    );
  }
}
