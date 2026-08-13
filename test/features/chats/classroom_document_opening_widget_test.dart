import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/utils/classroom_document_opener.dart';
import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/message_document_card.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/recording_card.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_details_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('report opens PDF and extensionless document URLs unchanged', (
    tester,
  ) async {
    for (final url in [
      'https://example.com/reports/session-report.pdf',
      'https://docs.zoom.us/example',
    ]) {
      final launcher = _Launcher();
      await tester.pumpWidget(
        _app(
          SummaryDetailsContent(
            item: _summary(url),
            opener: ClassroomDocumentOpener(launcher),
          ),
        ),
      );
      await tester.tap(find.text('Open Document'));
      await tester.pump();
      expect(launcher.urls, [url]);
    }
  });

  testWidgets('recording card opens Zoom share URL unchanged', (tester) async {
    const url = 'https://zoom.us/rec/share/example';
    final launcher = _Launcher();
    await tester.pumpWidget(
      _app(
        RecordingCard(
          item: const ClassroomRecordingModel(
            sessionName: 'Session',
            recordingLink: url,
          ),
          opener: ClassroomDocumentOpener(launcher),
        ),
      ),
    );
    await tester.tap(find.text('Session'));
    await tester.pump();
    expect(launcher.urls, [url]);
  });

  testWidgets('message PDF card targets its original message', (tester) async {
    const url = 'https://example.com/message-file.pdf';
    var taps = 0;
    await tester.pumpWidget(
      _app(
        MessageDocumentCard(
          item: const MessageDocumentItem(
            id: 'item',
            messageId: 'message-7',
            url: url,
            fileName: 'message-file.pdf',
            messageTitle: '',
            senderName: 'Teacher',
            mimeType: 'application/pdf',
            size: 10,
            createdAt: null,
            isExternalLink: false,
          ),
          onTap: () => taps++,
        ),
      ),
    );
    await tester.tap(find.text('message-file.pdf'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('missing recording does not launch and shows translated error', (
    tester,
  ) async {
    final launcher = _Launcher();
    await tester.pumpWidget(
      _app(
        RecordingCard(
          item: const ClassroomRecordingModel(
            sessionName: 'Session',
            recordingLink: null,
          ),
          opener: ClassroomDocumentOpener(launcher),
        ),
      ),
    );
    await tester.tap(find.text('Session'));
    await tester.pump();
    expect(launcher.urls, isEmpty);
    expect(find.text('Unable to open the session recording'), findsOneWidget);
  });

  testWidgets('invalid URL does not launch and shows Invalid link', (
    tester,
  ) async {
    final launcher = _Launcher();
    await tester.pumpWidget(
      _app(
        RecordingCard(
          item: const ClassroomRecordingModel(
            sessionName: 'Session',
            recordingLink: 'not-a-valid-url',
          ),
          opener: ClassroomDocumentOpener(launcher),
        ),
      ),
    );
    await tester.tap(find.text('Session'));
    await tester.pump();
    expect(launcher.urls, isEmpty);
    expect(find.text('Invalid link'), findsOneWidget);
  });

  testWidgets('failed document launcher shows translated document error', (
    tester,
  ) async {
    final launcher = _Launcher()..result = false;
    await tester.pumpWidget(
      _app(
        SummaryDetailsContent(
          item: _summary('https://docs.zoom.us/example'),
          opener: ClassroomDocumentOpener(launcher),
        ),
      ),
    );
    await tester.tap(find.text('Open Document'));
    await tester.pump();
    expect(launcher.urls, ['https://docs.zoom.us/example']);
    expect(find.text('Unable to open the document'), findsOneWidget);
  });
}

ClassroomSummaryItemModel _summary(String url) {
  return ClassroomSummaryItemModel(
    sessionName: 'Session',
    summary: ClassroomSummaryModel(
      title: 'Report',
      content: 'Content',
      docUrl: url,
      nextSteps: const [],
    ),
  );
}

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

class _Launcher implements ClassroomDocumentLauncher {
  final urls = <String>[];
  bool result = true;

  @override
  Future<bool> open(String url) async {
    urls.add(url);
    return result;
  }
}
