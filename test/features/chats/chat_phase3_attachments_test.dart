import 'dart:io';

import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo_impl.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_attachment_url.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_audio_playback_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_audio_player_controller.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_audio_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_file_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_image_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_image_preview.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_video_player_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  group('attachment URL handling', () {
    test('normalizes relative URLs and preserves absolute URLs', () {
      expect(
        ChatAttachmentUrl.resolve('/uploads/file.pdf').toString(),
        'https://api.bnanacademysa.com/uploads/file.pdf',
      );
      expect(
        ChatAttachmentUrl.resolve('uploads/image.png').toString(),
        'https://api.bnanacademysa.com/uploads/image.png',
      );
      expect(
        ChatAttachmentUrl.resolve('https://cdn.example.com/a.png').toString(),
        'https://cdn.example.com/a.png',
      );
    });

    test('replaces backend loopback media origins with production HTTPS', () {
      expect(
        ChatAttachmentUrl.resolve(
          'http://127.0.0.1:3000/uploads/voice.m4a?version=1',
        ).toString(),
        'https://api.bnanacademysa.com/uploads/voice.m4a?version=1',
      );
      expect(
        ChatAttachmentUrl.resolve(
          'http://localhost:3000/uploads/voice.m4a',
        ).toString(),
        'https://api.bnanacademysa.com/uploads/voice.m4a',
      );
    });

    test('rejects malformed URLs and protects auth headers', () {
      expect(ChatAttachmentUrl.resolve(''), isNull);
      expect(ChatAttachmentUrl.resolve('bad url'), isNull);
      expect(ChatAttachmentUrl.resolve('file:///private/file'), isNull);
      final backend = ChatAttachmentUrl.resolve('/uploads/a.m4a')!;
      final external = Uri.parse('https://cdn.example.com/a.m4a');
      expect(ChatAttachmentUrl.headersFor(backend, accessToken: 'token'), {
        'Authorization': 'Bearer token',
      });
      expect(
        ChatAttachmentUrl.headersFor(external, accessToken: 'token'),
        isEmpty,
      );
    });
  });

  test('attachment type falls back to filename extension', () {
    expect(_attachment('photo.webp', '', 'x').isImage, isTrue);
    expect(
      _attachment('voice.m4a', 'application/octet-stream', 'x').isAudio,
      isTrue,
    );
    expect(_attachment('clip.mp4', '', 'x').isVideo, isTrue);
    expect(_attachment('report.pdf', '', 'x').isPdf, isTrue);
    expect(_attachment('report.docx', '', 'x').isFile, isTrue);
    expect(_attachment('notes.txt', 'text/plain', 'x').isFile, isTrue);
  });

  test('REST and socket message JSON classify m4a voice identically', () {
    final json = {
      'id': 'message',
      'room': 'room',
      'sender': <String, dynamic>{},
      'messageType': 'attachment',
      'attachments': [
        {
          'id': 'voice',
          'fileName': 'voice_1.m4a',
          'fileUrl': '/uploads/voice_1.m4a',
          'mimeType': 'application/octet-stream',
        },
      ],
    };

    final history = ChatMessageModel.fromJson(json);
    final live = ChatMessageModel.fromJson(Map<String, dynamic>.from(json));
    expect(history.attachments.single.isAudio, isTrue);
    expect(live.attachments.single.isAudio, isTrue);
  });

  testWidgets('image tap opens preview and invalid URL is safe', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ChatImageAttachment(
          attachment: _attachment(
            'image.png',
            'image/png',
            'https://example.invalid/a.png',
          ),
          isMe: false,
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('chatImageAttachment')));
    await tester.pumpAndSettle();
    expect(find.byType(ChatImagePreview), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    Navigator.of(tester.element(find.byType(ChatImagePreview))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(ChatImagePreview), findsNothing);

    await tester.pumpWidget(
      _app(
        ChatImageAttachment(
          attachment: _attachment('image.png', 'image/png', 'bad url'),
          isMe: false,
        ),
      ),
    );
    expect(find.text('Unable to load the attachment'), findsOneWidget);
    await tester.tap(find.byKey(const Key('chatImageAttachment')));
    await tester.pump();
    expect(find.text('Invalid link'), findsOneWidget);
  });

  testWidgets('file tap normalizes URL and opener failure shows feedback', (
    tester,
  ) async {
    final openedUrls = <String>[];
    await tester.pumpWidget(
      _app(
        ChatFileAttachment(
          attachment: _attachment(
            'report.pdf',
            'application/pdf',
            '/files/report.pdf',
          ),
          isMe: false,
          icon: Icons.picture_as_pdf_outlined,
          title: 'report.pdf',
          opener: (url) async {
            openedUrls.add(url);
            return true;
          },
        ),
      ),
    );
    await tester.tap(find.text('report.pdf'));
    await tester.pump();
    expect(openedUrls, ['https://api.bnanacademysa.com/files/report.pdf']);

    await tester.pumpWidget(
      _app(
        ChatFileAttachment(
          attachment: _attachment(
            'notes.txt',
            'text/plain',
            'https://x.test/notes.txt',
          ),
          isMe: false,
          icon: Icons.insert_drive_file_outlined,
          title: 'notes.txt',
          opener: (_) async => false,
        ),
      ),
    );
    await tester.tap(find.text('notes.txt'));
    await tester.pump();
    expect(find.text('Unable to open the file'), findsOneWidget);
  });

  test('activating second audio stops the first', () async {
    final coordinator = ChatAudioPlaybackCoordinator();
    var firstStops = 0;
    var secondStops = 0;
    final first = Object();
    final second = Object();
    await coordinator.activate(first, () async => firstStops++);
    await coordinator.activate(second, () async => secondStops++);
    expect(firstStops, 1);
    expect(secondStops, 0);
  });

  testWidgets('broken audio URL renders error without starting a player', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ChatAudioAttachment(
          attachment: _attachment('voice.m4a', 'audio/mp4', 'bad url'),
          isMe: false,
        ),
      ),
    );
    expect(find.text('Unable to load the attachment'), findsOneWidget);
  });

  testWidgets('audio tap plays the resolved URL with backend auth headers', (
    tester,
  ) async {
    final player = _AudioPlayer();
    await tester.pumpWidget(
      _app(
        ChatAudioAttachment(
          attachment: _attachment('voice.m4a', 'audio/mp4', '/voice/a.m4a'),
          isMe: false,
          player: player,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();

    expect(player.url, 'https://api.bnanacademysa.com/voice/a.m4a');
    expect(
      player.headers,
      ChatAttachmentUrl.headersFor(
        Uri.parse('https://api.bnanacademysa.com/voice/a.m4a'),
      ),
    );
    expect(player.playCalls, 1);
  });

  testWidgets('audio player source failure shows error without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ChatAudioAttachment(
          attachment: _attachment('voice.m4a', 'audio/mp4', '/voice/a.m4a'),
          isMe: false,
          player: _AudioPlayer(failSource: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unable to load the attachment'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('video initialization failure leaves loading state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ChatVideoPlayerView(
          videoUrl: 'https://example.com/video.mp4',
          controllerLoader: (_, __) async => throw StateError('failed'),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Unable to load the attachment'), findsOneWidget);
  });

  test('multipart upload preserves basename and infers voice MIME', () async {
    final directory = await Directory.systemTemp.createTemp('bnan-chat-');
    addTearDown(() => directory.delete(recursive: true));
    final voice = File(
      '${directory.path}${Platform.pathSeparator}voice clip.m4a',
    );
    await voice.writeAsBytes([0, 1, 2]);
    final api = _UploadApi();

    await ChatRepoImpl(
      api,
    ).sendMessage(roomId: 'room-id', attachmentPaths: [voice.path]);

    final upload = (api.data as FormData).files.single.value;
    expect(upload.filename, 'voice clip.m4a');
    expect(upload.contentType.toString(), startsWith('audio/'));
  });
}

ChatAttachmentModel _attachment(String name, String mime, String url) {
  return ChatAttachmentModel(
    id: 'a',
    fileName: name,
    fileUrl: url,
    mimeType: mime,
    size: 3,
  );
}

class _UploadApi implements ApiConsumer {
  Object? data;

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.data = data;
    return {
      'success': true,
      'data': {
        'id': 'message',
        'room': 'room-id',
        'sender': <String, dynamic>{},
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AudioPlayer implements ChatAudioPlayerController {
  _AudioPlayer({this.failSource = false});
  final bool failSource;
  String? url;
  Map<String, String> headers = const {};
  int playCalls = 0;
  @override
  Stream<Duration> get positionStream => const Stream.empty();
  @override
  Stream<PlayerState> get playerStateStream => const Stream.empty();
  @override
  Future<Duration?> setUrl(String url, Map<String, String> headers) async {
    if (failSource) throw StateError('source failed');
    this.url = url;
    this.headers = headers;
    return const Duration(seconds: 3);
  }

  @override
  Future<void> play() async => playCalls++;
  @override
  Future<void> pause() async {}
  @override
  Future<void> seek(Duration position) async {}
  @override
  Future<void> dispose() async {}
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
  home: Scaffold(body: Center(child: child)),
);
