import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/egyptian_schedule_grid_adapter.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_week_filter.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';

class EgyptianScheduleLoadedBody extends StatelessWidget {
  const EgyptianScheduleLoadedBody({
    super.key,
    required this.state,
    required this.forStudent,
  });
  final EgyptianScheduleState state;
  final bool forStudent;

  @override
  Widget build(BuildContext context) {
    if (state.selectedWeek == null || state.maxWeek == null) {
      return NoDataWidget(title: S.of(context).noScheduleForWeek);
    }
    final data = adaptEgyptianSchedule(
      state.week!,
      secondaryText: (lesson) =>
          forStudent ? lesson.teacherName ?? '' : lesson.classroomName,
      includeJoinAction: forStudent,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
          child: EgyptianScheduleWeekFilter(state: state),
        ),
        Expanded(
          child: state.status == EgyptianScheduleStatus.failure
              ? TableSchedulesFailure(
                  message: state.error,
                  onRetry: () => context.read<EgyptianScheduleCubit>().load(
                    selectedWeek: state.selectedWeek,
                  ),
                )
              : forStudent
              ? BlocBuilder<StartSessionCubit, StartSessionState>(
                  builder: (context, sessionState) => DigitalScheduleContent(
                    data: data,
                    loading: state.status == EgyptianScheduleStatus.loading,
                    emptyMessage: S.of(context).noScheduleForWeek,
                    loadingClassroomIds: sessionState.joiningClassroomIds,
                    onAction: (classroomId) => _join(context, classroomId),
                  ),
                )
              : DigitalScheduleContent(
                  data: data,
                  loading: state.status == EgyptianScheduleStatus.loading,
                  emptyMessage: S.of(context).noScheduleForWeek,
                ),
        ),
      ],
    );
  }

  Future<void> _join(BuildContext context, String classroomId) async {
    final sessionCubit = context.read<StartSessionCubit>();
    final link = await sessionCubit.join(classroomId);
    if (!context.mounted) return;
    if (link == null || link.isEmpty) {
      final inactive =
          sessionCubit.state.eventCode == 'SESSION_NOT_ACTIVE' ||
          sessionCubit.state.eventError == 'SESSION_NOT_ACTIVE' ||
          sessionCubit.state.eventStatusCode == 404;
      showCustomSnackBar(
        context,
        inactive
            ? S.of(context).noActiveSessionNow
            : sessionCubit.state.eventError ?? S.of(context).unexpectedError,
        false,
      );
      if (inactive) {
        await context.read<EgyptianScheduleCubit>().load(
          selectedWeek: state.selectedWeek,
        );
      }
      return;
    }
    final opened =
        FileUrlLauncher.isValidWebUrl(link) && await FileUrlLauncher.open(link);
    if (context.mounted && !opened) {
      showCustomSnackBar(
        context,
        S.of(context).sessionStartedLinkOpenFailed,
        false,
      );
    }
  }
}
