import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/add_lesson_dialog.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/edit_lesson_dialog.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_list.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_selected_day_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_week_days_selector.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsManagementBody extends StatelessWidget {
  const LessonsManagementBody({super.key, this.readOnly = false});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<GulfScheduleCubit, GulfScheduleState>(
        builder: (context, state) => _content(context, state),
      ),
    );
  }

  Widget _content(BuildContext context, GulfScheduleState state) {
    if (state.status == GulfScheduleLoadStatus.loading ||
        state.status == GulfScheduleLoadStatus.initial) {
      return const _LessonsLoading();
    }
    if (state.status == GulfScheduleLoadStatus.failure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NoDataWidget(title: state.loadError),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: CustomAppButton(
                text: S.of(context).retry,
                onPressed: context.read<GulfScheduleCubit>().load,
              ),
            ),
          ],
        ),
      );
    }
    final classroom = state.selectedClassroom;
    if (classroom == null) {
      return NoDataWidget(title: S.of(context).noGulfClassroomsAvailable);
    }
    final subjectUnavailable =
        readOnly && (classroom.hasSubjectConflict || classroom.subject == null);
    final uiClassrooms = state.classrooms.map(_classroomUi).toList();
    final lessons = subjectUnavailable
        ? <LessonUiModel>[]
        : (classroom.entries
              .map((entry) => _lessonUi(classroom, entry))
              .where((item) => item.day == state.selectedDay)
              .toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime)));
    return Column(
      children: [
        LessonsManagementHeader(
          classrooms: uiClassrooms,
          selectedClassroomId: state.selectedClassroomId,
          onClassroomChanged: context.read<GulfScheduleCubit>().selectClassroom,
          showAddButton: !readOnly,
          onAddTap: classroom.classroomSubjectId == null
              ? null
              : () => _openAdd(context, classroom),
        ),
        const SizedBox(height: 16),
        LessonsWeekDaysSelector(
          selectedDay: state.selectedDay,
          onSelected: context.read<GulfScheduleCubit>().selectDay,
        ),
        const SizedBox(height: 16),
        LessonsSelectedDayHeader(
          dayLabel: lessonDayLabel(S.of(context), state.selectedDay),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: lessons.isNotEmpty
              ? LessonsList(
                  lessons: lessons,
                  onTap: readOnly
                      ? null
                      : (lesson) => _openEdit(context, classroom, lesson),
                )
              : _FlexibleNoData(
                  title: subjectUnavailable
                      ? S.of(context).gulfClassroomSubjectUnavailable
                      : classroom.entries.isEmpty
                      ? classroom.classroomSubjectId == null
                            ? S.of(context).gulfClassroomSubjectUnavailable
                            : S.of(context).noScheduleEntriesForClassroom
                      : S.of(context).noScheduledLessonForDay,
                ),
        ),
      ],
    );
  }

  void _openAdd(BuildContext context, GulfClassroom classroom) {
    final cubit = context.read<GulfScheduleCubit>()..clearActionFeedback();
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddLessonDialog(
          classroom: _classroomUi(classroom),
          initialDay: cubit.state.selectedDay,
          blockedDays: classroom.entries.map((item) => item.day).toSet(),
          onSave: ({required day, required startTime, required endTime}) =>
              cubit.saveEntry(day: day, startTime: startTime, endTime: endTime),
        ),
      ),
    );
  }

  void _openEdit(
    BuildContext context,
    GulfClassroom classroom,
    LessonUiModel lesson,
  ) {
    final cubit = context.read<GulfScheduleCubit>()..clearActionFeedback();
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditLessonDialog(
          classroom: _classroomUi(classroom),
          lesson: lesson,
          blockedDays: classroom.entries
              .where((item) => item.day != lesson.day)
              .map((item) => item.day)
              .toSet(),
          onSave: ({required day, required startTime, required endTime}) =>
              cubit.saveEntry(
                originalDay: lesson.day,
                day: day,
                startTime: startTime,
                endTime: endTime,
              ),
          onDelete: () => cubit.deleteEntry(lesson.day),
        ),
      ),
    );
  }

  LessonClassroomUiModel _classroomUi(GulfClassroom item) =>
      LessonClassroomUiModel(
        id: item.id,
        name: item.name,
        subjectId: item.subject?.id ?? '',
        subjectName: item.subject?.name ?? '',
      );

  LessonUiModel _lessonUi(GulfClassroom classroom, GulfScheduleEntry entry) =>
      LessonUiModel(
        id: '${classroom.id}:${entry.day}',
        classroomId: classroom.id,
        classroomName: classroom.name,
        subjectId: classroom.subject?.id ?? '',
        subjectName: classroom.subject?.name ?? '',
        day: entry.day,
        startTime: entry.startTime,
        endTime: entry.endTime,
        chatRoomId: entry.chatRoomId ?? classroom.chatRoomId,
        classroomSubjectId:
            entry.classroomSubjectId ?? classroom.classroomSubjectId,
        occurrenceKey: entry.occurrenceKey,
      );
}

class _FlexibleNoData extends StatelessWidget {
  const _FlexibleNoData({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: NoDataWidget(title: title),
      ),
    ),
  );
}

class _LessonsLoading extends StatelessWidget {
  const _LessonsLoading();
  @override
  Widget build(BuildContext context) => AppSkeletonizer(
    isLoading: true,
    child: Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Column(
        children: List.generate(
          4,
          (_) => const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12),
            child: SizedBox(
              height: 64,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ColorManager.greyF8F9,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
