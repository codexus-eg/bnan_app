import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_filters.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_filters_sheet.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_filter_summary.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payrolls_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TeacherPayrollsView extends StatefulWidget {
  const TeacherPayrollsView({super.key});
  @override
  State<TeacherPayrollsView> createState() => _TeacherPayrollsViewState();
}

class _TeacherPayrollsViewState extends State<TeacherPayrollsView> {
  late PayrollFilters filters = PayrollFilters(
    from: DateTime(DateTime.now().year, DateTime.now().month, 1),
    to: DateTime.now(),
  );
  String _date(DateTime value) => DateFormat('yyyy-MM-dd', 'en').format(value);
  Future<void> _load() => context.read<TeacherPayrollsCubit>().load(
    from: _date(filters.from),
    to: _date(filters.to),
    teacherId: filters.teacherId,
    status: filters.status,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: CustomAppbar(headerText: s.teacherPayrolls),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<TeacherPayrollsCubit, TeacherPayrollsState>(
              builder: (_, state) => PayrollFilterSummary(
                from: filters.from,
                to: filters.to,
                status: _statusLabel(s),
                teacher: _teacherLabel(state, s),
                onTap: _openFilters,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PayrollsContent(
                from: _date(filters.from),
                to: _date(filters.to),
                reload: _load,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(S s) => switch (filters.status) {
    'unprepared' => s.payrollUnprepared,
    'draft' => s.payrollDraft,
    'paid' => s.payrollPaid,
    'cancelled' => s.payrollCancelled,
    _ => s.payrollAllStatuses,
  };
  String _teacherLabel(TeacherPayrollsState state, S s) {
    if (filters.teacherId == null || state is! TeacherPayrollsSuccess) {
      return s.payrollAllTeachers;
    }
    return state.teachers
            .where((t) => t.id == filters.teacherId)
            .map((t) => t.fullName)
            .firstOrNull ??
        s.payrollAllTeachers;
  }

  Future<void> _openFilters() async {
    final state = context.read<TeacherPayrollsCubit>().state;
    final teachers = state is TeacherPayrollsSuccess
        ? state.teachers
        : const <dynamic>[];
    final value = await showModalBottomSheet<PayrollFilters>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          PayrollFiltersSheet(initial: filters, teachers: teachers.cast()),
    );
    if (value != null) {
      setState(() => filters = value);
      await _load();
    }
  }
}
