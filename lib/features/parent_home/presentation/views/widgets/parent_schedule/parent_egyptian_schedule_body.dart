import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_filters.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/egyptian_schedules_read_only_body.dart';
import 'package:flutter/material.dart';

class ParentEgyptianScheduleBody extends StatelessWidget {
  const ParentEgyptianScheduleBody({super.key, required this.childSelector});

  final Widget childSelector;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ParentScheduleFilters(childSelector: childSelector),
      const Expanded(
        child: EgyptianSchedulesReadOnlyBody(applyTopSafeArea: false),
      ),
    ],
  );
}
