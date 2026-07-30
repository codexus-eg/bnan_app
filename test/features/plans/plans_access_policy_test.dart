import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_view_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supervisor can manage plans and select a teacher', () {
    final policy = PlansAccessPolicy.fromMode(PlansViewMode.supervisor);

    expect(policy.showManagementActions, isTrue);
    expect(policy.showClassroomFilter, isTrue);
    expect(policy.showTeacherFieldInAddDialog, isTrue);
    expect(policy.isReadOnly, isFalse);
  });

  test('teacher can manage plans without selecting a teacher', () {
    final policy = PlansAccessPolicy.fromMode(PlansViewMode.teacher);

    expect(policy.showManagementActions, isTrue);
    expect(policy.showClassroomFilter, isTrue);
    expect(policy.showTeacherFieldInAddDialog, isFalse);
    expect(policy.isReadOnly, isFalse);
  });

  test('student has a safe read-only policy', () {
    final policy = PlansAccessPolicy.fromMode(PlansViewMode.student);

    expect(policy.showManagementActions, isFalse);
    expect(policy.showClassroomFilter, isFalse);
    expect(policy.showWeekFilter, isTrue);
    expect(policy.canAddDailyPlan, isFalse);
    expect(policy.canUploadPlan, isFalse);
    expect(policy.isReadOnly, isTrue);
  });
}
