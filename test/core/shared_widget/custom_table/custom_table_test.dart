import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shared table primitives accept composite variable content', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomTableContainer(
            child: CustomTableRow(
              children: [
                CustomTableCell(width: 64, child: Text('Day')),
                CustomTableCell(
                  width: 96,
                  height: 64,
                  child: Column(children: [Text('Lesson'), Text('Homework')]),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.byType(CustomTableRow), findsOneWidget);
    expect(find.byType(CustomTableCell), findsNWidgets(2));
    expect(find.text('Homework'), findsOneWidget);
  });
}
