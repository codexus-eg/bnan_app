import 'package:bnan_app/core/shared_widget/app_table/app_table_cell.dart';
import 'package:bnan_app/core/shared_widget/app_table/app_table_row_model.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  const AppTable({
    super.key,
    required this.headers,
    required this.rows,
    this.cellWidth = 64,
  });

  final List<String> headers;
  final List<AppTableRowModel> rows;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Column(
          children: [
            Row(
              children: headers.map((text) {
                return AppTableCell(
                  text: text,
                  isHeader: true,
                  width: cellWidth,
                );
              }).toList(),
            ),
            Divider(height: 8, thickness: 1, color: ColorManager.greyE8E9),
            ...List.generate(rows.length, (index) {
              final row = rows[index];
              return Column(
                children: [
                  Row(
                    children: row.cells.asMap().entries.map((entry) {
                      final cellIndex = entry.key;
                      final text = entry.value;

                      return AppTableCell(
                        text: text,
                        isHeader: cellIndex == 0,
                        width: cellWidth,
                      );
                    }).toList(),
                  ),
                  // if (index != rows.length )
                  Divider(
                    height: 8,
                    thickness: 1,
                    color: ColorManager.greyE8E9,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
