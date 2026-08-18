import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/delete_lesson_button.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_day_dropdown.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_start_time_field.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/egyptian_schedule_management_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EgyptianLessonDialog extends StatefulWidget {
  const EgyptianLessonDialog({
    super.key,
    required this.classroomName,
    this.lesson,
    this.confirmDelete = false,
  });

  final String classroomName;
  final EgyptianDigitalLesson? lesson;
  final bool confirmDelete;

  @override
  State<EgyptianLessonDialog> createState() => _EgyptianLessonDialogState();
}

class _EgyptianLessonDialogState extends State<EgyptianLessonDialog> {
  String? classroomSubjectId, startTime, endTime, localError;
  late String day;
  late final TextEditingController classroom;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EgyptianScheduleManagementCubit>();
    classroom = TextEditingController(text: widget.classroomName);
    day = cubit.state.selectedDay;
    if (widget.lesson == null && !cubit.addableDays.contains(day)) {
      day = cubit.addableDays.firstOrNull ?? day;
    }
    startTime = widget.lesson?.startTime;
    endTime = widget.lesson?.endTime;
    classroomSubjectId = widget.lesson?.classroomSubjectId;
    if (classroomSubjectId == null) {
      for (final item in cubit.state.subjects) {
        if (item.subjectId == widget.lesson?.subjectId) {
          classroomSubjectId = item.classroomSubjectId;
          break;
        }
      }
    }
    debugPrint('EDIT PREFILL lesson.id: ${widget.lesson?.id}');
    debugPrint(
      'EDIT PREFILL lesson.classroomSubjectId: '
      '${widget.lesson?.classroomSubjectId}',
    );
    debugPrint('EDIT PREFILL selectedClassroomSubjectId: $classroomSubjectId');
    debugPrint('EDIT PREFILL selectedTime: $startTime');
    debugPrint('EDIT PREFILL originalTime: ${widget.lesson?.startTime}');
  }

  @override
  void dispose() {
    classroom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EgyptianScheduleManagementCubit, EgyptianScheduleState>(
        builder: _content,
      );

  Widget _content(BuildContext context, EgyptianScheduleState state) {
    final cubit = context.read<EgyptianScheduleManagementCubit>();
    final saving = state.status == EgyptianScheduleStatus.saving;
    final error = localError ?? state.actionError;
    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(
              title: widget.lesson == null
                  ? S.of(context).addLesson
                  : S.of(context).editScheduleEntry,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: S.of(context).classroom,
              controller: classroom,
              readOnly: true,
              backgroundColor: ColorManager.greyF4F6,
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              label: S.of(context).subject,
              value: classroomSubjectId,
              items: state.subjects
                  .map((item) => item.classroomSubjectId)
                  .toList(),
              itemsLabels: {
                for (final item in state.subjects)
                  item.classroomSubjectId: _label(item),
              },
              onChanged: saving
                  ? null
                  : (value) => setState(() {
                      classroomSubjectId = value;
                      localError = null;
                      cubit.clearActionError();
                    }),
            ),
            const SizedBox(height: 16),
            LessonDayDropdown(
              value: day,
              days: widget.lesson == null
                  ? cubit.addableDays
                  : egyptianLessonDays,
              onChanged: saving || widget.lesson != null
                  ? null
                  : (value) => setState(() {
                      day = value ?? day;
                      localError = null;
                      cubit.clearActionError();
                    }),
            ),
            const SizedBox(height: 16),
            LessonStartTimeField(
              value: startTime,
              onTap: saving ? () {} : () => _pickTime(end: false),
            ),
            const SizedBox(height: 16),
            LessonStartTimeField(
              value: endTime,
              isEndTime: true,
              onTap: saving ? () {} : () => _pickTime(end: true),
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(
                error,
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: ColorManager.red),
              ),
            ],
            const SizedBox(height: 16),
            CustomAppButton(
              text: widget.lesson == null
                  ? S.of(context).addScheduleEntry
                  : S.of(context).saveChanges,
              isLoading: saving,
              onPressed: saving ? null : _submit,
            ),
            if (widget.lesson != null) ...[
              const SizedBox(height: 12),
              DeleteLessonButton(
                isLoading: saving,
                onPressed: saving ? null : _delete,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime({required bool end}) async {
    final selected = end ? endTime : startTime;
    final parts = selected?.split(':');
    final initial = parts?.length == 2
        ? TimeOfDay(
            hour: int.tryParse(parts![0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          )
        : null;
    final value = await AppPickers.pickTime(
      context: context,
      initialTime: initial,
    );
    if (!mounted || value == null) return;
    final time =
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
    setState(() {
      if (end) {
        endTime = time;
      } else {
        startTime = time;
      }
      localError = null;
      context.read<EgyptianScheduleManagementCubit>().clearActionError();
    });
  }

  Future<void> _submit() async {
    final subjectId = classroomSubjectId;
    final time = startTime;
    final lessonEndTime = endTime;
    if (subjectId == null || time == null || lessonEndTime == null) {
      debugPrint(
        'EDIT BLOCKED: ${subjectId == null ? 'classroomSubjectId null' : 'selectedTime null'}',
      );
      setState(() => localError = S.of(context).fillAllRequiredFields);
      return;
    }
    if (!ScheduleTimeUtils.isEndAfter(time, lessonEndTime)) {
      setState(() => localError = S.of(context).lessonEndTimeMustBeAfterStart);
      return;
    }
    final cubit = context.read<EgyptianScheduleManagementCubit>();
    debugPrint('EDIT SAVE PRESSED');
    debugPrint('edited lesson id: ${widget.lesson?.id}');
    debugPrint('classroomSubjectId: $subjectId');
    debugPrint('new startTime: $time');
    debugPrint('originalTime: ${widget.lesson?.startTime}');
    cubit.selectDay(day);
    debugPrint('EDIT CALLING CUBIT');
    final saved = await cubit.saveLesson(
      originalLessonId: widget.lesson?.id,
      classroomSubjectId: subjectId,
      startTime: time,
      endTime: lessonEndTime,
    );
    debugPrint('EDIT CUBIT RESULT: $saved');
    if (saved && mounted) {
      Navigator.pop(context);
      await cubit.refreshSchedule();
    }
  }

  Future<void> _delete() async {
    if (widget.confirmDelete) {
      final confirmed = await _confirmDelete();
      if (!mounted || !confirmed) {
        debugPrint('DELETE BLOCKED: mounted=$mounted confirmed=$confirmed');
        return;
      }
    }
    final cubit = context.read<EgyptianScheduleManagementCubit>();
    debugPrint('DELETE BEFORE CUBIT: ${widget.lesson?.id}');
    final deleted = await cubit.deleteLesson(widget.lesson!.id);
    debugPrint('DELETE CUBIT RESULT: $deleted');
    if (deleted && mounted) {
      Navigator.pop(context);
      await cubit.refreshSchedule();
    }
  }

  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => CustomAppDialog(
            child: CustomDeleteDialog(
              gradeId: widget.lesson!.id,
              isLoading: false,
              dialogHeader: S.of(dialogContext).delete,
              subtitle: S.of(dialogContext).confirmDelete,
              showCancelButton: true,
              onPressed: () {
                debugPrint('DELETE CONFIRMED: ${widget.lesson?.id}');
                Navigator.pop(dialogContext, true);
              },
            ),
          ),
        ) ??
        false;
  }

  String _label(EgyptianClassroomSubject item) {
    final teachers = item.teacherNames.join('، ');
    return teachers.isEmpty
        ? item.subjectName
        : '${item.subjectName} - $teachers';
  }
}
