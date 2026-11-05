import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
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
    bool? isAdmin,
  })  : isAdmin = isAdmin ?? (SessionManager.instance.role == UserRole.admin),
        super(const TeacherCertificatesState());

  final CertificatesManagementRepo _certificates;
  final SupervisorIdealTeacherRepo _teachers;
  final bool mine;
  final bool isAdmin;

  Future<void> load({bool refresh = true, String? status}) async {
    if (refresh && state.status == TeacherCertificatesStatus.loading) return;
    if (!refresh && (state.loadingMore || state.page >= state.lastPage)) return;
    final page = refresh ? 1 : state.page + 1;
    final targetStatus =
        status ?? state.selectedStatus ?? (isAdmin ? 'draft' : null);
    emit(
      state.copyWith(
        status: refresh ? TeacherCertificatesStatus.loading : state.status,
        loadingMore: !refresh,
        selectedStatus: targetStatus,
        error: '',
      ),
    );
    final result = mine
        ? await _certificates.getMyTeacherCertificates()
        : isAdmin
            ? await _certificates.getAdminCertificates(
                page: page,
                status: targetStatus,
              )
            : await _certificates.getTeacherCertificates(
                page: page,
                status: targetStatus,
              );
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
                        (item.certificateType == 'ideal_teacher' ||
                            item.certificateType == 'general_teacher') &&
                        !item.isDraft,
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

  void filterByStatus(String? status) {
    if (state.selectedStatus == status) return;
    emit(state.copyWith(selectedStatus: status, clearStatus: status == null));
    load(refresh: true, status: status);
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

  Future<void> createDraft({
    required String teacherId,
    required String recipientName,
  }) async {
    final cleanName = recipientName.trim();
    if (state.creatingDraft || teacherId.trim().isEmpty || cleanName.isEmpty) {
      return;
    }
    emit(state.copyWith(creatingDraft: true));
    final result = await _certificates.createTeacherCertificateDraft(
      teacherId: teacherId.trim(),
      recipientName: cleanName,
    );
    if (isClosed) return;
    await result.fold(
      (failure) async {
        emit(state.copyWith(creatingDraft: false));
        _event(failure.message, false);
      },
      (draft) async {
        emit(state.copyWith(creatingDraft: false));
        await load();
        _event(S.current.certificateAddedSuccessfully, true);
      },
    );
  }

  Future<void> issueCertificate(String certificateId) async {
    if (state.isIssuing(certificateId) || certificateId.trim().isEmpty) return;
    emit(state.copyWith(issuingIds: {...state.issuingIds, certificateId}));
    final result = await _certificates.issueGeneralTeacherCertificate(
      certificateId: certificateId.trim(),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        final next = Set<String>.from(state.issuingIds)..remove(certificateId);
        emit(state.copyWith(issuingIds: next));
        _event(failure.message, false);
      },
      (issued) {
        final next = Set<String>.from(state.issuingIds)..remove(certificateId);
        final updatedItems = state.items.map((item) {
          if (item.id == certificateId) {
            return issued;
          }
          return item;
        }).toList();
        emit(state.copyWith(items: updatedItems, issuingIds: next));
        _event(S.current.teacherCertificateIssuedSuccessfully, true);
      },
    );
  }

  Future<void> issue(String teacherId, String signerName) =>
      createDraft(teacherId: teacherId, recipientName: signerName);

  void _event(String message, bool success) => emit(
    state.copyWith(
      eventMessage: message,
      eventSuccess: success,
      eventId: state.eventId + 1,
    ),
  );
}
