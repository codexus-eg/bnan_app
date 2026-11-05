import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/student_join_session_error.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/zoom_session_error_handler.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/egyptian_schedule_grid_adapter.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
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
    final data = adaptEgyptianSchedule(
      state.week!,
      secondaryText: (lesson) =>
          forStudent ? lesson.teacherName ?? '' : lesson.classroomName,
      includeJoinAction: forStudent,
    );
    return state.status == EgyptianScheduleStatus.failure
        ? TableSchedulesFailure(
            message: state.error,
            onRetry: context.read<EgyptianScheduleCubit>().load,
          )
        : forStudent
        ? BlocBuilder<StartSessionCubit, StartSessionState>(
            builder: (context, sessionState) => DigitalScheduleContent(
              data: data,
              loading: state.status == EgyptianScheduleStatus.loading,
              emptyMessage: S.of(context).noSchedule,
              loadingClassroomIds: sessionState.joiningClassroomIds,
              onAction: (classroomId) => _join(context, classroomId),
            ),
          )
        : DigitalScheduleContent(
            data: data,
            loading: state.status == EgyptianScheduleStatus.loading,
            emptyMessage: S.of(context).noSchedule,
          );
  }

  Future<void> _join(BuildContext context, String classroomId) async {
    final sessionCubit = context.read<StartSessionCubit>();
    String? slotKey;
    for (final day in state.week?.days ?? const <EgyptianScheduleDay>[]) {
      for (final lesson in day.lessons) {
        if (lesson.classroomId == classroomId &&
            lesson.activeSession?.weeklySlotKey != null) {
          slotKey = lesson.activeSession!.weeklySlotKey;
          break;
        }
      }
    }
    final link = await sessionCubit.join(classroomId, weeklySlotKey: slotKey);
    if (!context.mounted) return;
    if (link == null || link.isEmpty) {
      final joinError = studentJoinSessionErrorMessage(
        context,
        sessionCubit.state,
      );
      final message =
          joinError ?? zoomSessionErrorMessage(context, sessionCubit.state);
      showCustomSnackBar(context, message, false);
      final code = (sessionCubit.state.eventCode ??
              sessionCubit.state.eventError ??
              '')
          .trim()
          .toUpperCase();
      final shouldRefresh = code == 'SESSION_NOT_ACTIVE' ||
          code == 'SCHEDULE_OCCURRENCE_NOT_FOUND' ||
          code == 'WEEKLY_ZOOM_SLOT_SESSION_NOT_ACTIVE' ||
          code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
          code.startsWith('WEEKLY_ZOOM_ASSIGNMENT_') ||
          sessionCubit.state.eventStatusCode == 404;
      if (shouldRefresh) {
        await context.read<EgyptianScheduleCubit>().load();
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
