import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';

sealed class TeacherPayrollDetailsState {
  const TeacherPayrollDetailsState();
}

class TeacherPayrollDetailsInitial extends TeacherPayrollDetailsState {
  const TeacherPayrollDetailsInitial();
}

class TeacherPayrollDetailsLoading extends TeacherPayrollDetailsState {
  const TeacherPayrollDetailsLoading();
}

class TeacherPayrollDetailsReady extends TeacherPayrollDetailsState {
  const TeacherPayrollDetailsReady(
    this.payroll,
    this.profile, {
    this.saving = false,
    this.error,
  });
  final TeacherPayrollModel payroll;
  final PayoutProfileModel? profile;
  final bool saving;
  final String? error;
}

class TeacherPayrollDetailsFailure extends TeacherPayrollDetailsState {
  const TeacherPayrollDetailsFailure(this.message);
  final String message;
}
