import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_config.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_data.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teacher_payrolls_state.dart';

class TeacherPayrollsCubit extends Cubit<TeacherPayrollsState> {
  TeacherPayrollsCubit(this.repo) : super(const TeacherPayrollsInitial());
  final TeacherPayrollRepo repo;
  List<PayrollListItemModel> _items = const [];
  List<PayrollTeacherModel> _teachers = const [];
  bool _loading = false;
  Future<void> load({
    required String from,
    required String to,
    String? teacherId,
    String? status,
  }) async {
    if (_loading) return;
    if (kUseTeacherPayrollMockData) {
      _teachers = TeacherPayrollMockData.teachers;
      final values = TeacherPayrollMockData.list.where((item) {
        final matchesTeacher =
            teacherId?.isNotEmpty != true || item.teacherId == teacherId;
        final matchesStatus =
            status?.isNotEmpty != true || item.status == status;
        return matchesTeacher && matchesStatus;
      }).toList();
      _items = values;
      emit(TeacherPayrollsSuccess(values, _teachers));
      return;
    }
    _loading = true;
    emit(TeacherPayrollsLoading(_items));
    if (_teachers.isEmpty) {
      (await repo.getTeachers()).fold((_) {}, (v) => _teachers = v);
    }
    final result = await repo.getPreviewList(
      from: from,
      to: to,
      teacherId: teacherId,
    );
    _loading = false;
    result.fold((f) => emit(TeacherPayrollsFailure(f.message, _items)), (v) {
      final filtered = status?.isNotEmpty == true
          ? v.where((item) => item.status == status).toList()
          : v;
      _items = filtered;
      emit(TeacherPayrollsSuccess(filtered, _teachers));
    });
  }
}
