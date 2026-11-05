import 'dart:async';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
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
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_card.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_search.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_dialog.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_details_dialog.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_subjects_dialog.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final Map<String, String> _curriculumsCache = {};
  String? _selectedCurriculumId;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _fetchClassrooms({bool silent = false}) {
    context.read<ClassroomsCubit>().getClassrooms(
          keyword: _searchController.text.trim(),
          curriculum: _selectedCurriculumId,
          silent: silent,
        );
  }

  void _onSearchChanged(String _) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), _fetchClassrooms);
  }

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

        for (final classroom in allClassrooms) {
          final id = classroom.curriculum.id.trim();
          final name = classroom.curriculum.name.trim();
          if (id.isNotEmpty) {
            _curriculumsCache[id] = name.isNotEmpty ? name : id;
          }
        }

        final items = <String>['all', ..._curriculumsCache.keys];
        final itemsLabels = <String, String>{
          'all': S.of(context).allCurriculms,
          ..._curriculumsCache,
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
                  ClassroomsManagementSearch(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AddNewTopicButton(
                        title: S.of(context).addTeacherToClassroom,
                        path: ImageManager.plus,
                        onTap: () async {
                          await MyNavigator.goTo(
                            context,
                            Routes.teacherSubjectAssignmentView,
                          );
                          if (context.mounted) _fetchClassrooms();
                        },
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      AddNewTopicButton(
                        title: S.of(context).addSubjectToClassroom,
                        path: ImageManager.plus,
                        onTap: () async {
                          await MyNavigator.goTo(context, Routes.addClassroomSubject);
                          if (context.mounted) _fetchClassrooms();
                        },
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      AddNewTopicButton(
                        title: S.of(context).addNewChapter,
                        path: ImageManager.plus,
                        onTap: () => _showAddClassroomDialog(context),
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ],
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
                      _fetchClassrooms();
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
                              onSubjects: () => _showClassroomSubjectsDialog(
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
      _fetchClassrooms();
    }
  }

  Future<void> _showEditClassroomDialog(
    BuildContext context,
    ClassroomModel classroomItem,
  ) async {
    final actionsCubit = context.read<ClassroomActionsCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: actionsCubit,
        child: EditClassroomDialog(classroomItem: classroomItem),
      ),
    );

    if (result == true && context.mounted) {
      _fetchClassrooms();
    }
  }

  Future<void> _showClassroomSubjectsDialog(
    BuildContext context,
    ClassroomModel classroomItem,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ClassroomSubjectsCubit>()..loadSubjects(classroomItem.id),
        child: ClassroomSubjectsDialog(classroomItem: classroomItem),
      ),
    );
    if (context.mounted) _fetchClassrooms(silent: true);
  }
}
