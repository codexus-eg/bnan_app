import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/create_egyptian_schedule_cubit/create_egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/add_table_schedule_dialog.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_grade_filter_section.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesManagementBody extends StatelessWidget {
  const TablesManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: AddNewTopicButton(
              title: S.of(context).addNewSchedule,
              path: ImageManager.userAdd,
              onTap: () => _showAddScheduleDialog(context),
              padding: EdgeInsetsDirectional.symmetric(
                vertical: 6,
                horizontal: 30,
              ),
            ),
          ),
          const TableGradeFilterSection(),
          const Expanded(child: TableSchedulesContent()),
        ],
      ),
    );
  }

  Future<void> _showAddScheduleDialog(BuildContext context) async {
    final createCubit = context.read<CreateEgyptianScheduleCubit>();
    final schedulesCubit = context.read<GetEgyptianSchedulesCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: createCubit),
          BlocProvider(
            create: (_) => AcademicLookupsCubit(
              repo: getIt<AcademicLookupsRepo>(),
              loadClassroomsOnGrade: true,
              loadSubjectsWithoutClassroom: false,
              loadSubjectsOnClassroom: false,
            )..loadCurriculums(),
          ),
        ],
        child: const AddTableScheduleDialog(),
      ),
    );

    if (result != true || !context.mounted) return;

    showCustomSnackBar(
      context,
      S.of(context).scheduleCreatedSuccessfully,
      true,
    );

    schedulesCubit.getEgyptianSchedules(
      gradeId: context.read<AcademicLookupsCubit>().state.selectedGrade?.id,
    );
  }
}
