import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_cell.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DigitalScheduleGridRow extends StatelessWidget {
  const DigitalScheduleGridRow({
    super.key,
    required this.day,
    required this.cells,
    this.onAction,
    this.loadingClassroomIds = const {},
  });
  final String day;
  final List<List<DigitalScheduleGridItem>> cells;
  final ValueChanged<String>? onAction;
  final Set<String> loadingClassroomIds;

  @override
  Widget build(BuildContext context) {
    final count = cells.fold<int>(
      1,
      (max, items) => items.length > max ? items.length : max,
    );
    final hasAction = cells.any(
      (items) => items.any((item) => item.actionClassroomId != null),
    );
    final height = (hasAction ? 72.0 : 56.0) + ((count - 1) * 38);
    return CustomTableRow(
      children: [
        ScheduleCell(text: day, width: 64, height: height, isDark: true),
        ...cells.map((items) {
          final actionIds = items
              .map((item) => item.actionClassroomId)
              .whereType<String>()
              .toSet();
          final actionId = actionIds.length == 1 ? actionIds.single : null;
          return ScheduleCell(
            text: items
                .map((item) {
                  final action = item.actionClassroomId == actionId
                      ? '\n${S.of(context).joinSession}'
                      : '';
                  return '${item.primary}\n${item.secondary}$action';
                })
                .join('\n'),
            width: 92,
            height: height,
            maxLines: items.isEmpty ? 2 : items.length * 3,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            isLoading:
                actionId != null && loadingClassroomIds.contains(actionId),
            onTap: actionId == null || onAction == null
                ? null
                : () => onAction!(actionId),
          );
        }),
      ],
    );
  }
}
