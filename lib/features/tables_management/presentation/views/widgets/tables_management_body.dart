import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_list.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_selected_day_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_week_days_selector.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_state.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/data/repo/egyptian_digital_schedule_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/egyptian_schedule_management_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/egyptian_lesson_dialog.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesManagementBody extends StatefulWidget {
  const TablesManagementBody({super.key, this.useSupervisorClassrooms = false});

  final bool useSupervisorClassrooms;

  @override
  State<TablesManagementBody> createState() => _TablesManagementBodyState();
}

class _TablesManagementBodyState extends State<TablesManagementBody> {
  String? classroomId;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: widget.useSupervisorClassrooms
        ? BlocBuilder<
            GetSupervisorClassroomsCubit,
            GetSupervisorClassroomsState
          >(builder: _supervisorClassrooms)
        : BlocBuilder<ClassroomsCubit, ClassroomsState>(
            builder: _adminClassrooms,
          ),
  );

  Widget _adminClassrooms(BuildContext context, ClassroomsState state) {
    if (state is ClassroomsFailure) {
      return TableSchedulesFailure(
        message: state.message,
        onRetry: context.read<ClassroomsCubit>().getClassrooms,
      );
    }
    if (state is! ClassroomsSuccess) {
      return const AppSkeletonizer(isLoading: true, child: NoDataWidget());
    }
    return _classrooms(
      state.response.data
          .where(
            (item) =>
                item.isActive &&
                item.id.isNotEmpty &&
                item.curriculum.registrationMode?.toLowerCase() == 'egyptian',
          )
          .map(_classroomUi)
          .toList(growable: false),
    );
  }

  Widget _supervisorClassrooms(
    BuildContext context,
    GetSupervisorClassroomsState state,
  ) {
    if (state is GetSupervisorClassroomsFailure) {
      return TableSchedulesFailure(
        message: state.errorMessage,
        onRetry: context.read<GetSupervisorClassroomsCubit>().getMyClassrooms,
      );
    }
    if (state is! GetSupervisorClassroomsSuccess) {
      return const AppSkeletonizer(isLoading: true, child: NoDataWidget());
    }
    return _classrooms(
      state.response.data
          .where(
            (item) =>
                item.id.isNotEmpty &&
                item.curriculum.registrationMode?.toLowerCase() == 'egyptian',
          )
          .map(_supervisorClassroomUi)
          .toList(growable: false),
    );
  }

  Widget _classrooms(List<LessonClassroomUiModel> classrooms) {
    final selectedId = classrooms.any((item) => item.id == classroomId)
        ? classroomId
        : classrooms.isEmpty
        ? null
        : classrooms.first.id;
    classroomId = selectedId;
    if (selectedId == null) {
      return Column(
        children: [
          _header(
            classrooms,
            null,
            () => showCustomSnackBar(
              context,
              S.of(context).noClassroomsAvailable,
              false,
            ),
          ),
          const Expanded(child: NoDataWidget()),
        ],
      );
    }
    return BlocProvider(
      key: ValueKey(selectedId),
      create: (_) => EgyptianScheduleManagementCubit(
        repo: getIt<TableManagementRepo>() as EgyptianDigitalScheduleRepo,
        classroomId: selectedId,
      )..load(),
      child: _EgyptianScheduleContent(
        classrooms: classrooms,
        classroomId: selectedId,
        onClassroomChanged: _selectClassroom,
        confirmDelete: widget.useSupervisorClassrooms,
      ),
    );
  }

  Widget _header(
    List<LessonClassroomUiModel> classrooms,
    String? selectedId,
    VoidCallback? onAdd,
  ) => LessonsManagementHeader(
    classrooms: classrooms,
    selectedClassroomId: selectedId,
    onClassroomChanged: _selectClassroom,
    onAddTap: onAdd,
    adjacentFilter: CustomDropdown(
      label: S.of(context).week,
      hint: S.of(context).selectWeek,
      items: const [],
      backgroundColor: ColorManager.white,
      onChanged: null,
    ),
  );

  void _selectClassroom(String? value) => setState(() => classroomId = value);

  LessonClassroomUiModel _classroomUi(ClassroomModel item) =>
      LessonClassroomUiModel(
        id: item.id,
        name: item.name,
        subjectId: '',
        subjectName: '',
      );

  LessonClassroomUiModel _supervisorClassroomUi(
    SupervisorClassroomModel item,
  ) => LessonClassroomUiModel(
    id: item.id,
    name: item.name,
    subjectId: '',
    subjectName: '',
  );
}

class _EgyptianScheduleContent extends StatelessWidget {
  const _EgyptianScheduleContent({
    required this.classrooms,
    required this.classroomId,
    required this.onClassroomChanged,
    required this.confirmDelete,
  });

  final List<LessonClassroomUiModel> classrooms;
  final String classroomId;
  final ValueChanged<String?> onClassroomChanged;
  final bool confirmDelete;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EgyptianScheduleManagementCubit, EgyptianScheduleState>(
        builder: _content,
      );

  Widget _content(BuildContext context, EgyptianScheduleState state) {
    final cubit = context.read<EgyptianScheduleManagementCubit>();
    final saving = state.status == EgyptianScheduleStatus.saving;
    final header = LessonsManagementHeader(
      classrooms: classrooms,
      selectedClassroomId: classroomId,
      onClassroomChanged: onClassroomChanged,
      onAddTap: saving || state.subjects.isEmpty
          ? null
          : () => _handleAdd(context, cubit, state),
      adjacentFilter: _weekDropdown(context, cubit, state),
    );
    if (state.status == EgyptianScheduleStatus.loading) {
      return Column(
        children: [
          header,
          const Expanded(
            child: AppSkeletonizer(isLoading: true, child: NoDataWidget()),
          ),
        ],
      );
    }
    if (state.status == EgyptianScheduleStatus.failure) {
      return Column(
        children: [
          header,
          Expanded(
            child: TableSchedulesFailure(
              message: state.error ?? S.of(context).unexpectedError,
              onRetry: cubit.load,
            ),
          ),
        ],
      );
    }
    final lessons = _selectedLessons(state)..sort(_byStartTime);
    final lessonModels = lessons.map(_lessonUi).toList(growable: false);
    return Column(
      children: [
        header,
        const SizedBox(height: 16),
        LessonsWeekDaysSelector(
          days: egyptianLessonDays,
          selectedDay: state.selectedDay,
          onSelected: cubit.selectDay,
        ),
        const SizedBox(height: 16),
        LessonsSelectedDayHeader(
          dayLabel: lessonDayLabel(S.of(context), state.selectedDay),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: lessons.isEmpty
              ? NoDataWidget(title: S.of(context).noLessonsForSelectedDay)
              : LessonsList(
                  lessons: lessonModels,
                  onTap: (lesson) {
                    final index = lessonModels.indexOf(lesson);
                    if (index >= 0) {
                      _openDialog(context, lesson: lessons[index]);
                    }
                  },
                ),
        ),
      ],
    );
  }

  Widget _weekDropdown(
    BuildContext context,
    EgyptianScheduleManagementCubit cubit,
    EgyptianScheduleState state,
  ) => CustomDropdown(
    label: S.of(context).week,
    value: state.selectedWeek?.toString(),
    hint: state.currentWeek == null
        ? S.of(context).studyNotStarted
        : S.of(context).selectWeek,
    items: state.availableWeeks.map((item) => '${item.number}').toList(),
    itemsLabels: {
      for (final item in state.availableWeeks)
        '${item.number}': S.of(context).weekNumber(item.number),
    },
    backgroundColor: ColorManager.white,
    onChanged: (value) => cubit.selectWeek(int.tryParse(value ?? '')),
  );

  void _handleAdd(
    BuildContext context,
    EgyptianScheduleManagementCubit cubit,
    EgyptianScheduleState state,
  ) {
    if (state.currentWeek == null) {
      showCustomSnackBar(context, S.of(context).studyNotStarted, false);
      return;
    }
    if (cubit.isPreviousWeek) {
      showCustomSnackBar(
        context,
        S.of(context).cannotAddLessonInPreviousWeek,
        false,
      );
      return;
    }
    if (cubit.addableDays.isEmpty) {
      showCustomSnackBar(context, S.of(context).scheduleDateInPast, false);
      return;
    }
    _openDialog(context);
  }

  List<EgyptianDigitalLesson> _selectedLessons(EgyptianScheduleState state) {
    final result = <EgyptianDigitalLesson>[];
    for (final day in state.days) {
      if (_dayName(day.date) == state.selectedDay) result.addAll(day.lessons);
    }
    return result;
  }

  int _byStartTime(EgyptianDigitalLesson a, EgyptianDigitalLesson b) =>
      a.startTime.compareTo(b.startTime);

  String _dayName(String date) {
    final value = DateTime.tryParse(date);
    return switch (value?.weekday) {
      DateTime.sunday => 'sunday',
      DateTime.monday => 'monday',
      DateTime.tuesday => 'tuesday',
      DateTime.wednesday => 'wednesday',
      DateTime.thursday => 'thursday',
      DateTime.friday => 'friday',
      _ => 'saturday',
    };
  }

  LessonUiModel _lessonUi(EgyptianDigitalLesson item) => LessonUiModel(
    id: item.id,
    classroomId: item.classroomId,
    classroomName: item.classroomName.isNotEmpty
        ? item.classroomName
        : classrooms.firstWhere((value) => value.id == classroomId).name,
    subjectId: item.subjectId,
    subjectName: item.subjectName,
    day: _dayName(item.date),
    startTime: item.startTime,
    endTime: item.endTime,
    teacherName: item.teacherName,
  );

  Future<void> _openDialog(
    BuildContext context, {
    EgyptianDigitalLesson? lesson,
  }) {
    final cubit = context.read<EgyptianScheduleManagementCubit>()
      ..clearActionError();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EgyptianLessonDialog(
          classroomName: classrooms
              .firstWhere((item) => item.id == classroomId)
              .name,
          lesson: lesson,
          confirmDelete: confirmDelete,
        ),
      ),
    );
  }
}
