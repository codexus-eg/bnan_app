import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_payrolls_state.dart';

class TeacherPayrollsCubit extends Cubit<TeacherPayrollsState> {
  TeacherPayrollsCubit(this.repo) : super(const TeacherPayrollsInitial());
  final TeacherPayrollRepo repo;
  List<PayrollListItemModel> _items = const [];
  List<PayrollTeacherModel> _teachers = const [];
  Future<void>? _activeLoad;
  String? _activeRequestKey;
  int _requestVersion = 0;

  Future<void> load({
    required String from,
    required String to,
    String? teacherId,
    String? status,
  }) {
    if (isClosed) return Future.value();
    final requestKey = '$from|$to|${teacherId ?? ''}|${status ?? ''}';
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
          teacherId: teacherId,
          status: status,
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

  Future<void> _performLoad({
    required String from,
    required String to,
    required int version,
    String? teacherId,
    String? status,
  }) async {
    if (!_canEmit(version)) return;
    emit(TeacherPayrollsLoading(_items));
    if (_teachers.isEmpty) {
      final teachersResult = await repo.getTeachers();
      if (!_canEmit(version)) return;
      teachersResult.fold((_) {}, (value) => _teachers = value);
    }
    final result = await repo.getPreviewList(
      from: from,
      to: to,
      teacherId: teacherId,
    );
    if (!_canEmit(version)) return;
    result.fold((f) => emit(TeacherPayrollsFailure(f.message, _items)), (v) {
      final filtered = status?.isNotEmpty == true
          ? v.where((item) => item.status == status).toList()
          : v;
      _items = filtered;
      emit(TeacherPayrollsSuccess(filtered, _teachers));
    });
  }

  bool _canEmit(int version) => !isClosed && version == _requestVersion;
}
