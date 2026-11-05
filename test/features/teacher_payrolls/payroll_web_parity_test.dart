import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/existing_statement_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await S.load(const Locale('en'));
  });

  group('1. Teacher Payout Profile Validation', () {
    test('validates wallet method with any provider and valid phone', () {
      const valid = PayoutProfileRequest(
        method: PayoutMethod.wallet,
        accountHolderName: 'Ahmed Ali',
        walletProvider: 'Vodafone Cash',
        walletPhone: '01012345678',
      );
      expect(valid.isValid, isTrue);

      const withCountryCode = PayoutProfileRequest(
        method: PayoutMethod.wallet,
        accountHolderName: 'Ahmed Ali',
        walletProvider: 'Vodafone Cash',
        walletPhone: '+201012345678',
      );
      expect(withCountryCode.isValid, isTrue);
      expect(withCountryCode.toJson()['walletPhone'], '01012345678');

      const saudiPhone = PayoutProfileRequest(
        method: PayoutMethod.wallet,
        accountHolderName: 'Ahmed Ali',
        walletProvider: 'STC Pay',
        walletPhone: '0512345678',
      );
      expect(saudiPhone.isValid, isTrue);

      const invalidPhone = PayoutProfileRequest(
        method: PayoutMethod.wallet,
        accountHolderName: 'Ahmed Ali',
        walletProvider: 'Vodafone Cash',
        walletPhone: '12345',
      );
      expect(invalidPhone.isValid, isFalse);
    });

    test('validates bank_account requiring bankName and account/iban', () {
      const withAccount = PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'Ahmed Ali',
        bankName: 'NBE',
        accountNumber: '1234567890',
      );
      expect(withAccount.isValid, isTrue);

      const withIban = PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'Ahmed Ali',
        bankName: 'NBE',
        iban: 'EG12345678901234567890123456789',
      );
      expect(withIban.isValid, isTrue);

      const missingBoth = PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'Ahmed Ali',
        bankName: 'NBE',
      );
      expect(missingBoth.isValid, isFalse);
    });

    test('validates instapay method', () {
      const valid = PayoutProfileRequest(
        method: PayoutMethod.instapay,
        accountHolderName: 'Ahmed Ali',
        instapayAddress: 'ahmed@instapay',
      );
      expect(valid.isValid, isTrue);

      const invalid = PayoutProfileRequest(
        method: PayoutMethod.instapay,
        accountHolderName: 'Ahmed Ali',
        instapayAddress: '',
      );
      expect(invalid.isValid, isFalse);
    });
  });

  group('2. Statement Overlap Detection', () {
    final existing = ExistingStatementModel(
      id: 'stmt_1',
      teacherId: 't_1',
      curriculumId: 'curr_1',
      from: '2026-10-01',
      to: '2026-10-31',
      status: 'sent',
    );

    test('detects overlapping period correctly', () {
      expect(existing.overlaps('2026-10-15', '2026-11-15'), isTrue);
      expect(existing.overlaps('2026-09-15', '2026-10-05'), isTrue);
      expect(existing.overlaps('2026-10-01', '2026-10-31'), isTrue);
      expect(existing.overlaps('2026-10-10', '2026-10-20'), isTrue);
    });

    test('allows non-overlapping periods', () {
      expect(existing.overlaps('2026-11-01', '2026-11-30'), isFalse);
      expect(existing.overlaps('2026-09-01', '2026-09-30'), isFalse);
    });
  });

  group('3. Create and Patch Payload Parity', () {
    test('Create payload adheres to web contract format and omission rules', () {
      const request = SavePayrollRequest(
        teacherId: 't_1',
        curriculumId: 'curr_1',
        from: '2026-10-01',
        to: '2026-10-31',
        currency: 'EGP',
        academicCurrency: 'EGP',
        courseCurrency: null,
        bonus: 100,
        deduction: 20,
        gradeRates: [
          PayrollGradeRateRequest(gradeId: 'g_1', hourlyRate: 80),
        ],
        courseRates: [],
      );

      final json = request.toJson();
      expect(json['teacherId'], 't_1');
      expect(json['curriculumId'], 'curr_1');
      expect(json['currency'], 'EGP');
      expect(json['academicCurrency'], 'EGP');
      expect(json.containsKey('courseCurrency'), isFalse);
      expect(json['bonuses'], 100);
      expect(json['deductions'], 20);
      expect(json['gradeRates'], isA<List>());
      expect((json['gradeRates'] as List).first['gradeId'], 'g_1');
      expect(json['courseRates'], isEmpty);
    });

    test('Patch payload includes only rates, bonuses, and deductions', () {
      const request = SavePayrollRequest(
        teacherId: 't_1',
        curriculumId: 'curr_1',
        from: '2026-10-01',
        to: '2026-10-31',
        currency: 'EGP',
        bonus: 150,
        deduction: 30,
        gradeRates: [
          PayrollGradeRateRequest(gradeId: 'g_1', hourlyRate: 90),
        ],
        courseRates: [
          PayrollCourseRateRequest(courseId: 'c_1', hourlyRate: 120),
        ],
      );

      final patchJson = request.toPatchJson();
      expect(patchJson.containsKey('teacherId'), isFalse);
      expect(patchJson.containsKey('curriculumId'), isFalse);
      expect(patchJson.containsKey('from'), isFalse);
      expect(patchJson.containsKey('to'), isFalse);
      expect(patchJson.containsKey('currency'), isFalse);
      expect(patchJson['bonuses'], 150);
      expect(patchJson['deductions'], 30);
      expect(patchJson['gradeRates'], hasLength(1));
      expect(patchJson['courseRates'], hasLength(1));
    });
  });

  group('4. Lifecycle Rules & Permissions', () {
    test('Draft editing allowed only when draft, unspent, and unpaid', () {
      final editable = TeacherPayrollModel.fromResponse({
        'id': 's_1',
        'status': 'draft',
        'sentAt': null,
        'payment': null,
      });
      expect(editable.isDraftEditable, isTrue);

      final sentDraft = TeacherPayrollModel.fromResponse({
        'id': 's_1',
        'status': 'draft',
        'sentAt': '2026-10-25T10:00:00.000Z',
        'payment': null,
      });
      expect(sentDraft.isDraftEditable, isFalse);

      final nonDraft = TeacherPayrollModel.fromResponse({
        'id': 's_1',
        'status': 'sent',
      });
      expect(nonDraft.isDraftEditable, isFalse);
    });

    test('Payment recording allowed only for sent or payment_pending', () {
      final draft = TeacherPayrollModel.fromResponse({'id': '1', 'status': 'draft'});
      final sent = TeacherPayrollModel.fromResponse({'id': '2', 'status': 'sent'});
      final pending = TeacherPayrollModel.fromResponse({'id': '3', 'status': 'payment_pending'});
      final paid = TeacherPayrollModel.fromResponse({'id': '4', 'status': 'paid'});

      expect(draft.isPayable, isFalse);
      expect(sent.isPayable, isTrue);
      expect(pending.isPayable, isTrue);
      expect(paid.isPayable, isFalse);
    });

    test('Deletion allowed for draft or unpaid sent, forbidden for paid', () {
      final draft = TeacherPayrollModel.fromResponse({'id': '1', 'status': 'draft'});
      final sent = TeacherPayrollModel.fromResponse({'id': '2', 'status': 'sent'});
      final paid = TeacherPayrollModel.fromResponse({'id': '3', 'status': 'paid'});

      expect(draft.isDeletable, isTrue);
      expect(sent.isDeletable, isTrue);
      expect(paid.isDeletable, isFalse);
    });

    test('Payment model correctly parses hasReceipt', () {
      final withReceipt = PayrollPaymentModel.fromJson({
        'method': 'bank_account',
        'hasReceipt': true,
      });
      expect(withReceipt.hasReceipt, isTrue);

      final withoutReceipt = PayrollPaymentModel.fromJson({
        'method': 'bank_account',
        'hasReceipt': false,
      });
      expect(withoutReceipt.hasReceipt, isFalse);
    });
  });

  group('5. Preview Session Parsing & Excluded Sessions', () {
    test('parses excluded sessions with reasons', () {
      final model = PayrollListItemModel.fromJson({
        'teacherId': 't_1',
        'fullName': 'Mohamed Ali',
        'email': 'mohamed@test.com',
        'excludedSessionsCount': 2,
        'excludedSessions': [
          {
            'title': 'Session 1',
            'exclusionReason': 'Missing attendance data',
            'date': '2026-10-10',
          },
        ],
        'general': {
          'displayDuration': '4h 30m',
        },
        'courses': [
          {'title': 'Math Course'},
        ],
      });

      expect(model.teacherId, 't_1');
      expect(model.fullName, 'Mohamed Ali');
      expect(model.excludedSessionsCount, 2);
      expect(model.excludedSessionsList.first.exclusionReason, 'Missing attendance data');
      expect(model.generalDuration, '4h 30m');
    });
  });

  group('6. Centralized Error Handling for All 18 Payroll Error Codes', () {
    final codes = [
      'PAYROLL_PERIOD_REQUIRED',
      'INVALID_PAYROLL_PERIOD',
      'INVALID_PAYROLL_STATEMENT_CURRENCY',
      'PAYROLL_STATEMENT_CURRENCY_MISMATCH',
      'INVALID_PAYROLL_STATEMENT_RATE',
      'INVALID_PAYROLL_STATEMENT_AMOUNT',
      'PAYROLL_TEACHER_NOT_IN_CURRICULUM',
      'PAYROLL_STATEMENT_EXISTS',
      'PAYROLL_STATEMENT_PERIOD_OVERLAP',
      'PAYROLL_STATEMENT_NOT_EDITABLE',
      'PAYOUT_PROFILE_REQUIRED',
      'PAYROLL_RECEIPT_REQUIRED',
      'INVALID_PAYROLL_PAYMENT_DATE',
      'PAYROLL_STATEMENT_NOT_PAYABLE',
      'PAYROLL_STATEMENT_PAID',
      'PAYROLL_STATEMENT_NOT_FOUND',
      'PAYROLL_RECEIPT_NOT_FOUND',
      'PAYROLL_RECEIPT_FORBIDDEN',
    ];

    for (final code in codes) {
      test('maps $code to a specific friendly error message', () {
        final dioError = DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 400,
            data: {'errorCode': code, 'message': 'Original $code'},
          ),
        );
        final exception = AppException.fromDio(dioError);
        expect(exception.message, isNotEmpty);
        expect(exception.message, isNot(contains('Original $code')));
      });
    }
  });
}
