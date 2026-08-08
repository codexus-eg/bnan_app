import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
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
    expect(model.workItems.single.rate, 120.5);
    expect(model.bonus, 25);
    expect(model.payoutProfile, isNull);
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
