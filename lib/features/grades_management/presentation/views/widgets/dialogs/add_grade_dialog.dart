import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/grades_management/data/models/create_grade_request_model.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_cubit.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGradeDialog extends StatefulWidget {
  const AddGradeDialog({super.key});

  @override
  State<AddGradeDialog> createState() => _AddGradeDialogState();
}

class _AddGradeDialogState extends State<AddGradeDialog> {
  final formKey = GlobalKey<FormState>();
  final gradeNameController = TextEditingController();

  String? validationMessage;

  @override
  void dispose() {
    gradeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<GradeActionsCubit, GradeActionsState>(
      listener: (context, state) {
        if (state is CreateGradeSuccess) {
          context.read<AcademicLookupsCubit>().selectCurriculum(null);
          Navigator.pop(context, true);
        }

        if (state is CreateGradeFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return CustomAppDialog(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDialogHeader(title: s.addNewGrade),
                  const SizedBox(height: 16),
                  AcademicLookupDropdowns(
                    showCurriculum: true,
                    showGrade: false,
                    showClassroom: false,
                    showSubject: false,
                    onSelectionChanged: (value) {
                      setState(() {
                        validationMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintStyle: getStyle(context),
                    label: s.grade,
                    labelColor: ColorManager.mainColor14,
                    controller: gradeNameController,
                    backgroundColor: ColorManager.white,
                    validator: (value) => value?.trim().isEmpty ?? true
                        ? s.fillAllRequiredFields
                        : null,
                    onChanged: (_) {
                      setState(() => validationMessage = null);
                    },
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      validationMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CustomAppButton(
                    text: s.save,
                    isLoading: state is CreateGradeLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final curriculumId = context
        .read<AcademicLookupsCubit>()
        .state
        .selectedCurriculum
        ?.id;

    if (curriculumId == null) {
      setState(() => validationMessage = S.current.fillAllRequiredFields);
      return;
    }

    context.read<GradeActionsCubit>().createGrade(
      CreateGradeRequestModel(
        name: gradeNameController.text.trim(),
        curriculumId: curriculumId,
      ),
    );
  }

  TextStyle getStyle(BuildContext context) {
    return StylesManager.styleRegular16(
      context,
    ).copyWith(color: ColorManager.mainColor14);
  }
}
