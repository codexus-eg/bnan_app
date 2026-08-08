import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payroll_sessions_state.dart';

class PayrollSessionsCubit extends Cubit<PayrollSessionsState> {
  PayrollSessionsCubit(this.repo) : super(const PayrollSessionsInitial());
  final TeacherPayrollRepo repo;
  Future<void> load({
    required String teacherId,
    required String curriculumId,
    required String from,
    required String to,
  }) async {
    emit(const PayrollSessionsLoading());
    final result = await repo.getSessions(
      teacherId: teacherId,
      curriculumId: curriculumId,
      from: from,
      to: to,
    );
    result.fold(
      (f) => emit(PayrollSessionsFailure(f.message)),
      (v) => emit(PayrollSessionsSuccess(v)),
    );
  }
}
