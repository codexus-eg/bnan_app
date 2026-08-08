import 'dart:io';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_work_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_calculator.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_file_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const gulf = PayrollWorkItemModel(
    curriculumId: 'g',
    curriculumName: '',
    system: 'gulf',
    minutes: 90,
    displayDuration: '',
    sessionsCount: 0,
    rate: 0,
    amount: 0,
  );
  const egyptian = PayrollWorkItemModel(
    curriculumId: 'e',
    curriculumName: '',
    system: 'egyptian',
    minutes: 0,
    displayDuration: '',
    sessionsCount: 3,
    rate: 0,
    amount: 0,
  );
  test('calculates gulf, egyptian, bonus and deduction decimals', () {
    expect(PayrollCalculator.item(gulf, 100.5), 150.75);
    expect(
      PayrollCalculator.total([gulf, egyptian], {'g': 100.5, 'e': 20}, 10, 5),
      215.75,
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
