import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/curriculum_lookup_dropdown.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_filter_summary.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_filters.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_filters_sheet.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_warning_card.dart';
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
  final TextEditingController _searchController = TextEditingController();

  String _date(DateTime value) => DateFormat('yyyy-MM-dd', 'en').format(value);

  bool get _isValidPeriod => !filters.from.isAfter(filters.to);
  bool get _hasCurriculum =>
      filters.curriculumId != null && filters.curriculumId!.isNotEmpty;

  Future<void> _load() {
    if (!_isValidPeriod || !_hasCurriculum) return Future.value();
    return context.read<TeacherPayrollsCubit>().load(
      from: _date(filters.from),
      to: _date(filters.to),
      curriculumId: filters.curriculumId,
      teacherId: filters.teacherId,
      status: filters.status,
      searchQuery: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: CustomAppbar(headerText: s.teacherPayrolls),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AcademicLookupsCubit, AcademicLookupsState>(
            listenWhen: (prev, curr) =>
                prev.selectedCurriculum?.id != curr.selectedCurriculum?.id,
            listener: (context, lookupState) {
              final newId = lookupState.selectedCurriculum?.id;
              final newName = lookupState.selectedCurriculum?.name;
              setState(() {
                filters = PayrollFilters(
                  from: filters.from,
                  to: filters.to,
                  curriculumId: newId,
                  curriculumName: newName,
                  status: filters.status,
                  teacherId: filters.teacherId,
                );
              });
              if (newId != null && newId.isNotEmpty && _isValidPeriod) {
                _load();
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CurriculumLookupDropdown(),
              const SizedBox(height: 10),
              BlocBuilder<TeacherPayrollsCubit, TeacherPayrollsState>(
                builder: (_, state) => PayrollFilterSummary(
                  from: filters.from,
                  to: filters.to,
                  curriculum: filters.curriculumName ?? '',
                  status: _statusLabel(s),
                  teacher: _teacherLabel(state, s),
                  onTap: _openFilters,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: s.payrollSearchTeacher,
                controller: _searchController,
                prefixIcon: const Icon(Icons.search),
                onChanged: (val) =>
                    context.read<TeacherPayrollsCubit>().search(val),
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(s)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(S s) {
    if (!_hasCurriculum) {
      return Center(
        child: PayrollWarningCard(text: s.payrollCurriculumRequired),
      );
    }
    if (!_isValidPeriod) {
      return Center(
        child: PayrollWarningCard(text: s.payrollDatesInvalid),
      );
    }
    return PayrollsContent(
      from: _date(filters.from),
      to: _date(filters.to),
      reload: _load,
    );
  }

  String _statusLabel(S s) => switch (filters.status) {
    'unprepared' => s.payrollUnprepared,
    'draft' => s.payrollDraft,
    'sent' => s.payrollSent,
    'payment_pending' => s.payrollPaymentPending,
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
        : const <PayrollTeacherModel>[];
    final value = await showModalBottomSheet<PayrollFilters>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          PayrollFiltersSheet(initial: filters, teachers: teachers),
    );
    if (!mounted || value == null) return;
    setState(() {
      filters = PayrollFilters(
        from: value.from,
        to: value.to,
        curriculumId: filters.curriculumId,
        curriculumName: filters.curriculumName,
        status: value.status,
        teacherId: value.teacherId,
      );
    });
    if (_hasCurriculum && _isValidPeriod) {
      await _load();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
