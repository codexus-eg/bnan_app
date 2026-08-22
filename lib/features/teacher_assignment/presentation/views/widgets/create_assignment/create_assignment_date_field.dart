import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAssignmentDateField extends StatelessWidget {
  const CreateAssignmentDateField({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<CreateAssignmentCubit>();

    final now = DateTime.now();
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );

    final date = await AppPickers.pickDate(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
    );

    if (date == null) return;

    cubit.changeDueDate(date.toIso8601String());
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CreateAssignmentCubit>();

    return SchedulePickerField(
      label: S.of(context).availableDay,
      hintText: 'mm/dd/yy',
      value: cubit.selectedDueDate == null
          ? null
          : _formatDate(cubit.selectedDueDate!),
      icon: ImageManager.teacherAssignmentDateIcon,
      onTap: () => _pickDate(context),
    );
  }
}