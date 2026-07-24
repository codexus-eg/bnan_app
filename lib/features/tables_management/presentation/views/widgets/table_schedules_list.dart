import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/delete_egyptian_schedule_cubit/delete_egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_model.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/delete_egyptian_schedule_dialog.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_card_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableSchedulesList extends StatelessWidget {
  const TableSchedulesList({
    super.key,
    required this.schedules,
    this.enableDelete = true,
  });

  final List<EgyptianScheduleModel> schedules;
  final bool enableDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      itemBuilder: (context, index) {
        final schedule = schedules[index];

        return TableCardSection(
          key: ValueKey(schedule.id ?? index),
          schedule: schedule,
          onDelete: _canDelete(schedule)
              ? () => _confirmDelete(context, schedule.id!)
              : null,
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemCount: schedules.length,
    );
  }

  bool _canDelete(EgyptianScheduleModel schedule) {
    return enableDelete && schedule.id != null && schedule.id!.isNotEmpty;
  }

  Future<void> _confirmDelete(BuildContext context, String scheduleId) async {
    final deleteCubit = context.read<DeleteEgyptianScheduleCubit>();
    final schedulesCubit = context.read<GetEgyptianSchedulesCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: deleteCubit,
        child: DeleteEgyptianScheduleDialog(scheduleId: scheduleId),
      ),
    );

    if (result != true || !context.mounted) return;

    showCustomSnackBar(
      context,
      S.of(context).scheduleDeletedSuccessfully,
      true,
    );
    schedulesCubit.getEgyptianSchedules(
      gradeId: context.read<AcademicLookupsCubit>().state.selectedGrade?.id,
    );
  }
}
