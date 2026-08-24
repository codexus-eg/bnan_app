// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bnan_app/bnan_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BnanApp root smoke test', (_) async {
    // Build our app and trigger a frame.
    const app = BnanApp();

    // Verify that our counter starts at 0.
    expect(app, isA<StatefulWidget>());

    // Tap the '+' icon and trigger a frame.
    expect(app.createState(), isA<State<BnanApp>>());

    // Verify that our counter has incremented.
    expect(app.key, isNull);
  });
}
