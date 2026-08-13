import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_mock_data.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_cubit.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_grades_management_cubit/get_grades_management_cubit.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_grades_management_cubit/get_grades_management_state.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/dialogs/add_grade_dialog.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/dialogs/delete_grade_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradesManagementBody extends StatelessWidget {
  const GradesManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AddNewTopicButton(
            title: S.of(context).addNewGrade,
            path: ImageManager.plus,
            onTap: () => _showAddGradeDialog(context),
            padding: const EdgeInsetsDirectional.only(
              start: 20,
              end: 27,
              top: 8,
              bottom: 8,
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child:
                BlocBuilder<GetGradesmanagementCubit, GetGradesManagementState>(
                  builder: (context, state) {
                    final isLoading =
                        state is GetGradesInitial || state is GetGradesLoading;

                    final grades = state is GetGradesSuccess
                        ? state.grades.data.reversed.toList()
                        : mockGrades.reversed.toList();

                    if (state is GetGradesFailure) {
                      return const NoDataWidget();
                    }

                    if (!isLoading && grades.isEmpty) {
                      return const NoDataWidget();
                    }

                    return AppSkeletonizer(
                      isLoading: isLoading,
                      child: CustomDetailsWidgetBackground(
                        margin: const EdgeInsetsDirectional.symmetric(
                          vertical: 16,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: grades.length,
                          itemBuilder: (context, index) {
                            final grade = grades[index];

                            return DetailsRowSection(
                              iconPath: ImageManager.teacherCurriculm,
                              title: grade.name,
                              subtitle: grade.curriculum?.name ?? '',
                              onTap: isLoading || state is! GetGradesSuccess
                                  ? null
                                  : () => _showDeleteGradeDialog(
                                      context,
                                      grade.id,
                                    ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddGradeDialog(BuildContext context) async {
    final gradeActionsCubit = context.read<GradeActionsCubit>();
    final academicLookupsCubit = context.read<AcademicLookupsCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: gradeActionsCubit),
            BlocProvider.value(value: academicLookupsCubit),
          ],
          child: const AddGradeDialog(),
        );
      },
    );

    if (result == true && context.mounted) {
      context.read<GetGradesmanagementCubit>().getGrades();
    }
  }

  Future<void> _showDeleteGradeDialog(
    BuildContext context,
    String gradeId,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<GradeActionsCubit>(),
        child: DeleteGradeDialog(gradeId: gradeId),
      ),
    );

    if (result == true && context.mounted) {
      context.read<GetGradesmanagementCubit>().getGrades();
    }
  }
}
