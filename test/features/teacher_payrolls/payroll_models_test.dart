import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses numeric strings and a null payout profile defensively', () {
    final model = TeacherPayrollModel.fromResponse({
      'data': {
        'teacherId': 't1',
        'period': {'from': '2026-08-01', 'to': '2026-08-31'},
        'workItems': [
          {
            'curriculumId': 'c1',
            'gradeId': 'g4',
            'gradeName': 'Grade 4',
            'rateType': 'hour',
            'system': 'gulf',
            'minutes': '90',
            'rate': '120.5',
            'amount': '180.75',
          },
        ],
        'bonus': '25',
        'payoutProfile': null,
      },
    });
    expect(model.workItems.single.minutes, 90);
    expect(model.workItems.single.gradeId, 'g4');
    expect(model.workItems.single.rate, 120.5);
    expect(model.workItems.single.hasRate, isTrue);
    expect(model.bonus, 25);
    expect(model.payoutProfile, isNull);
  });

  test('serializes payroll rates by grade', () {
    const request = PayrollRateRequest('g4', 120);
    expect(request.toJson(), {'gradeId': 'g4', 'rate': 120});
  });

  test('parses excluded sessions warning count', () {
    final model = TeacherPayrollModel.fromResponse({
      'data': {
        'warnings': [
          {'code': 'PAYROLL_SESSIONS_EXCLUDED', 'count': 2},
        ],
      },
    });
    expect(model.excludedSessions, 2);
    expect(model.warnings, isEmpty);
  });

  test('parses all payout methods without requiring identity fields', () {
    for (final json in [
      {
        'method': 'instapay',
        'accountHolderName': 'A',
        'instapayAddress': 'a@instapay',
      },
      {
        'method': 'wallet',
        'accountHolderName': 'B',
        'walletProvider': 'cash',
        'walletPhone': '010',
      },
      {
        'method': 'bank_account',
        'accountHolderName': 'C',
        'bankName': 'CIB',
        'iban': 'EG1',
      },
    ]) {
      expect(PayoutProfileModel.fromJson(json).method, json['method']);
    }
  });

  test('paid payroll uses destination snapshot', () {
    final model = TeacherPayrollModel.fromResponse({
      'data': {
        'status': 'paid',
        'payment': {
          'destinationSnapshot': {
            'method': 'instapay',
            'accountHolderName': 'Historical',
            'instapayAddress': 'old@instapay',
          },
        },
      },
    });
    expect(model.payment!.destinationSnapshot!.accountHolderName, 'Historical');
  });
}
