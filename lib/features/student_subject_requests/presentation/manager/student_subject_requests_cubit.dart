import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubjectRequestsCubit extends Cubit<StudentSubjectRequestsState> {
  StudentSubjectRequestsCubit(this._repo)
    : super(const StudentSubjectRequestsState());
  final StudentSubjectRequestsRepo _repo;

  Future<void> load({bool refresh = false}) async {
    emit(
      state.copyWith(
        phase: state.availability == null
            ? SubjectRequestsPhase.loading
            : state.phase,
        isRefreshing: refresh && state.availability != null,
        clearMessage: true,
      ),
    );
    final availabilityResult = await _repo.getAvailableSubjects();
    await availabilityResult.fold(
      (failure) async => emit(
        state.copyWith(
          phase: SubjectRequestsPhase.failure,
          isRefreshing: false,
          message: failure.message,
        ),
      ),
      (availability) async {
        final packagesResult = await _repo.getPackages(
          availability.curriculum.id,
        );
        final requestsResult = await _repo.getRequests();
        packagesResult.fold(
          (failure) => emit(
            state.copyWith(
              phase: SubjectRequestsPhase.failure,
              isRefreshing: false,
              message: failure.message,
            ),
          ),
          (packages) {
            final filteredPackages = filterPackages(packages);
            final selectedSubjectId = state.selectedSubjectId;
            final selectedPackageId = state.selectedPackageId;
            final keepSubject =
                selectedSubjectId != null &&
                availability.subjects.any(
                  (item) => item.id == selectedSubjectId && item.isSelectable,
                );
            final keepPackage =
                selectedPackageId != null &&
                filteredPackages.any((item) => item.id == selectedPackageId);
            requestsResult.fold(
              (failure) => emit(
                state.copyWith(
                  phase: SubjectRequestsPhase.failure,
                  isRefreshing: false,
                  message: failure.message,
                ),
              ),
              (requests) => emit(
                state.copyWith(
                  phase: SubjectRequestsPhase.ready,
                  availability: availability,
                  packages: filteredPackages,
                  requests: requests,
                  isRefreshing: false,
                  clearSubject: !keepSubject,
                  clearPackage: !keepPackage,
                ),
              ),
            );
          },
        );
      },
    );
  }

  static List<PackageModel> filterPackages(List<PackageModel> packages) =>
      packages
          .where(
            (item) =>
                item.accessScope == PackageAccessScope.singleSubject &&
                item.type == 'hours' &&
                item.isActive,
          )
          .toList();

  void selectSubject(String id) {
    final subject = state.availability?.subjects
        .where((item) => item.id == id)
        .firstOrNull;
    if (subject?.isSelectable != true) return;
    emit(state.copyWith(selectedSubjectId: id, clearMessage: true));
  }

  void selectPackage(String id) {
    if (!state.packages.any((item) => item.id == id)) return;
    emit(state.copyWith(selectedPackageId: id, clearMessage: true));
  }

  void updateNotes(String value) {
    if (value.length <= 2000) emit(state.copyWith(notes: value));
  }

  Future<void> submitEgyptian() async {
    if (!state.canSubmit || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearMessage: true));
    final result = await _repo.submitEgyptian(
      EgyptianSubjectRequestPayload(
        subjectId: state.selectedSubjectId!,
        packageId: state.selectedPackageId!,
        notes: state.notes,
      ),
    );
    await result.fold(
      (failure) async {
        if (failure.code == 'SUBJECT_ALREADY_REQUESTED') {
          final message = failure.message;
          await load(refresh: true);
          if (!isClosed) emit(state.copyWith(message: message));
        } else {
          emit(state.copyWith(isSubmitting: false, message: failure.message));
        }
      },
      (_) async {
        await load(refresh: true);
        emit(state.copyWith(message: 'subject_request_submitted'));
      },
    );
  }

  Future<void> paymentCompleted() async {
    await load(refresh: true);
    emit(state.copyWith(message: 'subject_request_payment_completed'));
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
