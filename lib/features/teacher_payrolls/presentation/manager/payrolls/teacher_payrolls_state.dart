import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';

sealed class TeacherPayrollsState {
  const TeacherPayrollsState();
}

class TeacherPayrollsInitial extends TeacherPayrollsState {
  const TeacherPayrollsInitial();
}

class TeacherPayrollsLoading extends TeacherPayrollsState {
  const TeacherPayrollsLoading(this.previous);
  final List<PayrollListItemModel> previous;
}

class TeacherPayrollsSuccess extends TeacherPayrollsState {
  const TeacherPayrollsSuccess(this.items, this.teachers);
  final List<PayrollListItemModel> items;
  final List<PayrollTeacherModel> teachers;
}

class TeacherPayrollsFailure extends TeacherPayrollsState {
  const TeacherPayrollsFailure(this.message, this.previous);
  final String message;
  final List<PayrollListItemModel> previous;
}
