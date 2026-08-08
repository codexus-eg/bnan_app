import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_config.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_data.dart';
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
    if (_busy) return;
    if (kUseTeacherPayrollMockData) {
      final payroll = TeacherPayrollMockData.forTeacher(teacherId);
      emit(TeacherPayrollDetailsReady(payroll, payroll.payoutProfile));
      return;
    }
    _busy = true;
    emit(const TeacherPayrollDetailsLoading());
    final result = await repo.getTeacherPreview(
      teacherId: teacherId,
      from: from,
      to: to,
    );
    _busy = false;
    result.fold(
      (f) => emit(TeacherPayrollDetailsFailure(f.message)),
      (p) => emit(TeacherPayrollDetailsReady(p, p.payoutProfile)),
    );
  }

  Future<void> loadPayroll(String id) async {
    if (_busy) return;
    if (kUseTeacherPayrollMockData) {
      final payroll = TeacherPayrollMockData.forPayroll(id);
      emit(TeacherPayrollDetailsReady(payroll, payroll.payoutProfile));
      return;
    }
    _busy = true;
    emit(const TeacherPayrollDetailsLoading());
    final result = await repo.getPayroll(id);
    await result.fold(
      (f) async => emit(TeacherPayrollDetailsFailure(f.message)),
      (p) async {
        PayoutProfileModel? profile;
        if (p.status == 'draft' &&
            p.teacher.id.isNotEmpty &&
            p.period.from.isNotEmpty) {
          (await repo.getTeacherPreview(
            teacherId: p.teacher.id,
            from: p.period.from,
            to: p.period.to,
          )).fold((_) {}, (preview) => profile = preview.payoutProfile);
        }
        emit(TeacherPayrollDetailsReady(p, profile));
      },
    );
    _busy = false;
  }

  Future<void> save(SavePayrollRequest request) async {
    final current = state;
    if (_busy || current is! TeacherPayrollDetailsReady) return;
    if (kUseTeacherPayrollMockData) {
      final payroll = TeacherPayrollMockData.savedDraft(
        current.payroll,
        request,
      );
      emit(TeacherPayrollDetailsReady(payroll, current.profile));
      return;
    }
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
    await result.fold((f) async {
      final shouldReload =
          current.payroll.id.isNotEmpty &&
          (f.code == 'PAID_PAYROLL_IMMUTABLE' ||
              f.code == 'PAYROLL_SESSIONS_ALREADY_USED');
      if (!shouldReload) {
        emit(
          TeacherPayrollDetailsReady(
            current.payroll,
            current.profile,
            error: f.message,
          ),
        );
        return;
      }
      (await repo.getPayroll(current.payroll.id)).fold(
        (_) => emit(
          TeacherPayrollDetailsReady(
            current.payroll,
            current.profile,
            error: f.message,
          ),
        ),
        (latest) => emit(
          TeacherPayrollDetailsReady(latest, current.profile, error: f.message),
        ),
      );
    }, (p) async => emit(TeacherPayrollDetailsReady(p, current.profile)));
  }

  void updateProfile(PayoutProfileModel profile) {
    final current = state;
    if (current is TeacherPayrollDetailsReady) {
      emit(TeacherPayrollDetailsReady(current.payroll, profile));
    }
  }

  void replacePayroll(TeacherPayrollModel payroll) {
    final current = state;
    final profile = current is TeacherPayrollDetailsReady
        ? current.profile
        : null;
    emit(TeacherPayrollDetailsReady(payroll, profile));
  }
}
