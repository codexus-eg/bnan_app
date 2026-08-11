import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/teacher_payroll_repo.dart';
import 'teacher_payroll_report_state.dart';

class TeacherPayrollReportCubit extends Cubit<TeacherPayrollReportState> {
  TeacherPayrollReportCubit(this.repo)
    : super(const TeacherPayrollReportLoading());
  final TeacherPayrollRepo repo;

  Future<void> load(String payrollId) async {
    emit(const TeacherPayrollReportLoading());
    final result = await repo.getMyPayroll(payrollId);
    result.fold(
      (failure) => emit(
        TeacherPayrollReportFailure(
          failure.message,
          notFound: failure.statusCode == 404,
        ),
      ),
      (payroll) => emit(TeacherPayrollReportReady(payroll)),
    );
  }
}
