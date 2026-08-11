import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final scenarios = [
    (name: 'iPhone 13', size: const Size(390, 844), keyboard: 0.0),
    (name: 'iPhone 13 keyboard', size: const Size(390, 844), keyboard: 336.0),
    (
      name: 'small Android keyboard',
      size: const Size(360, 640),
      keyboard: 280.0,
    ),
  ];

  for (final scenario in scenarios) {
    testWidgets('form scrolls on ${scenario.name}', (tester) async {
      tester.view.physicalSize = scenario.size;
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = FakeViewPadding(bottom: scenario.keyboard);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const _TestApp());

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Save'), 300);
      expect(find.text('Save'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: PackageFormDialogLayout(
        title: 'Add package',
        body: SingleChildScrollView(
          child: Column(children: const [SizedBox(height: 800), Text('Save')]),
        ),
      ),
    ),
  );
}
