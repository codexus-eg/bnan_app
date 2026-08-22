import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_payout_profile_state.dart';

class TeacherPayoutProfileCubit extends Cubit<TeacherPayoutProfileState> {
  TeacherPayoutProfileCubit(this.repo)
    : super(const TeacherPayoutProfileInitial());
  final TeacherPayrollRepo repo;
  bool _saving = false;
  Future<void> save(String teacherId, PayoutProfileRequest request) async {
    if (isClosed || _saving || !request.isValid) return;
    _saving = true;
    emit(const TeacherPayoutProfileSaving());
    final result = await repo.updatePayoutProfile(teacherId, request);
    _saving = false;
    if (isClosed) return;
    result.fold(
      (f) {
        if (isClosed) return;
        emit(TeacherPayoutProfileFailure(f.message));
      },
      (p) {
        if (isClosed) return;
        emit(TeacherPayoutProfileSuccess(p));
      },
    );
  }
}
