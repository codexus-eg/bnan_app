import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_state.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/mappers/elapsed_weeks_selection_mapper.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/utils/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classroom_week_filters.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_dialogs.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_header_actions.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/plans_weekly_content.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansManagementBody extends StatefulWidget {
  const PlansManagementBody({
    super.key,
    required this.policy,
    required this.showEmpty,
    this.uploadFilePicker,
  });

  final PlansAccessPolicy policy;
  final bool showEmpty;
  final PlansFilePicker? uploadFilePicker;

  @override
  State<PlansManagementBody> createState() => _PlansManagementBodyState();
}

class _PlansManagementBodyState extends State<PlansManagementBody> {
  PlanClassroomOption? selectedClassroom;
  int? selectedWeek;
  int weeksCount = 0;
  String? _classroomsSignature;
  String? _classroomsRole;
  String? _requestedElapsedClassroomId;
  List<PlanClassroomOption> _availableClassrooms = const [];

  @override
  Widget build(BuildContext context) {
    final elapsedState = context.watch<GetElapsedWeeksCubit>().state;
    return BlocListener<GetElapsedWeeksCubit, GetElapsedWeeksState>(
      listener: _onElapsedState,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
        children: [
          if (widget.policy.showManagementActions) ...[
            PlansHeaderActions(
              policy: widget.policy,
              onAdd: _showAddDialog,
              onUpload: _showUploadDialog,
            ),
            const SizedBox(height: 16),
          ],
          if (widget.policy.showClassroomFilter)
            PlansClassroomWeekFilters(
              policy: widget.policy,
              selectedClassroom: selectedClassroom,
              selectedWeek: selectedWeek,
              weeksCount: weeksCount,
              elapsedState: elapsedState,
              onClassroomChanged: (value) => _onClassroomChanged(value),
              onWeekChanged: _onWeekChanged,
              onRetryElapsedWeeks: _retryElapsedWeeks,
              onClassroomsChanged: _scheduleClassroomSync,
            ),
          const SizedBox(height: 16),
          PlansWeeklyContent(
            classroom: selectedClassroom,
            week: selectedWeek,
            showEmpty: widget.showEmpty,
            waitingMessage:
                selectedClassroom != null &&
                    elapsedState is GetElapsedWeeksSuccess &&
                    weeksCount == 0
                ? S.of(context).noStudyWeeksAvailable
                : null,
          ),
        ],
      ),
    );
  }

  void _onClassroomChanged(
    PlanClassroomOption? classroom, {
    bool force = false,
  }) {
    if (!force && classroom?.id == selectedClassroom?.id) return;
    _requestedElapsedClassroomId = classroom?.id;
    setState(() {
      selectedClassroom = classroom;
      selectedWeek = null;
      weeksCount = 0;
    });
    if (classroom != null) {
      _loadSubjects(classroom.id);
      context.read<GetElapsedWeeksCubit>().getElapsedWeeks(
        classroomId: classroom.id,
      );
    }
  }

  void _loadSubjects(String classroomId) {
    if (!widget.policy.canAddDailyPlan) return;
    if (widget.policy.showTeacherFieldInAddDialog) {
      context.read<GetClassroomSubjectsCubit>().getClassroomSubjects(
        classroomId: classroomId,
      );
      context.read<ClassroomDetailsCubit>().getClassroomDetails(classroomId);
      return;
    }
    context.read<GetTeacherAssignedSubjectsCubit>().getTeacherAssignedSubjects(
      classroomId: classroomId,
    );
  }

  Future<void> _showAddDialog() async {
    final classroom = selectedClassroom;
    final week = selectedWeek;
    if (classroom == null || week == null) return;
    final created = await PlansDialogs.showAdd(
      context,
      widget.policy,
      classroom: classroom,
      selectedWeek: week,
    );
    if (!mounted || created != true) return;
    showCustomSnackBar(
      context,
      S.of(context).dailyPlanCreatedSuccessfully,
      true,
    );
    context.read<GetWeeklyPlansCubit>().getPlansByWeek(
      classroomId: classroom.id,
      week: week,
    );
  }

  Future<void> _showUploadDialog() async {
    final classroomId = await PlansDialogs.showUpload(
      context,
      widget.policy,
      classrooms: _availableClassrooms,
      initialClassroom: selectedClassroom,
      filePicker: widget.uploadFilePicker,
    );
    if (!mounted || classroomId == null) return;
    showCustomSnackBar(
      context,
      S.of(context).termPlanUploadedSuccessfully,
      true,
    );
    context.read<GetTermPlansCubit>().getTermPlans(classroomId: classroomId);
  }

  void _onElapsedState(BuildContext context, GetElapsedWeeksState state) {
    final classroom = selectedClassroom;
    if (classroom == null || _requestedElapsedClassroomId != classroom.id) {
      return;
    }
    if (state is GetElapsedWeeksFailure) return;
    if (state is! GetElapsedWeeksSuccess) return;
    final count = state.response.data.weeksCount;
    final initialWeek = resolveInitialPlanWeek(
      weeksCount: count,
      currentWeek: state.response.data.currentWeek,
    );
    setState(() {
      weeksCount = count > 0 ? count : 0;
      selectedWeek = initialWeek;
    });
    if (initialWeek != null) {
      context.read<GetWeeklyPlansCubit>().getPlansByWeek(
        classroomId: classroom.id,
        week: initialWeek,
      );
    }
  }

  void _onWeekChanged(int? week) {
    final classroom = selectedClassroom;
    if (week == null ||
        classroom == null ||
        week < 1 ||
        week > weeksCount ||
        week == selectedWeek) {
      return;
    }
    setState(() => selectedWeek = week);
    context.read<GetWeeklyPlansCubit>().getPlansByWeek(
      classroomId: classroom.id,
      week: week,
    );
  }

  void _retryElapsedWeeks() {
    final classroom = selectedClassroom;
    if (classroom == null) return;
    _requestedElapsedClassroomId = classroom.id;
    context.read<GetElapsedWeeksCubit>().getElapsedWeeks(
      classroomId: classroom.id,
    );
  }

  void _scheduleClassroomSync(List<PlanClassroomOption> classrooms) {
    _availableClassrooms = List.unmodifiable(classrooms);
    final role = SessionManager.instance.userRole?.trim().toLowerCase();
    final signature = classrooms.map((item) => item.id).join('|');
    final sourceChanged = _classroomsRole != role;
    if (!sourceChanged && _classroomsSignature == signature) return;
    _classroomsRole = role;
    _classroomsSignature = signature;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final selectedExists =
          !sourceChanged &&
          classrooms.any((item) => item.id == selectedClassroom?.id);
      if (selectedExists) return;
      _onClassroomChanged(
        classrooms.isNotEmpty ? classrooms.first : null,
        force: sourceChanged,
      );
    });
  }
}
