import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/student_notes_widget.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/subjects_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';

class StudentInfoStep extends StatelessWidget {
  const StudentInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = RegisterCubit.get(context);

    return Form(
      key: registerCubit.studentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   S.of(context).studentInfo,
          //   style: StylesManager.styleBold16(context).copyWith(
          //     color: ColorManager.mainColor15,
          //   ),
          // ),
          // const SizedBox(height: 16),
          CustomTextField(
            controller: registerCubit.studentNameController,
            label: S.of(context).studentName,
            isRequired: true,
            validator: MyValidator.validateName,
          ),
          const SizedBox(height: 16),

          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, registerState) {
              return BlocBuilder<GetGradesCubit, GetGradesState>(
                builder: (context, state) {
                  if (state is GetGradesLoading) {
                    return CustomDropdown(
                      label: S.of(context).grade,
                      value: null,
                      hint: 'Loading...',
                      items: null,
                      isRequired: true,
                      onChanged: (_) {},
                    );
                  }

                  if (state is GetGradesFailure) {
                    return Text(
                      state.errorMessage,
                      style: StylesManager.styleRegular14(
                        context,
                      ).copyWith(color: Colors.red),
                    );
                  }

                  if (state is GetGradesSuccess) {
                    final gradeNames = state.grades
                        .map((grade) => grade.name)
                        .toList();

                    return CustomDropdown(
                      label: S.of(context).grade,
                      value: registerCubit.selectedGradeName,
                      hint: S.of(context).selectGrade,
                      items: gradeNames,
                      isRequired: true,
                      onChanged: (value) {
                        if (value == null) return;

                        final selectedGrade = state.grades.firstWhere(
                          (grade) => grade.name == value,
                        );

                        registerCubit.setGrade(
                          id: selectedGrade.id,
                          name: selectedGrade.name,
                        );

                        context
                            .read<GetCurriculmSubjectsCubit>()
                            .getCurriculumSubjects(
                              curriculumId: registerCubit.curriculumId,
                              gradeId: selectedGrade.id,
                              isGulf: registerCubit.isGulf,
                            );
                      },
                    );
                  }

                  return CustomDropdown(
                    label: S.of(context).grade,
                    value: null,
                    hint: S.of(context).selectGrade,
                    items: null,
                    isRequired: true,
                    onChanged: (_) {},
                  );
                },
              );
            },
          ),

          const SizedBox(height: 16),
          const SubjectsList(),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final fields = [
                CustomTextField(
                  controller: registerCubit.studentEmailController,
                  label: S.of(context).studentEmail,
                  hintText: '',
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: MyValidator.validateEmail,
                ),
                CustomTextField(
                  controller: registerCubit.studentPasswordController,
                  label: S.of(context).studentPasswordField,
                  hintText: S.of(context).passwordHint,
                  isRequired: true,
                  obscureText: true,
                  validator: MyValidator.validateStrongPassword,
                ),
              ];
              if (constraints.maxWidth < 360) {
                return Column(
                  children: [
                    fields.first,
                    const SizedBox(height: 16),
                    fields.last,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: fields.first),
                  const SizedBox(width: 5),
                  Expanded(child: fields.last),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const StudentNotesWidget(),
        ],
      ),
    );
  }
}
