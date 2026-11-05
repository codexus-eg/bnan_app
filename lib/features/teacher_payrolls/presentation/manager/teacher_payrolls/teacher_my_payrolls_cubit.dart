import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/payout_profile_model.dart';
import '../../../data/repo/teacher_payroll_repo.dart';
import 'teacher_my_payrolls_state.dart';

class TeacherMyPayrollsCubit extends Cubit<TeacherMyPayrollsState> {
  TeacherMyPayrollsCubit(this.repo) : super(const TeacherMyPayrollsLoading());
  final TeacherPayrollRepo repo;
  bool _busy = false;
  String? _status;
  Future<void> load({String? status, bool refresh = false}) async {
    const allowed = {'draft', 'sent', 'payment_pending', 'paid'};
    if (_busy || (status != null && !allowed.contains(status))) {
      return;
    }
    _busy = true;
    _status = status;
    final old = state is TeacherMyPayrollsReady
        ? state as TeacherMyPayrollsReady
        : null;
    if (old == null) {
      emit(const TeacherMyPayrollsLoading());
    } else {
      emit(
        TeacherMyPayrollsReady(
          data: old.data,
          profile: old.profile,
          status: status,
          updating: true,
        ),
      );
    }
    PayoutProfileModel? profile = old?.profile;
    final profileResult = await repo.getMyPayoutProfile();
    profileResult.fold((_) {}, (value) => profile = value);
    final result = await repo.getMyPayrolls(status: status);
    _busy = false;
    result.fold(
      (failure) => old == null
          ? emit(TeacherMyPayrollsFailure(failure.message))
          : emit(
              TeacherMyPayrollsReady(
                data: old.data,
                profile: old.profile,
                status: _status,
                message: failure.message,
              ),
            ),
      (data) => emit(
        TeacherMyPayrollsReady(data: data, profile: profile, status: _status),
      ),
    );
  }
}
