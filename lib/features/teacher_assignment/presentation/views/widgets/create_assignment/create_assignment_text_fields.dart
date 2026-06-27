import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
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
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).assignmentDescription,
          backgroundColor: ColorManager.white,
          controller: cubit.descriptionController,
          maxLine: 3,
        ),
        // const SizedBox(height: 16),
        // CustomTextField(
        //   label: S.of(context).points,
        //   backgroundColor: ColorManager.white,
        //   isRequired: true,
        //   keyboardType: TextInputType.number,
        //   controller: cubit.totalPointsController,
        // ),
      ],
    );
  }
}