import 'package:bnan_app/core/shared_widget/html_content_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps normal HTML unchanged', (tester) async {
    const content = '<p>Hello <strong>world</strong></p>';
    await tester.pumpWidget(
      const MaterialApp(home: HtmlContentViewer(content: content)),
    );

    expect(tester.widget<Html>(find.byType(Html)).data, content);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('decodes entity-encoded HTML', (tester) async {
    const content = '&lt;p&gt;Hello&lt;/p&gt;';
    await tester.pumpWidget(
      const MaterialApp(home: HtmlContentViewer(content: content)),
    );

    expect(tester.widget<Html>(find.byType(Html)).data, '<p>Hello</p>');
  });
}
