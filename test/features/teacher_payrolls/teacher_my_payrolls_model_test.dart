import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_my_payrolls_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses payroll list and multi-currency summary array', () {
    final model = TeacherMyPayrollsModel.fromResponse({
      'data': {
        'summary': [
          {
            'currency': 'EGP',
            'draftAmount': 10,
            'paidAmount': 20,
            'totalAmount': 30,
            'payrollsCount': 2,
          },
          {
            'currency': 'SAR',
            'paidAmount': 5,
            'totalAmount': 5,
            'payrollsCount': 1,
          },
        ],
        'payrolls': [
          {
            'id': 'p1',
            'status': 'draft',
            'period': {'from': '2026-08-01', 'to': '2026-08-31'},
          },
        ],
      },
    });
    expect(model.summary, hasLength(2));
    expect(model.summary.last.currency, 'SAR');
    expect(model.summary.first.totalAmount, 30);
    expect(model.payrolls.single.id, 'p1');
  });

  test('accepts empty summary and payrolls', () {
    final model = TeacherMyPayrollsModel.fromResponse({
      'data': {'summary': [], 'payrolls': []},
    });
    expect(model.summary, isEmpty);
    expect(model.payrolls, isEmpty);
  });

  test('parses paid destination snapshot and nullable receipt', () {
    final model = TeacherMyPayrollsModel.fromResponse({
      'data': {
        'payrolls': [
          {
            'id': 'p2',
            'status': 'paid',
            'payment': {
              'method': 'instapay',
              'receiptUrl': null,
              'destinationSnapshot': {
                'method': 'instapay',
                'instapayAddress': 'teacher@instapay',
              },
            },
          },
        ],
      },
    });
    final payment = model.payrolls.single.payment!;
    expect(payment.destinationSnapshot?.instapayAddress, 'teacher@instapay');
    expect(payment.receiptUrl, isEmpty);
  });

  test('parses draft payment null', () {
    final model = TeacherMyPayrollsModel.fromResponse({
      'data': {
        'payrolls': [
          {'id': 'p1', 'status': 'draft', 'payment': null},
        ],
      },
    });
    expect(model.payrolls.single.payment, isNull);
  });
}
