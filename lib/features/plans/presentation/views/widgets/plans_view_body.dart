import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_state.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/mappers/elapsed_weeks_selection_mapper.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_feedback.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_source.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_dialogs.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_filters_section.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_header_actions.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_weekly_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansViewBody extends StatefulWidget {
  const PlansViewBody({
    super.key,
    required this.policy,
    required this.showEmpty,
    this.uploadFilePicker,
  });

  final PlansAccessPolicy policy;
  final bool showEmpty;
  final PlansFilePicker? uploadFilePicker;

  @override
  State<PlansViewBody> createState() => _PlansViewBodyState();
}

class _PlansViewBodyState extends State<PlansViewBody> {
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
            PlansClassroomsSource(
              builder: (context, state, retry) =>
                  _buildFilters(state, retry, elapsedState),
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

  Widget _buildFilters(
    PlansClassroomsUiState classroomsState,
    VoidCallback retryClassrooms,
    GetElapsedWeeksState elapsedState,
  ) {
    return switch (classroomsState) {
      PlansClassroomsLoading() => _filters(
        null,
        S.of(context).loadingClassrooms,
        elapsedState,
      ),
      PlansClassroomsFailure() => Column(
        children: [
          _filters(null, S.of(context).chooseClassRoom, elapsedState),
          PlansClassroomsFeedback(
            message: classroomsState.message,
            onRetry: retryClassrooms,
          ),
        ],
      ),
      PlansClassroomsSuccess() => _successFilters(
        classroomsState.classrooms,
        elapsedState,
      ),
    };
  }

  Widget _successFilters(
    List<PlanClassroomOption> classrooms,
    GetElapsedWeeksState elapsedState,
  ) {
    _scheduleClassroomSync(classrooms);
    return Column(
      children: [
        _filters(classrooms, S.of(context).chooseClassRoom, elapsedState),
        if (classrooms.isEmpty)
          PlansClassroomsFeedback(message: S.of(context).noClassroomsAvailable)
        else if (selectedClassroom != null &&
            elapsedState is GetElapsedWeeksFailure)
          PlansClassroomsFeedback(
            message: elapsedState.message,
            onRetry: _retryElapsedWeeks,
          ),
      ],
    );
  }

  Widget _filters(
    List<PlanClassroomOption>? classrooms,
    String classroomHint,
    GetElapsedWeeksState elapsedState,
  ) {
    final weeks = _weekOptions(elapsedState);
    final weekHint = selectedWeek != null
        ? '${S.of(context).week} $selectedWeek'
        : elapsedState is GetElapsedWeeksLoading
        ? S.of(context).loading
        : selectedClassroom == null
        ? S.of(context).selectClassroomFirst
        : S.of(context).selectWeek;
    return PlansFiltersSection(
      policy: widget.policy,
      classroom: selectedClassroom,
      classrooms: classrooms,
      classroomHint: classroomHint,
      week: selectedWeek,
      weeks: weeks,
      weekHint: weekHint,
      onClassroomChanged: _onClassroomChanged,
      onWeekChanged: _onWeekChanged,
    );
  }

  List<int>? _weekOptions(GetElapsedWeeksState state) {
    if (state is GetElapsedWeeksLoading || state is GetElapsedWeeksFailure) {
      return null;
    }
    if (selectedClassroom == null || weeksCount <= 0) return const [];
    return List<int>.generate(weeksCount, (index) => index + 1);
  }

  void _onClassroomChanged(
    PlanClassroomOption? classroom, {
    bool force = false,
  }) {
    if (!force && classroom?.id == selectedClassroom?.id) return;
    _requestedElapsedClassroomId = classroom?.id;
    setState(() {
      selectedClassroom = classroom;
      selectedWeek = classroom == null ? null : 1;
      weeksCount = 0;
    });
    if (classroom != null) {
      _loadSubjects(classroom.id);
      context.read<GetElapsedWeeksCubit>().getElapsedWeeks(
        classroomId: classroom.id,
      );
      context.read<GetWeeklyPlansCubit>().getPlansByWeek(
        classroomId: classroom.id,
        week: 1,
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
    if (state is GetElapsedWeeksFailure) {
      return;
    }
    if (state is! GetElapsedWeeksSuccess) return;
    final count = state.response.data.weeksCount;
    final initialWeek = resolveInitialPlanWeek(weeksCount: count);
    final currentWeek = selectedWeek;
    final nextWeek = count <= 0
        ? currentWeek ?? 1
        : currentWeek != null && currentWeek <= count
        ? currentWeek
        : initialWeek;
    final shouldLoadWeek = nextWeek != null && nextWeek != currentWeek;
    setState(() {
      weeksCount = count > 0 ? count : 0;
      selectedWeek = nextWeek;
    });
    if (shouldLoadWeek) {
      context.read<GetWeeklyPlansCubit>().getPlansByWeek(
        classroomId: classroom.id,
        week: nextWeek,
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
