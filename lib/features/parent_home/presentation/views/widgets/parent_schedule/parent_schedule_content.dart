import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_egyptian_schedule_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_gulf_schedule_body.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
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
  int? _selectedWeek;
  String? _selectedWeekStart;

  void _rememberWeek(int week, String start) {
    _selectedWeek = week;
    _selectedWeekStart = start;
  }

  @override
  Widget build(BuildContext context) {
    final studentId = widget.child.id.trim();
    if (studentId.isEmpty) return const NoDataWidget();
    return KeyedSubtree(
      key: ValueKey('$studentId:${widget.child.registrationMode}'),
      child: switch (widget.child.registrationMode) {
        RegistrationMode.egyptian => BlocProvider(
          create: (_) => ParentEgyptianScheduleCubit(
            getIt<TableManagementRepo>(),
            studentId,
            onWeekResolved: _rememberWeek,
          )..load(selectedWeek: _selectedWeek, weekStart: _selectedWeekStart),
          child: ParentEgyptianScheduleBody(
            childSelector: widget.childSelector,
            onWeekChanged: _rememberWeek,
          ),
        ),
        RegistrationMode.gulf => BlocProvider(
          create: (_) => ParentGulfScheduleCubit(
            getIt<GulfScheduleRepo>(),
            studentId,
            onWeekResolved: _rememberWeek,
          )..load(selectedWeek: _selectedWeek, weekStart: _selectedWeekStart),
          child: ParentGulfScheduleBody(
            childSelector: widget.childSelector,
            onWeekChanged: _rememberWeek,
          ),
        ),
        null => const NoDataWidget(),
      },
    );
  }
}
