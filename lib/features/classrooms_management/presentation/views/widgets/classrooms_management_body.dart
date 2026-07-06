import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/assets.dart';
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
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomsManagementBody extends StatelessWidget {
  const ClassroomsManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AddNewTopicButton(
            title: S.of(context).addNewChapter,
            path: ImageManager.plus,
            onTap: () => _showAddClassroomDialog(context),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ClassroomsCubit, ClassroomsState>(
            builder: (context, state) {
              if (state is ClassroomsFailure) {
                return Center(child: Text(state.message));
              }

              final isLoading =
                  state is ClassroomsLoading || state is ClassroomsInitial;
              final classrooms = state is ClassroomsSuccess
                  ? state.response.data
                  : ClassroomModel.skeletonClassrooms;

              if (!isLoading && classrooms.isEmpty) return const NoDataWidget();

              return AppSkeletonizer(
                isLoading: isLoading,
                child: ListView.separated(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                  itemBuilder: (context, index) {
                    final classroomItem = classrooms[index];
                    return ClassroomsManagementCard(
                      classroomItem: classroomItem,
                      onView: () => showDialog(
                        context: context,
                        builder: (_) => ClassroomDetailsDialog(
                          classroomItem: classroomItem,
                        ),
                      ),
                      onEdit: () =>
                          _showEditClassroomDialog(context, classroomItem),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemCount: classrooms.length,
                ),
              );
            },
          ),
        ),
      ],
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
        ],
        child: const AddClassroomDialog(),
      ),
    );

    if (result == true) {
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

    if (result == true) {
      classroomsCubit.getClassrooms();
    }
  }
}
