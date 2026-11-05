import 'package:bnan_app/features/teacher_payrolls/data/models/existing_statement_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_payrolls_state.dart';

class TeacherPayrollsCubit extends Cubit<TeacherPayrollsState> {
  TeacherPayrollsCubit(this.repo) : super(const TeacherPayrollsInitial());

  final TeacherPayrollRepo repo;
  List<PayrollListItemModel> _rawItems = const [];
  List<PayrollTeacherModel> _teachers = const [];
  List<ExistingStatementModel> _statements = const [];
  String _searchQuery = '';
  String? _statusFilter;
  Future<void>? _activeLoad;
  String? _activeRequestKey;
  int _requestVersion = 0;

  Future<void> load({
    required String from,
    required String to,
    String? curriculumId,
    String? teacherId,
    String? status,
    String? searchQuery,
  }) {
    if (isClosed) return Future.value();
    _statusFilter = status;
    if (searchQuery != null) _searchQuery = searchQuery.trim().toLowerCase();
    final requestKey =
        '$from|$to|${curriculumId ?? ''}|${teacherId ?? ''}|${status ?? ''}';
    final activeLoad = _activeLoad;
    if (_activeRequestKey == requestKey && activeLoad != null) {
      return activeLoad;
    }

    final version = ++_requestVersion;
    late final Future<void> operation;
    operation =
        _performLoad(
          from: from,
          to: to,
          curriculumId: curriculumId,
          teacherId: teacherId,
          version: version,
        ).whenComplete(() {
          if (identical(_activeLoad, operation)) {
            _activeLoad = null;
            _activeRequestKey = null;
          }
        });
    _activeRequestKey = requestKey;
    _activeLoad = operation;
    return operation;
  }

  void search(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  Future<void> _performLoad({
    required String from,
    required String to,
    required int version,
    String? curriculumId,
    String? teacherId,
  }) async {
    if (!_canEmit(version)) return;
    emit(TeacherPayrollsLoading(_rawItems));

    // Fetch existing statements for duplicate/overlap detection
    final statementsResult = await repo.getStatements(
      curriculumId: curriculumId,
    );
    if (!_canEmit(version)) return;
    statementsResult.fold((_) {}, (list) => _statements = list);

    final result = curriculumId != null && curriculumId.isNotEmpty
        ? await repo.getStatementPreview(
            curriculumId: curriculumId,
            from: from,
            to: to,
          )
        : await repo.getPreviewList(
            from: from,
            to: to,
            teacherId: teacherId,
          );

    if (!_canEmit(version)) return;
    result.fold((f) => emit(TeacherPayrollsFailure(f.message, _rawItems)), (v) {
      final processed = v.map((item) {
        final overlap = _findOverlap(item.teacherId, from, to);
        return item.copyWith(
          overlappingStatementId: overlap?.id,
          overlappingStatementStatus: overlap?.status,
          curriculumId: curriculumId,
        );
      }).toList();

      _rawItems = processed;
      _teachers = processed
          .map((item) => PayrollTeacherModel(
                id: item.teacherId,
                fullName: item.fullName,
                email: item.email,
                phone: '',
              ))
          .toList();

      _applyFilters();
    });
  }

  ExistingStatementModel? _findOverlap(
    String teacherId,
    String from,
    String to,
  ) {
    for (final s in _statements) {
      if (s.teacherId == teacherId &&
          s.status != 'cancelled' &&
          s.overlaps(from, to)) {
        return s;
      }
    }
    return null;
  }

  void _applyFilters() {
    if (isClosed) return;
    var filtered = _rawItems;

    if (_statusFilter?.isNotEmpty == true) {
      filtered = filtered.where((i) => i.status == _statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        final name = item.fullName.toLowerCase();
        final email = item.email.toLowerCase();
        return name.contains(_searchQuery) || email.contains(_searchQuery);
      }).toList();
    }

    emit(TeacherPayrollsSuccess(filtered, _teachers));
  }

  bool _canEmit(int version) => !isClosed && version == _requestVersion;
}
