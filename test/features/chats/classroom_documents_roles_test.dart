import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recordings_response.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summaries_response.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/message_documents_cubit.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/classroom_documents_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all classroom member roles can access recordings and reports', () {
    for (final role in [
      'admin',
      'supervisor',
      'teacher',
      'student',
      'parent',
    ]) {
      expect(_canPrivileged(role, 'classroom-id'), isTrue);
    }
    expect(_canPrivileged('teacher', null), isFalse);
  });

  testWidgets(
    'all member roles see and load recordings reports and messages tabs',
    (tester) async {
      for (final role in [
        'admin',
        'supervisor',
        'teacher',
        'student',
        'parent',
      ]) {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        final documentsRepo = _DocumentsRepo();
        await tester.pumpWidget(
          _documentsApp(
            role: role,
            privileged: true,
            documentsRepo: documentsRepo,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Recordings'), findsOneWidget);
        expect(find.text('Reports'), findsOneWidget);
        expect(find.text('Messages'), findsOneWidget);
        expect(find.text('Shared recording'), findsOneWidget);
        expect(documentsRepo.recordingCalls, 1, reason: role);
        await tester.tap(find.text('Reports'));
        await tester.pumpAndSettle();
        expect(find.text('Shared report session'), findsOneWidget);
        expect(find.text('Shared report'), findsOneWidget);
        expect(documentsRepo.summaryCalls, 1, reason: role);
      }
    },
  );

  testWidgets('messages-only tab supports RTL', (tester) async {
    await tester.pumpWidget(
      _documentsApp(
        role: 'student',
        privileged: true,
        locale: const Locale('ar'),
      ),
    );
    await tester.pump();
    expect(find.text('الرسائل'), findsOneWidget);
  });
}

bool _canPrivileged(String role, String? classroomId) {
  return ClassroomDocumentsAccess.canRecordingsAndReports(
    roomType: 'classroom',
    classroomId: classroomId,
    role: role,
  );
}

Widget _documentsApp({
  required String role,
  required bool privileged,
  Locale locale = const Locale('en'),
  _DocumentsRepo? documentsRepo,
  _ChatRepo? chatRepo,
}) {
  final docs = documentsRepo ?? _DocumentsRepo();
  final chat = chatRepo ?? _ChatRepo();
  Widget child = BlocProvider(
    create: (_) => MessageDocumentsCubit(chat),
    child: ClassroomDocumentsView(
      key: ValueKey(role),
      roomId: 'room-id',
      roomType: 'classroom',
      currentUserRole: role,
      classroomId: privileged ? 'classroom-id' : null,
    ),
  );
  if (privileged) {
    child = MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ClassroomRecordingsCubit(docs)),
        BlocProvider(create: (_) => ClassroomSummariesCubit(docs)),
      ],
      child: child,
    );
  }
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: child,
  );
}

class _DocumentsRepo implements ClassroomDocumentsRepo {
  int recordingCalls = 0, summaryCalls = 0;

  @override
  getRecordings(String classroomId) async {
    recordingCalls++;
    return const Right<Failure, ClassroomRecordingsResponse>(
      ClassroomRecordingsResponse([
        ClassroomRecordingModel(
          sessionName: 'Shared recording',
          recordingLink: 'https://example.com/recording',
        ),
      ]),
    );
  }

  @override
  getSummaries(String classroomId) async {
    summaryCalls++;
    return const Right<Failure, ClassroomSummariesResponse>(
      ClassroomSummariesResponse([
        ClassroomSummaryItemModel(
          sessionName: 'Shared report session',
          summary: ClassroomSummaryModel(
            title: 'Shared report',
            content: 'Shared content',
            docUrl: 'https://example.com/report.pdf',
            nextSteps: [],
          ),
        ),
      ]),
    );
  }
}

class _ChatRepo implements ChatRepo {
  final roomIds = <String>[];

  @override
  getRoomMessages({required String roomId}) async {
    roomIds.add(roomId);
    return const Right<Failure, ChatMessagesResponseModel>(
      ChatMessagesResponseModel(success: true, results: 0, messages: []),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
