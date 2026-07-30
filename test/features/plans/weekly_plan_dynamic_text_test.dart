import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'weekly_plan_text_fixture.dart';

void main() {
  for (final locale in const [Locale('en'), Locale('ar')]) {
    testWidgets(
      'weekly plan expands long text at 2x in ${locale.languageCode}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(WeeklyPlanTextFixture(locale: locale));
        await tester.pumpAndSettle();

        final cells = tester
            .widgetList<CustomTableCell>(find.byType(CustomTableCell))
            .toList();
        expect(cells[0].height, isNull);
        expect(cells[0].constraints?.minHeight, 29);
        expect(
          cells[0].padding,
          const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
        );
        expect(cells[1].width, 125);
        expect(cells[3].constraints?.minHeight, 40);
        expect(cells[3].padding, const EdgeInsetsDirectional.all(4));

        expect(find.text(longDay), findsOneWidget);
        expect(find.text(longSubject), findsOneWidget);
        expect(find.textContaining(longLesson), findsOneWidget);
        expect(find.textContaining(longHomework), findsOneWidget);

        final dayCell = find.ancestor(
          of: find.text(longDay),
          matching: find.byType(CustomTableCell),
        );
        final contentCell = find.ancestor(
          of: find.textContaining(longLesson),
          matching: find.byType(CustomTableCell),
        );
        final dayHeight = tester.getSize(dayCell).height;
        final contentHeight = tester.getSize(contentCell).height;

        expect(dayHeight, greaterThan(40));
        expect(contentHeight, dayHeight);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
