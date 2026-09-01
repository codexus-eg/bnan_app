import 'dart:io';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_work_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_calculator.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_file_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const gulf = PayrollWorkItemModel(
    curriculumId: 'g',
    curriculumName: '',
    gradeId: 'grade-4',
    gradeName: 'Grade 4',
    system: 'gulf',
    rateType: 'hour',
    minutes: 120,
    displayDuration: '',
    sessionsCount: 0,
    rate: 0,
    amount: 0,
    hasRate: false,
  );
  const egyptian = PayrollWorkItemModel(
    curriculumId: 'e',
    curriculumName: '',
    gradeId: 'grade-6',
    gradeName: 'Grade 6',
    system: 'egyptian',
    rateType: 'hour',
    minutes: 90,
    displayDuration: '',
    sessionsCount: 3,
    rate: 0,
    amount: 0,
    hasRate: false,
  );
  test('calculates every curriculum by grade hourly rate', () {
    expect(PayrollCalculator.item(gulf, 120), 240);
    expect(PayrollCalculator.item(egyptian, 150), 225);
    expect(
      PayrollCalculator.total(
        [gulf, egyptian],
        {'grade-4': 120, 'grade-6': 150},
        50,
        20,
      ),
      495,
    );
  });
  test('rejects missing, unsupported and oversized receipts', () async {
    expect(await PayrollFileValidator.validate('missing.jpg'), 'missing');
    final invalid = File('${Directory.systemTemp.path}/payroll_receipt.txt');
    await invalid.writeAsString('x');
    expect(await PayrollFileValidator.validate(invalid.path), 'type');
    final disguised = File(
      '${Directory.systemTemp.path}/payroll_disguised.jpg',
    );
    await disguised.writeAsString('not an image');
    expect(await PayrollFileValidator.validate(disguised.path), 'type');
    final large = File('${Directory.systemTemp.path}/payroll_receipt.jpg');
    await large.writeAsBytes(List.filled(PayrollFileValidator.maxBytes + 1, 0));
    expect(await PayrollFileValidator.validate(large.path), 'size');
    await invalid.delete();
    await disguised.delete();
    await large.delete();
  });
}
