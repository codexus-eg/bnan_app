import 'package:bnan_app/features/ideal_student/data/models/ideal_student_item_model.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_ranking_response.dart';
import 'package:bnan_app/features/ideal_student/data/repos/ideal_student_repo.dart';
import 'package:bnan_app/features/ideal_student/presentation/manager/ideal_student_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealStudentCubit extends Cubit<IdealStudentState> {
  IdealStudentCubit(this.repo) : super(const IdealStudentInitial());
  static const limit = 20;
  final IdealStudentRepo repo;
  PlanClassroomOption? selectedClassroom;
  IdealStudentItemModel? idealStudent;
  IdealStudentRankingResponse? response;
  final List<IdealStudentItemModel> _ranking = [];
  int page = 0, pages = 1, _requestId = 0;
  bool _loadingMore = false;
  String _classroomsSignature = '';
  List<IdealStudentItemModel> get ranking => List.unmodifiable(_ranking);

  Future<void> setClassrooms(List<PlanClassroomOption> classrooms) async {
    final signature = classrooms.map((item) => item.id).join('|');
    if (signature == _classroomsSignature) return;
    _classroomsSignature = signature;
    if (classrooms.isEmpty) {
      _requestId++;
      selectedClassroom = null;
      _clear();
      emit(const IdealStudentEmpty());
      return;
    }
    final currentId = selectedClassroom?.id;
    final current = classrooms
        .where((item) => item.id == currentId)
        .firstOrNull;
    await selectClassroom(current ?? classrooms.first);
  }

  Future<void> selectClassroom(PlanClassroomOption? classroom) async {
    if (classroom == null || classroom.id.trim().isEmpty) return;
    if (selectedClassroom?.id == classroom.id && response != null) return;
    selectedClassroom = classroom;
    _clear();
    emit(const IdealStudentLoading());
    await _fetch(1, ++_requestId);
  }

  Future<void> refresh() async {
    if (selectedClassroom == null) return;
    await _fetch(1, ++_requestId, keepData: true);
  }

  Future<void> loadMore() async {
    if (_loadingMore || page >= pages || selectedClassroom == null) return;
    _loadingMore = true;
    emit(const IdealStudentLoadingMore());
    await _fetch(page + 1, _requestId, append: true);
    _loadingMore = false;
  }

  Future<void> retry() async {
    final classroom = selectedClassroom;
    if (classroom != null) await selectClassroomAfterFailure(classroom);
  }

  Future<void> selectClassroomAfterFailure(
    PlanClassroomOption classroom,
  ) async {
    _clear();
    emit(const IdealStudentLoading());
    await _fetch(1, ++_requestId);
  }

  Future<void> _fetch(
    int requestedPage,
    int requestId, {
    bool append = false,
    bool keepData = false,
  }) async {
    final classroomId = selectedClassroom!.id;
    final result = await repo.getWeeklyRanking(
      classroomId: classroomId,
      page: requestedPage,
      limit: limit,
    );
    if (!_isCurrent(requestId, classroomId)) return;
    result.fold(
      (failure) => emit(
        append
            ? IdealStudentLoadMoreFailure(failure.message)
            : keepData && response != null
            ? IdealStudentRefreshFailure(failure.message)
            : IdealStudentFailure(failure.message),
      ),
      (value) => _apply(value, requestedPage, append),
    );
  }

  void _apply(IdealStudentRankingResponse value, int newPage, bool append) {
    response = value;
    idealStudent = value.idealStudent ?? _winnerFrom(value.ranking);
    page = value.pagination.page;
    pages = value.pagination.pages;
    if (!append) _ranking.clear();
    final ids = _ranking
        .map((item) => '${item.studentId}-${item.rank}')
        .toSet();
    _ranking.addAll(
      value.ranking.where((item) => ids.add('${item.studentId}-${item.rank}')),
    );
    if (value.status == 'insufficient_data' || idealStudent == null) {
      emit(const IdealStudentEmpty());
    } else {
      emit(const IdealStudentLoaded());
    }
  }

  void _clear() {
    response = null;
    idealStudent = null;
    _ranking.clear();
    page = 0;
    pages = 1;
  }

  bool _isCurrent(int id, String classroomId) =>
      !isClosed && id == _requestId && selectedClassroom?.id == classroomId;

  IdealStudentItemModel? _winnerFrom(List<IdealStudentItemModel> ranking) {
    if (ranking.isEmpty) return null;
    final ranked = ranking.where((item) => item.rank > 0).toList();
    if (ranked.isNotEmpty) {
      ranked.sort((left, right) => left.rank.compareTo(right.rank));
      return ranked.first;
    }
    return ranking.reduce(
      (left, right) => left.weeklyPoints >= right.weeklyPoints ? left : right,
    );
  }
}
