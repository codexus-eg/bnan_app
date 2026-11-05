import 'dart:async';

import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/student_join_session_error.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/zoom_session_error_handler.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/lessons_management/domain/models/schedule_sync_event.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_notification_matcher.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_sync_coordinator.dart';
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
  StreamSubscription<ScheduleSyncEvent>? _syncSubscription;

  @override
  void initState() {
    super.initState();
    _scheduleCubit = context.read<GulfScheduleCubit>();
    _sessionCubit = getIt<StartSessionCubit>();
    _notificationSubscription = context
        .read<NotificationsCubit>()
        .incoming
        .listen(_onNotification);
    if (getIt.isRegistered<ScheduleSyncCoordinator>()) {
      _syncSubscription =
          getIt<ScheduleSyncCoordinator>().syncStream.listen((_) {
        if (!_scheduleCubit.isClosed) {
          unawaited(_scheduleCubit.refresh());
        }
      });
    }
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
              loading: state.isRefreshing,
              emptyMessage: S.of(context).noSchedule,
              loadingClassroomIds: sessionState.joiningClassroomIds,
              onAction: _join,
            ),
          );
        },
      );

  void _onNotification(AppNotification notification) {
    if (ScheduleNotificationMatcher.isMatch(notification) &&
        !_scheduleCubit.isClosed) {
      unawaited(_scheduleCubit.refresh());
    }
  }

  String? _findWeeklySlotKey(String classroomId) {
    for (final classroom in _scheduleCubit.state.classrooms) {
      if (classroom.id == classroomId ||
          classroom.entries.any((e) => e.classroomId == classroomId)) {
        for (final entry in classroom.entries) {
          final slot = entry.weeklySlotKey?.trim();
          if (slot != null && slot.isNotEmpty) return slot;
          final activeSlot = entry.activeSession?.weeklySlotKey.trim();
          if (activeSlot != null && activeSlot.isNotEmpty) return activeSlot;
        }
      }
    }
    return null;
  }

  Future<void> _join(String classroomId) async {
    debugPrint(
      '[DEBUG GulfStudentScheduleBody] _join called with classroomId: "$classroomId"',
    );
    final slotKey = _findWeeklySlotKey(classroomId);
    final link = await _sessionCubit.join(classroomId, weeklySlotKey: slotKey);
    if (!mounted) return;
    if (link == null || link.isEmpty) {
      final joinError = studentJoinSessionErrorMessage(
        context,
        _sessionCubit.state,
      );
      final message =
          joinError ?? zoomSessionErrorMessage(context, _sessionCubit.state);
      showCustomSnackBar(context, message, false);
      final code = (_sessionCubit.state.eventCode ??
              _sessionCubit.state.eventError ??
              '')
          .trim()
          .toUpperCase();
      final shouldRefresh = code == 'SESSION_NOT_ACTIVE' ||
          code == 'SCHEDULE_OCCURRENCE_NOT_FOUND' ||
          code == 'WEEKLY_ZOOM_SLOT_SESSION_NOT_ACTIVE' ||
          code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
          code.startsWith('WEEKLY_ZOOM_ASSIGNMENT_') ||
          _sessionCubit.state.eventStatusCode == 404;
      if (shouldRefresh && !_scheduleCubit.isClosed) {
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
    unawaited(_syncSubscription?.cancel());
    unawaited(_sessionCubit.close());
    super.dispose();
  }
}
