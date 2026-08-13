import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('closes without a Material ancestor', (tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        initialRoute: '/header',
        onGenerateRoute: (settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (_, _, _) => settings.name == '/header'
              ? const CustomDialogHeader(title: 'Header')
              : const SizedBox(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Header'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('Header'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
