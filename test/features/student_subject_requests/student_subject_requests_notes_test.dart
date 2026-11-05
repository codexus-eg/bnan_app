import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'payment_flow_harness.dart';

void main() {
  testWidgets('Notes TextField renders with label, hint, and 2000 max length', (
    tester,
  ) async {
    final harness = PaymentFlowHarness(locale: const Locale('ar'));
    await harness.mount(tester);

    final notesFieldFinder = find.byWidgetPredicate(
      (w) => w is CustomTextField && w.label == 'ملاحظات إضافية (اختياري)',
    );
    expect(notesFieldFinder, findsOneWidget);

    final customTextField = tester.widget<CustomTextField>(notesFieldFinder);
    expect(customTextField.label, 'ملاحظات إضافية (اختياري)');
    expect(customTextField.hintText, 'اكتب أي ملاحظات أو طلبات خاصة بالمادة...');
    expect(customTextField.maxLine, 4);

    expect(harness.request.state.notes, 'Algebra lesson');
    expect(find.text('14 / 2000'), findsOneWidget);

    final inputFinder = find.descendant(
      of: notesFieldFinder,
      matching: find.byType(TextFormField),
    );
    await tester.enterText(inputFinder, 'أريد معلمة مصرية');
    await tester.pumpAndSettle();

    expect(harness.request.state.notes, 'أريد معلمة مصرية');
    expect(find.text('16 / 2000'), findsOneWidget);
  });

  testWidgets('Notes are optional and form is submittable without notes', (
    tester,
  ) async {
    final harness = PaymentFlowHarness(locale: const Locale('ar'));
    await harness.mount(tester);

    final notesFieldFinder = find.byWidgetPredicate(
      (w) => w is CustomTextField && w.label == 'ملاحظات إضافية (اختياري)',
    );
    final inputFinder = find.descendant(
      of: notesFieldFinder,
      matching: find.byType(TextFormField),
    );
    await tester.enterText(inputFinder, '');
    await tester.pumpAndSettle();

    expect(harness.request.state.notes, isEmpty);
    expect(harness.request.state.canSubmit, isTrue);
  });
}
