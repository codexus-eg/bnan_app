import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recordings_response.dart';
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
  test('recordings and reports access is limited to privileged roles', () {
    for (final role in ['admin', 'supervisor', 'teacher']) {
      expect(_canPrivileged(role, 'classroom-id'), isTrue);
    }
    for (final role in ['student', 'parent']) {
      expect(_canPrivileged(role, 'classroom-id'), isFalse);
    }
    expect(_canPrivileged('teacher', null), isFalse);
  });

  testWidgets(
    'privileged roles see tabs in recordings reports messages order',
    (tester) async {
      for (final role in ['admin', 'supervisor', 'teacher']) {
        await tester.pumpWidget(_documentsApp(role: role, privileged: true));
        await tester.pump();
        expect(find.text('Recordings'), findsOneWidget);
        expect(find.text('Reports'), findsOneWidget);
        expect(find.text('Messages'), findsOneWidget);
      }
    },
  );

  testWidgets(
    'student and parent see messages only without forbidden requests',
    (tester) async {
      for (final role in ['student', 'parent']) {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        final documentsRepo = _DocumentsRepo();
        final chatRepo = _ChatRepo();
        await tester.pumpWidget(
          _documentsApp(
            role: role,
            privileged: false,
            documentsRepo: documentsRepo,
            chatRepo: chatRepo,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Messages'), findsOneWidget);
        expect(find.text('Recordings'), findsNothing);
        expect(find.text('Reports'), findsNothing);
        expect(documentsRepo.recordingCalls, 0);
        expect(documentsRepo.summaryCalls, 0);
        expect(chatRepo.roomIds, ['room-id'], reason: role);
      }
    },
  );

  testWidgets('messages-only tab supports RTL', (tester) async {
    await tester.pumpWidget(
      _documentsApp(
        role: 'student',
        privileged: false,
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
      ClassroomRecordingsResponse([]),
    );
  }

  @override
  getSummaries(String classroomId) async {
    summaryCalls++;
    return const Right<Failure, ClassroomSummariesResponse>(
      ClassroomSummariesResponse([]),
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
