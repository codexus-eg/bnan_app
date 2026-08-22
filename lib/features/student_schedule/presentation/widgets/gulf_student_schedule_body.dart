import 'dart:async';

import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/student_join_session_error.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/gulf_schedule_grid_adapter.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GulfStudentScheduleBody extends StatefulWidget {
  const GulfStudentScheduleBody({super.key});

  @override
  State<GulfStudentScheduleBody> createState() =>
      _GulfStudentScheduleBodyState();
}

class _GulfStudentScheduleBodyState extends State<GulfStudentScheduleBody> {
  late final GulfScheduleCubit _scheduleCubit;
  late final StartSessionCubit _sessionCubit;
  StreamSubscription<AppNotification>? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _scheduleCubit = context.read<GulfScheduleCubit>();
    _sessionCubit = getIt<StartSessionCubit>();
    _notificationSubscription = context
        .read<NotificationsCubit>()
        .incoming
        .listen(_onNotification);
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GulfScheduleCubit, GulfScheduleState>(
        builder: (context, state) {
          if (state.status == GulfScheduleLoadStatus.initial ||
              state.status == GulfScheduleLoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == GulfScheduleLoadStatus.failure) {
            return TableSchedulesFailure(
              message: state.loadError ?? S.of(context).gulfScheduleLoadFailed,
              onRetry: context.read<GulfScheduleCubit>().load,
            );
          }
          return BlocBuilder<StartSessionCubit, StartSessionState>(
            bloc: _sessionCubit,
            builder: (context, sessionState) => DigitalScheduleContent(
              data: adaptGulfStudentSchedule(
                state.classrooms,
                studentSchedule: true,
              ),
              emptyMessage: S.of(context).noSchedule,
              loadingClassroomIds: sessionState.joiningClassroomIds,
              onAction: _join,
            ),
          );
        },
      );

  void _onNotification(AppNotification notification) {
    final keys = {
      notification.key.trim().toUpperCase(),
      notification.type.trim().toUpperCase(),
    };
    if (keys.any(const {'CLASS_STARTED', 'CLASS_ENDED'}.contains) &&
        !_scheduleCubit.isClosed) {
      unawaited(_scheduleCubit.refresh());
    }
  }

  Future<void> _join(String classroomId) async {
    final link = await _sessionCubit.join(classroomId);
    if (!mounted) return;
    if (link == null || link.isEmpty) {
      final joinError = studentJoinSessionErrorMessage(
        context,
        _sessionCubit.state,
      );
      final inactive =
          _sessionCubit.state.eventCode == 'SESSION_NOT_ACTIVE' ||
          _sessionCubit.state.eventError == 'SESSION_NOT_ACTIVE' ||
          _sessionCubit.state.eventStatusCode == 404;
      showCustomSnackBar(
        context,
        joinError ??
            (inactive
                ? S.of(context).noActiveSessionNow
                : _sessionCubit.state.eventError ??
                      S.of(context).unexpectedError),
        false,
      );
      if (inactive && !_scheduleCubit.isClosed) {
        await _scheduleCubit.refresh();
      }
      return;
    }
    final opened =
        FileUrlLauncher.isValidWebUrl(link) && await FileUrlLauncher.open(link);
    if (mounted && !opened) {
      showCustomSnackBar(
        context,
        S.of(context).sessionStartedLinkOpenFailed,
        false,
      );
    }
  }

  @override
  void dispose() {
    unawaited(_notificationSubscription?.cancel());
    unawaited(_sessionCubit.close());
    super.dispose();
  }
}
