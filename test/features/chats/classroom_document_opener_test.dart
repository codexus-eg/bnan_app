import 'dart:async';

import 'package:bnan_app/features/chats/presentation/utils/classroom_document_opener.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'opens PDF, Zoom docs, Zoom recording and extensionless HTTPS',
    () async {
      final launcher = _Launcher();
      final opener = ClassroomDocumentOpener(launcher);
      final urls = [
        'https://example.com/reports/session-report.pdf',
        'https://docs.zoom.us/example',
        'https://zoom.us/rec/share/example',
        'https://example.com/document',
      ];
      for (final url in urls) {
        expect(await opener.open(url), DocumentOpenResult.opened);
      }
      expect(launcher.urls, urls);
    },
  );

  test('rejects null, blank, invalid and unsafe protocols', () async {
    final launcher = _Launcher();
    final opener = ClassroomDocumentOpener(launcher);
    for (final url in [null, '', '   ']) {
      expect(await opener.open(url), DocumentOpenResult.missing);
    }
    for (final url in ['not-a-valid-url', 'javascript:alert(1)']) {
      expect(await opener.open(url), DocumentOpenResult.invalid);
    }
    expect(launcher.urls, isEmpty);
  });

  test('maps false and thrown launcher results to failure', () async {
    final falseLauncher = _Launcher()..result = false;
    expect(
      await ClassroomDocumentOpener(falseLauncher).open('https://example.com'),
      DocumentOpenResult.failed,
    );
    final throwingLauncher = _Launcher()..throws = true;
    expect(
      await ClassroomDocumentOpener(
        throwingLauncher,
      ).open('https://example.com'),
      DocumentOpenResult.failed,
    );
  });

  test('prevents concurrent repeated launches', () async {
    final launcher = _Launcher()..pending = Completer<bool>();
    final opener = ClassroomDocumentOpener(launcher);
    final first = opener.open('https://zoom.us/rec/share/example');
    expect(
      await opener.open('https://zoom.us/rec/share/example'),
      DocumentOpenResult.busy,
    );
    expect(launcher.urls, hasLength(1));
    launcher.pending!.complete(true);
    expect(await first, DocumentOpenResult.opened);
  });
}

class _Launcher implements ClassroomDocumentLauncher {
  final urls = <String>[];
  bool result = true;
  bool throws = false;
  Completer<bool>? pending;

  @override
  Future<bool> open(String url) {
    urls.add(url);
    if (throws) throw StateError('launch failure');
    return pending?.future ?? Future.value(result);
  }
}
