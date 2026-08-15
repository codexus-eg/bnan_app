import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/delete_lesson_button.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_day_dropdown.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_start_time_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonForm extends StatefulWidget {
  const LessonForm({
    super.key,
    required this.classroom,
    required this.initialDay,
    required this.blockedDays,
    required this.actionText,
    required this.onSave,
    this.initialTime,
    this.initialEndTime,
    this.onDelete,
  });

  final LessonClassroomUiModel classroom;
  final String initialDay, actionText;
  final String? initialTime;
  final String? initialEndTime;
  final Set<String> blockedDays;
  final Future<bool> Function({
    required String day,
    required String startTime,
    required String endTime,
  })
  onSave;
  final Future<bool> Function()? onDelete;

  @override
  State<LessonForm> createState() => _LessonFormState();
}

class _LessonFormState extends State<LessonForm> {
  late String day = widget.initialDay;
  late String? startTime = widget.initialTime;
  late String? endTime = widget.initialEndTime;
  late final classroom = TextEditingController(text: widget.classroom.name);
  late final subject = TextEditingController(
    text: widget.classroom.subjectName,
  );
  String? localError;

  @override
  void dispose() {
    classroom.dispose();
    subject.dispose();
    super.dispose();
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
    });
  }

  Future<void> _submit() async {
    if (widget.blockedDays.contains(day)) {
      setState(() => localError = S.of(context).duplicateScheduleDay);
      return;
    }
    if (startTime == null || endTime == null) {
      setState(() => localError = S.of(context).fillAllRequiredFields);
      return;
    }
    if (!ScheduleTimeUtils.isEndAfter(startTime!, endTime!)) {
      setState(() => localError = S.of(context).lessonEndTimeMustBeAfterStart);
      return;
    }
    final saved = await widget.onSave(
      day: day,
      startTime: startTime!,
      endTime: endTime!,
    );
    if (saved && mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final deleted = await widget.onDelete?.call() ?? false;
    if (deleted && mounted) Navigator.pop(context);
  }

  String? _issueMessage(BuildContext context, GulfScheduleState state) {
    if (localError != null) return localError;
    if (state.actionError != null) return state.actionError;
    return switch (state.actionIssue) {
      GulfScheduleIssue.missingClassroomSubject =>
        S.of(context).gulfClassroomSubjectUnavailable,
      GulfScheduleIssue.duplicateDay => S.of(context).duplicateScheduleDay,
      GulfScheduleIssue.invalidData => S.of(context).fillAllRequiredFields,
      null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GulfScheduleCubit, GulfScheduleState>(
      builder: (context, state) {
        final error = _issueMessage(context, state);
        return Column(
          children: [
            CustomTextField(
              label: S.of(context).classroom,
              controller: classroom,
              readOnly: true,
              backgroundColor: ColorManager.greyF4F6,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: S.of(context).subject,
              controller: subject,
              readOnly: true,
              backgroundColor: ColorManager.greyF4F6,
            ),
            const SizedBox(height: 16),
            LessonDayDropdown(
              value: day,
              onChanged: state.isSaving
                  ? null
                  : (value) => setState(() {
                      day = value ?? day;
                      localError = null;
                      context.read<GulfScheduleCubit>().clearActionFeedback();
                    }),
            ),
            const SizedBox(height: 16),
            LessonStartTimeField(
              value: startTime,
              onTap: state.isSaving ? () {} : () => _pickTime(end: false),
            ),
            const SizedBox(height: 16),
            LessonStartTimeField(
              value: endTime,
              isEndTime: true,
              onTap: state.isSaving ? () {} : () => _pickTime(end: true),
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
              text: widget.actionText,
              isLoading: state.isSaving,
              onPressed: state.isSaving ? null : _submit,
            ),
            if (widget.onDelete != null) ...[
              const SizedBox(height: 12),
              DeleteLessonButton(
                isLoading: state.isSaving,
                onPressed: state.isSaving ? null : _delete,
              ),
            ],
          ],
        );
      },
    );
  }
}
