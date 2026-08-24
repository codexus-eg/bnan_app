import 'package:bnan_app/features/plans/presentation/views/widgets/plan_date_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('date validation allows past and rejects future', (tester) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: 'selected');
    addTearDown(controller.dispose);
    final today = DateUtils.dateOnly(DateTime.now());
    Widget field(DateTime date) => MaterialApp(
      localizationsDelegates: const [S.delegate],
      home: Scaffold(
        body: Form(
          key: formKey,
          child: PlanDateField(
            controller: controller,
            selectedDate: date,
            startDate: today.subtract(const Duration(days: 30)),
            onDateChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpWidget(field(today.subtract(const Duration(days: 1))));
    expect(formKey.currentState!.validate(), isTrue);

    await tester.pumpWidget(field(today.add(const Duration(days: 1))));
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Future dates are not allowed'), findsOneWidget);
  });
}
