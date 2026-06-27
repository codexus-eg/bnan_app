import 'package:bnan_app/core/shared_widget/app_table/app_table.dart';
import 'package:bnan_app/core/shared_widget/app_table/app_table_row_model.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherMonthlyPerformanceTable extends StatelessWidget {
  const TeacherMonthlyPerformanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final headers = [
      s.month,
      s.classesCount,
      s.salary,
      s.points,
      s.ranking,
    ];

    final rows = [
      const AppTableRowModel(cells: ['يناير', '48', '2600', '920', '2']),
      const AppTableRowModel(cells: ['فبراير', '45', '2400', '880', '4']),
      const AppTableRowModel(cells: ['مارس', '50', '2700', '900', '3']),
      const AppTableRowModel(cells: ['أبريل', '42', '2200', '850', '5']),
      const AppTableRowModel(cells: ['مايو', '40', '2100', '820', '6']),
      const AppTableRowModel(cells: ['يونيو', '35', '1800', '780', '8']),
    ];

    return CustomDetailsWidgetBackground(
      child: AppTable(
        headers: headers,
        rows: rows,
        cellWidth: 63,
      ),
    );
  }
}