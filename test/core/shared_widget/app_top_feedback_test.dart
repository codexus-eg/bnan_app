import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('replaces loading and delays foreground notification', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );

    final loading = AppTopFeedback.show(
      context,
      type: AppTopFeedbackType.loading,
      title: 'Saving file...',
    );
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Saving file...'), findsOneWidget);

    AppTopFeedback.show(
      context,
      type: AppTopFeedbackType.notification,
      title: 'New message',
      dedupKey: 'message-1',
    );
    await tester.pump();
    expect(find.text('New message'), findsNothing);

    AppTopFeedback.replace(
      context,
      loading,
      type: AppTopFeedbackType.success,
      title: 'File saved',
    );
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('File saved'), findsOneWidget);

    await tester.pump(AppTopFeedback.successDuration);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('New message'), findsOneWidget);
    await tester.pump(AppTopFeedback.messageDuration);
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('dismisses persistent loading feedback', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );
    final handle = AppTopFeedback.show(
      context,
      type: AppTopFeedbackType.loading,
      title: 'Saving certificate...',
    );
    await tester.pump(const Duration(milliseconds: 250));
    AppTopFeedback.dismiss(handle);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Saving certificate...'), findsNothing);
  });
}
