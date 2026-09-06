import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_card.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_dialog.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_details_dialog.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/edit_classroom_dialog.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomsManagementBody extends StatefulWidget {
  const ClassroomsManagementBody({super.key});

  @override
  State<ClassroomsManagementBody> createState() =>
      _ClassroomsManagementBodyState();
}

class _ClassroomsManagementBodyState extends State<ClassroomsManagementBody> {
  String? _selectedCurriculumId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassroomsCubit, ClassroomsState>(
      builder: (context, state) {
        if (state is ClassroomsFailure) {
          return Center(child: Text(state.message));
        }

        final isLoading =
            state is ClassroomsLoading || state is ClassroomsInitial;
        final allClassrooms = state is ClassroomsSuccess
            ? state.response.data
            : <ClassroomModel>[];

        final curriculums = <String, String>{};
        for (final classroom in allClassrooms) {
          final id = classroom.curriculum.id.trim();
          final name = classroom.curriculum.name.trim();
          if (id.isNotEmpty) {
            curriculums[id] = name.isNotEmpty ? name : id;
          }
        }

        final items = <String>['all', ...curriculums.keys];
        final itemsLabels = <String, String>{
          'all': S.of(context).allCurriculms,
          ...curriculums,
        };

        final displayedClassrooms = isLoading
            ? ClassroomModel.skeletonClassrooms
            : (_selectedCurriculumId == null || _selectedCurriculumId == 'all')
            ? allClassrooms
            : allClassrooms
                  .where((c) => c.curriculum.id.trim() == _selectedCurriculumId)
                  .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AddNewTopicButton(
                      title: S.of(context).addNewChapter,
                      path: ImageManager.plus,
                      onTap: () => _showAddClassroomDialog(context),
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomDropdown(
                    label: S.of(context).curriculum,
                    value: _selectedCurriculumId ?? 'all',
                    items: items,
                    itemsLabels: itemsLabels,
                    backgroundColor: ColorManager.white,
                    onChanged: (selectedValue) {
                      setState(() {
                        _selectedCurriculumId =
                            (selectedValue == null || selectedValue == 'all')
                            ? null
                            : selectedValue;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: !isLoading && displayedClassrooms.isEmpty
                  ? const NoDataWidget()
                  : AppSkeletonizer(
                      isLoading: isLoading,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            16,
                            8,
                            16,
                            24,
                          ),
                          itemBuilder: (context, index) {
                            final classroomItem = displayedClassrooms[index];
                            return ClassroomsManagementCard(
                              classroomItem: classroomItem,
                              onView: () => showDialog(
                                context: context,
                                builder: (_) => ClassroomDetailsDialog(
                                  classroomItem: classroomItem,
                                ),
                              ),
                              onEdit: () => _showEditClassroomDialog(
                                context,
                                classroomItem,
                              ),
                            );
                          },
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 16),
                          itemCount: displayedClassrooms.length,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddClassroomDialog(BuildContext context) async {
    final actionsCubit = context.read<ClassroomActionsCubit>();
    final classroomsCubit = context.read<ClassroomsCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: actionsCubit),
          BlocProvider(
            create: (_) => AcademicLookupsCubit(
              repo: getIt<AcademicLookupsRepo>(),
              loadClassroomsOnGrade: false,
              loadSubjectsWithoutClassroom: false,
            ),
          ),
          BlocProvider(
            create: (_) => getIt<GetSupervisorsCubit>()..getSupervisors(),
          ),
        ],
        child: const AddClassroomDialog(),
      ),
    );

    if (result == true && context.mounted) {
      classroomsCubit.getClassrooms();
    }
  }

  Future<void> _showEditClassroomDialog(
    BuildContext context,
    ClassroomModel classroomItem,
  ) async {
    final actionsCubit = context.read<ClassroomActionsCubit>();
    final classroomsCubit = context.read<ClassroomsCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: actionsCubit,
        child: EditClassroomDialog(classroomItem: classroomItem),
      ),
    );

    if (result == true && context.mounted) {
      classroomsCubit.getClassrooms();
    }
  }
}
