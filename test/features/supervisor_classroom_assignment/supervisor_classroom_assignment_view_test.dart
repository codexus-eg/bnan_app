import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/supervisor_classroom_assignment_view.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/assign_supervisor_dialog.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/cancel_supervisor_assignment_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows supervisor assignment title and local supervisors', (
    tester,
  ) async {
    await _pumpView(tester);

    expect(find.text('Supervisor Assignment'), findsOneWidget);
    expect(find.text('Sara Ahmed'), findsOneWidget);
    expect(find.text('Somaya'), findsOneWidget);
    expect(find.text('Abdelfattah'), findsOneWidget);
    expect(find.text('Assign to classroom'), findsNWidgets(3));
  });

  testWidgets('assign dialog has one validated classroom dropdown', (
    tester,
  ) async {
    await _pumpView(tester);
    await tester.tap(find.text('Assign to classroom').first);
    await tester.pumpAndSettle();

    expect(find.byType(AssignSupervisorDialog), findsOneWidget);
    expect(find.text('Assign Sara Ahmed to a classroom'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.text('Hourly Rate (SAR)'), findsNothing);
    expect(find.text('Subject'), findsNothing);

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('This field is required'), findsOneWidget);
    expect(find.byType(AssignSupervisorDialog), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fourth primary grade').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(AssignSupervisorDialog), findsNothing);
  });

  testWidgets('delete icon opens cancellation dialog with classroom name', (
    tester,
  ) async {
    await _pumpView(tester);
    final row = find.ancestor(
      of: find.text('Fourth primary grade'),
      matching: find.byType(DetailsRowSection),
    );
    final deleteButton = find.descendant(
      of: row,
      matching: find.byType(InkWell),
    );

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.byType(CancelSupervisorAssignmentDialog), findsOneWidget);
    expect(
      find.text(
        'Do you want to remove this supervisor from Fourth primary grade?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.byType(CancelSupervisorAssignmentDialog), findsNothing);
  });
}

Future<void> _pumpView(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(400, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const SupervisorClassroomAssignmentView(),
    ),
  );
  await tester.pumpAndSettle();
}
