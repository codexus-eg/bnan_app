import 'package:bnan_app/features/plans/presentation/models/plans_view_mode.dart';

class PlansAccessPolicy {
  const PlansAccessPolicy({
    required this.showClassroomFilter,
    required this.showWeekFilter,
    required this.showManagementActions,
    required this.canAddDailyPlan,
    required this.canUploadPlan,
    required this.showTeacherFieldInAddDialog,
    required this.isReadOnly,
  });

  final bool showClassroomFilter;
  final bool showWeekFilter;
  final bool showManagementActions;
  final bool canAddDailyPlan;
  final bool canUploadPlan;
  final bool showTeacherFieldInAddDialog;
  final bool isReadOnly;

  factory PlansAccessPolicy.fromMode(PlansViewMode mode) {
    final isStudent = mode == PlansViewMode.student;
    return PlansAccessPolicy(
      showClassroomFilter: !isStudent,
      showWeekFilter: true,
      showManagementActions: !isStudent,
      canAddDailyPlan: !isStudent,
      canUploadPlan: !isStudent,
      showTeacherFieldInAddDialog: mode == PlansViewMode.supervisor,
      isReadOnly: isStudent,
    );
  }
}
