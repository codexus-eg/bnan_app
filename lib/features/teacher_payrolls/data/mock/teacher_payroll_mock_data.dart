import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';

abstract final class TeacherPayrollMockData {
  // TODO: REMOVE TEACHER PAYROLL MOCK DATA AFTER QA
  static const teachers = [
    PayrollTeacherModel(
      id: 'qa-ahmed',
      fullName: 'أحمد محمد',
      email: 'ahmed.teacher@bnan.com',
      phone: '01011111111',
    ),
    PayrollTeacherModel(
      id: 'qa-mohamed',
      fullName: 'محمد علي',
      email: 'mohamed.ali@bnan.com',
      phone: '01000000000',
    ),
    PayrollTeacherModel(
      id: 'qa-sara',
      fullName: 'سارة محمود',
      email: 'sara.teacher@bnan.com',
      phone: '01022222222',
    ),
    PayrollTeacherModel(
      id: 'qa-mona',
      fullName: 'منى إبراهيم',
      email: 'mona.teacher@bnan.com',
      phone: '',
    ),
    PayrollTeacherModel(
      id: 'qa-khaled',
      fullName: 'خالد حسن',
      email: 'khaled.teacher@bnan.com',
      phone: '',
    ),
  ];

  // TODO: REMOVE TEACHER PAYROLL MOCK DATA AFTER QA
  static const list = [
    PayrollListItemModel(
      teacherId: 'qa-ahmed',
      fullName: 'أحمد محمد',
      email: 'ahmed.teacher@bnan.com',
      status: 'unprepared',
      payrollId: '',
      gulfDuration: '12س 35د',
      egyptianSessions: 14,
      curriculumsCount: 3,
      excludedSessions: 1,
    ),
    PayrollListItemModel(
      teacherId: 'qa-mohamed',
      fullName: 'محمد علي',
      email: 'mohamed.ali@bnan.com',
      status: 'draft',
      payrollId: 'qa-draft',
      gulfDuration: '',
      egyptianSessions: 20,
      curriculumsCount: 1,
      excludedSessions: 0,
    ),
    PayrollListItemModel(
      teacherId: 'qa-sara',
      fullName: 'سارة محمود',
      email: 'sara.teacher@bnan.com',
      status: 'paid',
      payrollId: 'qa-paid',
      gulfDuration: '11س',
      egyptianSessions: 0,
      curriculumsCount: 1,
      excludedSessions: 0,
    ),
    PayrollListItemModel(
      teacherId: 'qa-mona',
      fullName: 'منى إبراهيم',
      email: 'mona.teacher@bnan.com',
      status: 'cancelled',
      payrollId: 'qa-cancelled',
      gulfDuration: '',
      egyptianSessions: 6,
      curriculumsCount: 1,
      excludedSessions: 0,
    ),
    PayrollListItemModel(
      teacherId: 'qa-khaled',
      fullName: 'خالد حسن',
      email: 'khaled.teacher@bnan.com',
      status: 'unprepared',
      payrollId: '',
      gulfDuration: '',
      egyptianSessions: 0,
      curriculumsCount: 0,
      excludedSessions: 0,
    ),
  ];

  static TeacherPayrollModel forTeacher(String id) => switch (id) {
    'qa-ahmed' => _ahmed,
    'qa-khaled' => _khaled,
    _ => _khaled,
  };

  static TeacherPayrollModel forPayroll(String id) => switch (id) {
    'qa-draft' => _mohamed,
    'qa-paid' => _sara,
    'qa-cancelled' => _mona,
    _ => _khaled,
  };

  static PayoutProfileModel payout(PayoutProfileRequest request) =>
      PayoutProfileModel.fromJson({
        ...request.toJson(),
        'updatedAt': '2026-08-31T12:00:00.000Z',
      });

  static TeacherPayrollModel paidAfterQa(String id) =>
      id == 'qa-draft' ? _mohamedPaid : _sara;

  static TeacherPayrollModel savedDraft(
    TeacherPayrollModel current,
    SavePayrollRequest request,
  ) {
    final rates = {
      for (final value in request.rates) value.curriculumId: value.rate,
    };
    final work = current.workItems.map((item) {
      final rate = rates[item.curriculumId] ?? 0;
      final amount = item.system == 'gulf'
          ? item.minutes * rate / 60
          : item.sessionsCount * rate;
      return {
        'curriculumId': item.curriculumId,
        'curriculumName': item.curriculumName,
        'system': item.system,
        'minutes': item.minutes,
        'displayDuration': item.displayDuration,
        'sessionsCount': item.sessionsCount,
        'rate': rate,
        'amount': amount,
      };
    }).toList();
    final subtotal = work.fold<double>(
      0,
      (sum, item) => sum + (item['amount'] as num).toDouble(),
    );
    return TeacherPayrollModel.fromResponse({
      'data': {
        'id': current.id.isEmpty ? 'qa-created' : current.id,
        'status': 'draft',
        'teacher': {
          'id': current.teacher.id,
          'fullName': current.teacher.fullName,
          'email': current.teacher.email,
        },
        'period': current.period.toJson(),
        'currency': request.currency,
        'workItems': work,
        'bonus': request.bonus,
        'deduction': request.deduction,
        'adjustmentNote': request.adjustmentNote,
        'notes': request.notes,
        'totals': {
          'subtotal': subtotal,
          'bonus': request.bonus,
          'deduction': request.deduction,
          'total': subtotal + request.bonus - request.deduction,
        },
        'payoutProfile': _profileJson(current.payoutProfile),
      },
    });
  }
}

// TODO: REMOVE TEACHER PAYROLL MOCK DATA AFTER QA
final _ahmed = TeacherPayrollModel.fromResponse({
  'data': {
    'status': 'unprepared',
    'teacher': {
      'id': 'qa-ahmed',
      'fullName': 'أحمد محمد',
      'email': 'ahmed.teacher@bnan.com',
    },
    'period': {'from': '2026-08-01', 'to': '2026-08-31'},
    'excludedSessionsCount': 1,
    'warnings': ['توجد حصة مستبعدة لعدم اكتمال بيانات المدة.'],
    'payoutProfile': {
      'method': 'instapay',
      'accountHolderName': 'أحمد محمد',
      'instapayAddress': 'ahmed@instapay',
    },
    'workItems': [
      _work('qa-saudi', 'المنهج السعودي', 'gulf', 520, '8س 40د', 8),
      _work('qa-kuwait', 'المنهج الكويتي', 'gulf', 235, '3س 55د', 4),
      _work('qa-egypt', 'المنهج المصري', 'egyptian', 0, '', 14),
    ],
  },
});

final _mohamed = _payroll(
  'qa-draft',
  'draft',
  'qa-mohamed',
  'محمد علي',
  'mohamed.ali@bnan.com',
  'EGP',
  _work(
    'qa-egypt-draft',
    'المنهج المصري',
    'egyptian',
    0,
    '',
    20,
    rate: 150,
    amount: 3000,
  ),
  bonus: 200,
  deduction: 100,
  total: 3100,
  profile: {
    'method': 'wallet',
    'accountHolderName': 'محمد علي',
    'walletProvider': 'Vodafone Cash',
    'walletPhone': '01000000000',
  },
);
final _sara = _payroll(
  'qa-paid',
  'paid',
  'qa-sara',
  'سارة محمود',
  'sara.teacher@bnan.com',
  'SAR',
  _work(
    'qa-saudi-paid',
    'المنهج السعودي',
    'gulf',
    660,
    '11 ساعة',
    9,
    rate: 120,
    amount: 1320,
  ),
  bonus: 100,
  total: 1420,
  payment: _bankPayment,
);
final _mona = _payroll(
  'qa-cancelled',
  'cancelled',
  'qa-mona',
  'منى إبراهيم',
  'mona.teacher@bnan.com',
  'EGP',
  _work(
    'qa-egypt-cancelled',
    'المنهج المصري',
    'egyptian',
    0,
    '',
    6,
    rate: 100,
    amount: 600,
  ),
  total: 600,
);
final _khaled = TeacherPayrollModel.fromResponse({
  'data': {
    'status': 'unprepared',
    'teacher': {
      'id': 'qa-khaled',
      'fullName': 'خالد حسن',
      'email': 'khaled.teacher@bnan.com',
    },
    'period': {'from': '2026-08-01', 'to': '2026-08-31'},
    'workItems': [],
  },
});
final _mohamedPaid = _payroll(
  'qa-draft',
  'paid',
  'qa-mohamed',
  'محمد علي',
  'mohamed.ali@bnan.com',
  'EGP',
  _work(
    'qa-egypt-draft',
    'المنهج المصري',
    'egyptian',
    0,
    '',
    20,
    rate: 150,
    amount: 3000,
  ),
  bonus: 200,
  deduction: 100,
  total: 3100,
  payment: {
    'method': 'wallet',
    'paidAt': '2026-08-31T14:00:00.000Z',
    'destinationSnapshot': {
      'method': 'wallet',
      'accountHolderName': 'محمد علي',
      'walletProvider': 'Vodafone Cash',
      'walletPhone': '01000000000',
    },
  },
);

Map<String, dynamic> _work(
  String id,
  String name,
  String system,
  int minutes,
  String duration,
  int sessions, {
  double rate = 0,
  double amount = 0,
}) => {
  'curriculumId': id,
  'curriculumName': name,
  'system': system,
  'minutes': minutes,
  'displayDuration': duration,
  'sessionsCount': sessions,
  'rate': rate,
  'amount': amount,
};
TeacherPayrollModel _payroll(
  String id,
  String status,
  String teacherId,
  String name,
  String email,
  String currency,
  Map<String, dynamic> work, {
  double bonus = 0,
  double deduction = 0,
  double total = 0,
  Map<String, dynamic>? profile,
  Map<String, dynamic>? payment,
}) => TeacherPayrollModel.fromResponse({
  'data': {
    'id': id,
    'status': status,
    'teacher': {'id': teacherId, 'fullName': name, 'email': email},
    'period': {'from': '2026-08-01', 'to': '2026-08-31'},
    'currency': currency,
    'workItems': [work],
    'bonus': bonus,
    'deduction': deduction,
    'totals': {
      'subtotal': total - bonus + deduction,
      'bonus': bonus,
      'deduction': deduction,
      'total': total,
    },
    'payoutProfile': profile,
    'payment': payment,
  },
});
const _bankPayment = {
  'method': 'bank_account',
  'paidAt': '2026-08-31T13:30:00.000Z',
  'transactionReference': 'BNAN-PAY-4587',
  'paidAmount': 1420,
  'destinationSnapshot': {
    'method': 'bank_account',
    'accountHolderName': 'سارة محمود',
    'bankName': 'CIB',
    'accountNumber': '123456789',
    'iban': 'EG380019000500000000263180002',
  },
  'receiptUrl': null,
};
Map<String, dynamic>? _profileJson(PayoutProfileModel? value) => value == null
    ? null
    : {
        'method': value.method,
        'accountHolderName': value.accountHolderName,
        'instapayAddress': value.instapayAddress,
        'walletProvider': value.walletProvider,
        'walletPhone': value.walletPhone,
        'bankName': value.bankName,
        'accountNumber': value.accountNumber,
        'iban': value.iban,
      };
