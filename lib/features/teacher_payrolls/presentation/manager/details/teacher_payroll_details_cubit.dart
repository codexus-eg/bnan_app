import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_payroll_details_state.dart';

class TeacherPayrollDetailsCubit extends Cubit<TeacherPayrollDetailsState> {
  TeacherPayrollDetailsCubit(this.repo)
    : super(const TeacherPayrollDetailsInitial());
  final TeacherPayrollRepo repo;
  bool _busy = false;
  Future<void> loadPreview({
    required String teacherId,
    required String from,
    required String to,
  }) async {
    if (isClosed || _busy) return;
    _busy = true;
    emit(const TeacherPayrollDetailsLoading());
    final result = await repo.getTeacherPreview(
      teacherId: teacherId,
      from: from,
      to: to,
    );
    _busy = false;
    if (isClosed) return;
    result.fold(
      (f) {
        if (isClosed) return;
        emit(TeacherPayrollDetailsFailure(f.message));
      },
      (p) {
        if (isClosed) return;
        emit(TeacherPayrollDetailsReady(p, p.payoutProfile));
      },
    );
  }

  Future<void> loadPayroll(String id) async {
    if (isClosed || _busy) return;
    _busy = true;
    emit(const TeacherPayrollDetailsLoading());
    final result = await repo.getPayroll(id);
    if (isClosed) return;
    await result.fold(
      (f) async {
        if (isClosed) return;
        emit(TeacherPayrollDetailsFailure(f.message));
      },
      (p) async {
        if (isClosed) return;
        PayoutProfileModel? profile;
        if (p.status == 'draft' &&
            p.teacher.id.isNotEmpty &&
            p.period.from.isNotEmpty) {
          final previewResult = await repo.getTeacherPreview(
            teacherId: p.teacher.id,
            from: p.period.from,
            to: p.period.to,
          );
          if (isClosed) return;
          previewResult.fold((_) {}, (preview) {
            if (isClosed) return;
            profile = preview.payoutProfile;
          });
        }
        if (isClosed) return;
        emit(TeacherPayrollDetailsReady(p, profile));
      },
    );
    _busy = false;
  }

  Future<void> save(SavePayrollRequest request) async {
    if (isClosed) return;
    final current = state;
    if (_busy || current is! TeacherPayrollDetailsReady) return;
    _busy = true;
    emit(
      TeacherPayrollDetailsReady(
        current.payroll,
        current.profile,
        saving: true,
      ),
    );
    final result = current.payroll.id.isEmpty
        ? await repo.create(request)
        : await repo.update(current.payroll.id, request);
    _busy = false;
    if (isClosed) return;
    await result.fold(
      (f) async {
        if (isClosed) return;
        final shouldReload =
            current.payroll.id.isNotEmpty &&
            (f.code == 'PAID_PAYROLL_IMMUTABLE' ||
                f.code == 'PAYROLL_SESSIONS_ALREADY_USED');
        if (!shouldReload) {
          if (isClosed) return;
          emit(
            TeacherPayrollDetailsReady(
              current.payroll,
              current.profile,
              error: f.message,
            ),
          );
          return;
        }
        final latestResult = await repo.getPayroll(current.payroll.id);
        if (isClosed) return;
        latestResult.fold(
          (_) {
            if (isClosed) return;
            emit(
              TeacherPayrollDetailsReady(
                current.payroll,
                current.profile,
                error: f.message,
              ),
            );
          },
          (latest) {
            if (isClosed) return;
            emit(
              TeacherPayrollDetailsReady(
                latest,
                current.profile,
                error: f.message,
              ),
            );
          },
        );
      },
      (p) async {
        if (isClosed) return;
        emit(TeacherPayrollDetailsReady(p, current.profile));
      },
    );
  }

  void updateProfile(PayoutProfileModel profile) {
    if (isClosed) return;
    final current = state;
    if (current is TeacherPayrollDetailsReady) {
      emit(TeacherPayrollDetailsReady(current.payroll, profile));
    }
  }

  void replacePayroll(TeacherPayrollModel payroll) {
    if (isClosed) return;
    final current = state;
    final profile = current is TeacherPayrollDetailsReady
        ? current.profile
        : null;
    emit(TeacherPayrollDetailsReady(payroll, profile));
  }

  Future<void> sendStatement() async {
    if (isClosed) return;
    final current = state;
    if (_busy || current is! TeacherPayrollDetailsReady) return;
    if (current.payroll.id.isEmpty) return;
    _busy = true;
    emit(
      TeacherPayrollDetailsReady(
        current.payroll,
        current.profile,
        saving: true,
      ),
    );
    final result = await repo.sendStatement(current.payroll.id);
    _busy = false;
    if (isClosed) return;
    result.fold(
      (f) => emit(
        TeacherPayrollDetailsReady(
          current.payroll,
          current.profile,
          error: f.message,
        ),
      ),
      (updated) => emit(TeacherPayrollDetailsReady(updated, current.profile)),
    );
  }

  Future<bool> deleteStatement() async {
    if (isClosed) return false;
    final current = state;
    if (_busy || current is! TeacherPayrollDetailsReady) return false;
    if (current.payroll.id.isEmpty) return false;
    _busy = true;
    emit(
      TeacherPayrollDetailsReady(
        current.payroll,
        current.profile,
        saving: true,
      ),
    );
    final result = await repo.deleteStatement(current.payroll.id);
    _busy = false;
    if (isClosed) return false;
    return result.fold(
      (f) {
        emit(
          TeacherPayrollDetailsReady(
            current.payroll,
            current.profile,
            error: f.message,
          ),
        );
        return false;
      },
      (_) => true,
    );
  }
}
