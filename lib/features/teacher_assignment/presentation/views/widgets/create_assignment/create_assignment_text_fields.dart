import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAssignmentTextFields extends StatelessWidget {
  const CreateAssignmentTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateAssignmentCubit>();

    return Column(
      children: [
        CustomTextField(
          label: S.of(context).assignmentTitle,
          backgroundColor: ColorManager.white,
          isRequired: true,
          controller: cubit.titleController,
          onChanged: (_) => cubit.clearError(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).assignmentDescription,
          backgroundColor: ColorManager.white,
          controller: cubit.descriptionController,
          maxLine: 3,
          onChanged: (_) => cubit.clearError(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).assignmentTotalPointsLabel,
          backgroundColor: ColorManager.white,
          isRequired: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: cubit.totalPointsController,
          onChanged: (_) => cubit.clearError(),
          validator: (value) => _validatePoints(context, value),
        ),
      ],
    );
  }

  String? _validatePoints(BuildContext context, String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return S.of(context).totalPointsRequired;
    final points = num.tryParse(trimmed);
    if (points == null || points <= 0) {
      return S.of(context).invalidAssignmentTotalPoints;
    }
    return null;
  }
}
