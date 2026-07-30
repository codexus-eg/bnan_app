import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supervisor can manage plans and select a teacher', () {
    final policy = PlansAccessPolicy.fromRole('supervisor');

    expect(policy.showManagementActions, isTrue);
    expect(policy.canEditPlan, isTrue);
    expect(policy.canDeletePlan, isTrue);
    expect(policy.showClassroomFilter, isTrue);
    expect(policy.showTeacherFieldInAddDialog, isTrue);
    expect(policy.isReadOnly, isFalse);
  });

  test('teacher can manage plans without selecting a teacher', () {
    final policy = PlansAccessPolicy.fromRole('teacher');

    expect(policy.showManagementActions, isTrue);
    expect(policy.canEditPlan, isTrue);
    expect(policy.canDeletePlan, isTrue);
    expect(policy.showClassroomFilter, isTrue);
    expect(policy.showTeacherFieldInAddDialog, isFalse);
    expect(policy.isReadOnly, isFalse);
  });

  test('student has a safe read-only policy', () {
    final policy = PlansAccessPolicy.fromRole('student');

    expect(policy.showManagementActions, isFalse);
    expect(policy.showClassroomFilter, isFalse);
    expect(policy.showWeekFilter, isTrue);
    expect(policy.canAddDailyPlan, isFalse);
    expect(policy.canEditPlan, isFalse);
    expect(policy.canDeletePlan, isFalse);
    expect(policy.canUploadPlan, isFalse);
    expect(policy.isReadOnly, isTrue);
  });
}
