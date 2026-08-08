import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_session_details_model.dart';

abstract final class TeacherPayrollSessionsMock {
  // TODO: REMOVE TEACHER PAYROLL MOCK DATA AFTER QA
  static PayrollSessionDetailsModel forCurriculum(String id) =>
      PayrollSessionDetailsModel.fromResponse({
        'data': {
          'sessions': id.contains('egypt') ? _egyptian : _gulf,
          'sessionsCount': id.contains('egypt') ? 3 : 8,
          'totalMinutes': id.contains('egypt') ? 0 : 520,
          'displayDuration': id.contains('egypt') ? '' : '8س 40د',
        },
      });
}

// TODO: REMOVE TEACHER PAYROLL MOCK DATA AFTER QA
final _gulf = [
  _session('رياضيات', '2026-08-05', '16:00', '17:12', 72),
  _session('رياضيات', '2026-08-08', '16:00', '17:00', 60),
  _session('رياضيات', '2026-08-11', '17:30', '18:35', 65),
  _session('رياضيات', '2026-08-14', '16:00', '17:08', 68),
  _session('رياضيات', '2026-08-17', '16:30', '17:40', 70),
  _session('رياضيات', '2026-08-20', '17:00', '18:02', 62),
  _session('رياضيات', '2026-08-24', '16:00', '17:06', 66),
  _session('رياضيات', '2026-08-28', '17:00', '17:57', 57),
];
final _egyptian = [
  _session('اللغة العربية', '2026-08-06', '', '', 0),
  _session('اللغة العربية', '2026-08-13', '', '', 0),
  _session('اللغة العربية', '2026-08-20', '', '', 0),
];
Map<String, dynamic> _session(
  String title,
  String date,
  String start,
  String end,
  int minutes,
) => {
  'title': title,
  'date': date,
  'actualStartedAt': start,
  'actualEndedAt': end,
  'durationMinutes': minutes,
  'status': 'completed',
  'included': true,
};
