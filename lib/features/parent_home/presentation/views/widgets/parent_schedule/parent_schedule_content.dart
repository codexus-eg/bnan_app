import 'dart:async';

import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/domain/models/schedule_sync_event.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_sync_coordinator.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_egyptian_schedule_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_gulf_schedule_body.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentScheduleContent extends StatefulWidget {
  const ParentScheduleContent({
    super.key,
    required this.child,
    required this.childSelector,
  });

  final ParentChildModel child;
  final Widget childSelector;

  @override
  State<ParentScheduleContent> createState() => _ParentScheduleContentState();
}

class _ParentScheduleContentState extends State<ParentScheduleContent> {
  int _revision = 0;
  StreamSubscription<ScheduleSyncEvent>? _syncSub;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<ScheduleSyncCoordinator>()) {
      _syncSub = getIt<ScheduleSyncCoordinator>().syncStream.listen((event) {
        if (!mounted) return;
        final target = event.studentId?.trim();
        if (target == null || target.isEmpty || target == widget.child.id.trim()) {
          setState(() => _revision++);
        }
      });
    }
  }

  @override
  void dispose() {
    unawaited(_syncSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentId = widget.child.id.trim();
    if (studentId.isEmpty) return const NoDataWidget();
    return KeyedSubtree(
      key: ValueKey('$studentId:${widget.child.registrationMode}:$_revision'),
      child: switch (widget.child.registrationMode) {
        RegistrationMode.egyptian => BlocProvider(
          create: (_) => GetEgyptianSchedulesCubit(
            getIt<TableManagementRepo>(),
            studentId: studentId,
          )..getMyEgyptianSchedule(),
          child: ParentEgyptianScheduleBody(
            childSelector: widget.childSelector,
          ),
        ),
        RegistrationMode.gulf => BlocProvider(
          create: (_) =>
              ParentGulfScheduleCubit(getIt<GulfScheduleRepo>(), studentId)
                ..load(),
          child: ParentGulfScheduleBody(childSelector: widget.childSelector),
        ),
        null => const NoDataWidget(),
      },
    );
  }
}
