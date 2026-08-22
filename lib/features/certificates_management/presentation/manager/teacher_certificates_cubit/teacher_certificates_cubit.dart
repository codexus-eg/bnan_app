import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_state.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificatesCubit extends Cubit<TeacherCertificatesState> {
  TeacherCertificatesCubit(
    this._certificates,
    this._teachers, {
    this.mine = false,
  }) : super(const TeacherCertificatesState());

  final CertificatesManagementRepo _certificates;
  final SupervisorIdealTeacherRepo _teachers;
  final bool mine;

  Future<void> load({bool refresh = true}) async {
    if (refresh && state.status == TeacherCertificatesStatus.loading) return;
    if (!refresh && (state.loadingMore || state.page >= state.lastPage)) return;
    final page = refresh ? 1 : state.page + 1;
    emit(
      state.copyWith(
        status: refresh ? TeacherCertificatesStatus.loading : state.status,
        loadingMore: !refresh,
        error: '',
      ),
    );
    final result = mine
        ? await _certificates.getMyTeacherCertificates()
        : await _certificates.getTeacherCertificates(page: page);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: refresh
              ? TeacherCertificatesStatus.failure
              : TeacherCertificatesStatus.success,
          loadingMore: false,
          error: failure.message,
        ),
      ),
      (response) {
        final items = mine
            ? response.data
                  .where(
                    (item) =>
                        item.certificateType == 'ideal_teacher' ||
                        item.certificateType == 'general_teacher',
                  )
                  .toList(growable: false)
            : response.data;
        emit(
          state.copyWith(
            status: TeacherCertificatesStatus.success,
            items: refresh ? items : [...state.items, ...items],
            page: response.pagination.currentPage ?? page,
            lastPage: response.pagination.lastPage ?? page,
            loadingMore: false,
            error: '',
          ),
        );
      },
    );
  }

  Future<void> loadTeachers() async {
    if (state.loadingTeachers || state.teachers.isNotEmpty) return;
    emit(state.copyWith(loadingTeachers: true));
    final result = await _teachers.getTeachers();
    if (isClosed) return;
    result.fold(
      (failure) {
        emit(state.copyWith(loadingTeachers: false));
        _event(failure.message, false);
      },
      (teachers) =>
          emit(state.copyWith(teachers: teachers, loadingTeachers: false)),
    );
  }

  Future<void> issue(String teacherId, String signerName) async {
    if (state.issuing || teacherId.trim().isEmpty) return;
    emit(state.copyWith(issuing: true));
    final result = await _certificates.issueGeneralTeacherCertificate(
      teacherId: teacherId,
      signerName: signerName,
    );
    if (isClosed) return;
    await result.fold(
      (failure) async {
        emit(state.copyWith(issuing: false));
        _event(failure.message, false);
      },
      (_) async {
        emit(state.copyWith(issuing: false));
        await load();
        _event(S.current.teacherCertificateIssuedSuccessfully, true);
      },
    );
  }

  void _event(String message, bool success) => emit(
    state.copyWith(
      eventMessage: message,
      eventSuccess: success,
      eventId: state.eventId + 1,
    ),
  );
}
