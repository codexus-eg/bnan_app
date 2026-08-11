import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_config.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_data.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_sessions_mock.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA flag is enabled and list covers all payroll states', () {
    expect(kUseTeacherPayrollMockData, isTrue);
    expect(
      TeacherPayrollMockData.list.map((e) => e.status).toSet(),
      containsAll(['unprepared', 'draft', 'paid', 'cancelled']),
    );
    expect(TeacherPayrollMockData.list.length, 5);
  });
  test('mixed preview and no-work preview cover edge cases', () {
    final mixed = TeacherPayrollMockData.forTeacher('qa-ahmed');
    expect(mixed.workItems.length, 3);
    expect(mixed.excludedSessions, 1);
    expect(TeacherPayrollMockData.forTeacher('qa-khaled').workItems, isEmpty);
  });
  test('gulf sessions contain eight entries totaling 520 minutes', () {
    final details = TeacherPayrollSessionsMock.forCurriculum('qa-saudi');
    expect(details.sessions.length, 8);
    expect(
      details.sessions.fold<int>(0, (sum, item) => sum + item.durationMinutes),
      520,
    );
  });
  test('mock draft save stays local and calculates returned total', () {
    final preview = TeacherPayrollMockData.forTeacher('qa-ahmed');
    final saved = TeacherPayrollMockData.savedDraft(
      preview,
      SavePayrollRequest(
        currency: 'EGP',
        rates: preview.workItems
            .map((e) => PayrollRateRequest(e.curriculumId, 60))
            .toList(),
        bonus: 100,
        deduction: 50,
        adjustmentNote: '',
        notes: '',
      ),
    );
    expect(saved.status, 'draft');
    expect(saved.id, 'qa-created');
    expect(saved.totals.total, greaterThan(0));
  });
  test('paid mock tolerates a missing receipt URL', () {
    final paid = TeacherPayrollMockData.forPayroll('qa-paid');
    expect(paid.payment, isNotNull);
    expect(paid.payment!.receiptUrl, isEmpty);
  });
}
