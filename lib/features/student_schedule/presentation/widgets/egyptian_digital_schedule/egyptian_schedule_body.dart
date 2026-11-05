import 'dart:async';

import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/domain/models/schedule_sync_event.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_sync_coordinator.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_loaded_body.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EgyptianScheduleBody extends StatefulWidget {
  const EgyptianScheduleBody({super.key, required this.forStudent});
  final bool forStudent;

  @override
  State<EgyptianScheduleBody> createState() => _EgyptianScheduleBodyState();
}

class _EgyptianScheduleBodyState extends State<EgyptianScheduleBody> {
  StreamSubscription<ScheduleSyncEvent>? _syncSub;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<ScheduleSyncCoordinator>()) {
      _syncSub = getIt<ScheduleSyncCoordinator>().syncStream.listen((_) {
        if (mounted) unawaited(context.read<EgyptianScheduleCubit>().load());
      });
    }
  }

  @override
  void dispose() {
    unawaited(_syncSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EgyptianScheduleCubit, EgyptianScheduleState>(
        builder: (context, state) {
          if (state.week == null) {
            if (state.status == EgyptianScheduleStatus.failure) {
              return TableSchedulesFailure(
                message: state.error,
                onRetry: context.read<EgyptianScheduleCubit>().load,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
          return BlocProvider(
            create: (_) => getIt<StartSessionCubit>(),
            child: EgyptianScheduleLoadedBody(
              state: state,
              forStudent: widget.forStudent,
            ),
          );
        },
      );
}
