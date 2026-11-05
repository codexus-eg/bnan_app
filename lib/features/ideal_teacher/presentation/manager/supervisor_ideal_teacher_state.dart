import 'package:bnan_app/features/ideal_teacher/data/models/point_adjustment_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';

enum IdealTeacherTab {
  idealTeacher,
  classroomPoints,
}

enum SupervisorIdealTeacherStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  submitting,
  success,
  adjustmentSuccess,
  failure,
}

class SupervisorIdealTeacherState {
  const SupervisorIdealTeacherState({
    this.status = SupervisorIdealTeacherStatus.initial,
    this.rankingResponse,
    this.ranking = const [],
    this.teachers = const [],
    this.selectedTeacherIds = const {},
    this.adjustments = const [],
    this.loadingAdjustments = false,
    this.message = '',
    this.searchQuery = '',
    this.activeTab = IdealTeacherTab.idealTeacher,
    this.issuanceEventId = 0,
    this.issuanceSuccess,
    this.issuanceMessage,
  });

  final SupervisorIdealTeacherStatus status;
  final TeacherRankingResponse? rankingResponse;
  final List<TeacherRankingItemModel> ranking;
  final List<SupervisorTeacherModel> teachers;
  final Set<String> selectedTeacherIds;
  final List<PointAdjustmentModel> adjustments;
  final bool loadingAdjustments;
  final String message;
  final String searchQuery;
  final IdealTeacherTab activeTab;
  final int issuanceEventId;
  final bool? issuanceSuccess;
  final String? issuanceMessage;

  bool get isLoading => status == SupervisorIdealTeacherStatus.loading;
  bool get isLoadingMore => status == SupervisorIdealTeacherStatus.loadingMore;
  bool get isSubmitting => status == SupervisorIdealTeacherStatus.submitting;

  bool get isEgyptianOnlyClassroom =>
      message.contains('EGYPTIAN_CLASSROOM_ONLY') ||
      message.contains('المصري فقط') ||
      message.contains('Egyptian classrooms only');

  List<SupervisorTeacherModel> get filteredTeachers {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return teachers;
    return teachers.where((teacher) {
      return teacher.name.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  List<TeacherRankingItemModel> get filteredRanking {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return ranking;
    return ranking.where((item) {
      return item.fullName.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  SupervisorIdealTeacherState copyWith({
    SupervisorIdealTeacherStatus? status,
    TeacherRankingResponse? rankingResponse,
    List<TeacherRankingItemModel>? ranking,
    List<SupervisorTeacherModel>? teachers,
    Set<String>? selectedTeacherIds,
    List<PointAdjustmentModel>? adjustments,
    bool? loadingAdjustments,
    String? message,
    String? searchQuery,
    IdealTeacherTab? activeTab,
    int? issuanceEventId,
    bool? issuanceSuccess,
    String? issuanceMessage,
    bool clearIssuance = false,
  }) => SupervisorIdealTeacherState(
    status: status ?? this.status,
    rankingResponse: rankingResponse ?? this.rankingResponse,
    ranking: ranking ?? this.ranking,
    teachers: teachers ?? this.teachers,
    selectedTeacherIds: selectedTeacherIds ?? this.selectedTeacherIds,
    adjustments: adjustments ?? this.adjustments,
    loadingAdjustments: loadingAdjustments ?? this.loadingAdjustments,
    message: message ?? this.message,
    searchQuery: searchQuery ?? this.searchQuery,
    activeTab: activeTab ?? this.activeTab,
    issuanceEventId: issuanceEventId ?? this.issuanceEventId,
    issuanceSuccess: clearIssuance ? null : (issuanceSuccess ?? this.issuanceSuccess),
    issuanceMessage: clearIssuance ? null : (issuanceMessage ?? this.issuanceMessage),
  );
}
