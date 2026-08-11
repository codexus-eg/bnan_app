import '../../../data/models/teacher_payroll_model.dart';

sealed class TeacherPayrollReportState {
  const TeacherPayrollReportState();
}

class TeacherPayrollReportLoading extends TeacherPayrollReportState {
  const TeacherPayrollReportLoading();
}

class TeacherPayrollReportReady extends TeacherPayrollReportState {
  const TeacherPayrollReportReady(this.payroll);
  final TeacherPayrollModel payroll;
}

class TeacherPayrollReportFailure extends TeacherPayrollReportState {
  const TeacherPayrollReportFailure(this.message, {this.notFound = false});
  final String message;
  final bool notFound;
}
