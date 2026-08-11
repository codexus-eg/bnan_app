import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';

enum SubjectRequestsPhase { initial, loading, ready, failure }

class StudentSubjectRequestsState {
  const StudentSubjectRequestsState({
    this.phase = SubjectRequestsPhase.initial,
    this.availability,
    this.packages = const [],
    this.requests = const [],
    this.selectedSubjectId,
    this.selectedPackageId,
    this.notes = '',
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.message,
  });

  final SubjectRequestsPhase phase;
  final SubjectRequestAvailability? availability;
  final List<PackageModel> packages;
  final List<StudentSubjectRequest> requests;
  final String? selectedSubjectId;
  final String? selectedPackageId;
  final String notes;
  final bool isRefreshing;
  final bool isSubmitting;
  final String? message;

  bool get canSubmit =>
      selectedSubjectId != null &&
      selectedPackageId != null &&
      notes.length <= 2000;

  StudentSubjectRequestsState copyWith({
    SubjectRequestsPhase? phase,
    SubjectRequestAvailability? availability,
    List<PackageModel>? packages,
    List<StudentSubjectRequest>? requests,
    String? selectedSubjectId,
    String? selectedPackageId,
    String? notes,
    bool? isRefreshing,
    bool? isSubmitting,
    String? message,
    bool clearSubject = false,
    bool clearPackage = false,
    bool clearMessage = false,
  }) => StudentSubjectRequestsState(
    phase: phase ?? this.phase,
    availability: availability ?? this.availability,
    packages: packages ?? this.packages,
    requests: requests ?? this.requests,
    selectedSubjectId: clearSubject
        ? null
        : selectedSubjectId ?? this.selectedSubjectId,
    selectedPackageId: clearPackage
        ? null
        : selectedPackageId ?? this.selectedPackageId,
    notes: notes ?? this.notes,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    message: clearMessage ? null : message ?? this.message,
  );
}
