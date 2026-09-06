import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_mock_data.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_cubit.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_grades_management_cubit/get_grades_management_cubit.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_grades_management_cubit/get_grades_management_state.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/curriculum_grades_card.dart';
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
          const SizedBox(height: 16),
          Expanded(
            child:
                BlocBuilder<GetGradesmanagementCubit, GetGradesManagementState>(
                  builder: (context, state) {
                    final isLoading =
                        state is GetGradesInitial || state is GetGradesLoading;

                    final grades = state is GetGradesSuccess
                        ? state.grades.data
                        : mockGrades;

                    if (state is GetGradesFailure) {
                      return const NoDataWidget();
                    }

                    if (!isLoading && grades.isEmpty) {
                      return const NoDataWidget();
                    }

                    final groups = _groupGrades(grades, context);

                    return AppSkeletonizer(
                      isLoading: isLoading,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          return CurriculumGradesCard(
                            curriculumName: group.name,
                            grades: group.grades,
                            isInteractive:
                                !isLoading && state is GetGradesSuccess,
                            onDeleteGrade: (gradeId) =>
                                _showDeleteGradeDialog(context, gradeId),
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  List<_CurriculumGroup> _groupGrades(
    List<GradeModel> grades,
    BuildContext context,
  ) {
    final map = <String, _CurriculumGroup>{};

    for (final grade in grades) {
      final curr = grade.curriculum;
      final key = curr != null && curr.id.trim().isNotEmpty
          ? curr.id.trim()
          : (curr != null && curr.name.trim().isNotEmpty
              ? curr.name.trim()
              : 'unassigned');
      final name = curr != null && curr.name.trim().isNotEmpty
          ? curr.name.trim()
          : S.of(context).curriculums;

      if (!map.containsKey(key)) {
        map[key] = _CurriculumGroup(key: key, name: name, grades: []);
      }
      map[key]!.grades.add(grade);
    }

    return map.values.toList();
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

class _CurriculumGroup {
  final String key;
  final String name;
  final List<GradeModel> grades;

  _CurriculumGroup({
    required this.key,
    required this.name,
    required this.grades,
  });
}
