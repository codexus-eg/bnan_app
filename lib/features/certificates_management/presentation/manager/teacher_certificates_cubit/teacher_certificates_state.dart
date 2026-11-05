import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';

enum TeacherCertificatesStatus { initial, loading, success, failure }

class TeacherCertificatesState {
  const TeacherCertificatesState({
    this.status = TeacherCertificatesStatus.initial,
    this.items = const [],
    this.teachers = const [],
    this.page = 0,
    this.lastPage = 1,
    this.loadingMore = false,
    this.loadingTeachers = false,
    this.creatingDraft = false,
    this.issuingIds = const {},
    this.selectedStatus,
    this.error = '',
    this.eventMessage = '',
    this.eventSuccess = false,
    this.eventId = 0,
  });

  final TeacherCertificatesStatus status;
  final List<TeacherCertificateModel> items;
  final List<SupervisorTeacherModel> teachers;
  final int page, lastPage, eventId;
  final bool loadingMore, loadingTeachers, creatingDraft, eventSuccess;
  final Set<String> issuingIds;
  final String? selectedStatus;
  final String error, eventMessage;

  bool isIssuing(String id) => issuingIds.contains(id);

  TeacherCertificatesState copyWith({
    TeacherCertificatesStatus? status,
    List<TeacherCertificateModel>? items,
    List<SupervisorTeacherModel>? teachers,
    int? page,
    int? lastPage,
    bool? loadingMore,
    bool? loadingTeachers,
    bool? creatingDraft,
    Set<String>? issuingIds,
    String? selectedStatus,
    bool clearStatus = false,
    String? error,
    String? eventMessage,
    bool? eventSuccess,
    int? eventId,
  }) => TeacherCertificatesState(
    status: status ?? this.status,
    items: items ?? this.items,
    teachers: teachers ?? this.teachers,
    page: page ?? this.page,
    lastPage: lastPage ?? this.lastPage,
    loadingMore: loadingMore ?? this.loadingMore,
    loadingTeachers: loadingTeachers ?? this.loadingTeachers,
    creatingDraft: creatingDraft ?? this.creatingDraft,
    issuingIds: issuingIds ?? this.issuingIds,
    selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
    error: error ?? this.error,
    eventMessage: eventMessage ?? this.eventMessage,
    eventSuccess: eventSuccess ?? this.eventSuccess,
    eventId: eventId ?? this.eventId,
  );
}
