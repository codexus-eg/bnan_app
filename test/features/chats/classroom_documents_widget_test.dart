import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_details_sheet.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../lessons_management/fake_gulf_schedule_repo.dart';
import '../lessons_management/fake_start_session_repo.dart';

void main() {
  testWidgets('documents action appears for supported roles in classroom', (
    tester,
  ) async {
    for (final role in [
      'admin',
      'supervisor',
      'teacher',
      'student',
      'parent',
    ]) {
      await tester.pumpWidget(
        _app(
          ChatHeader(
            chatTitle: 'Class',
            roomId: 'room-id',
            roomType: 'classroom',
            currentUserRole: role,
          ),
        ),
      );
      expect(find.byKey(const Key('classroomDocumentsButton')), findsOneWidget);
    }
  });

  testWidgets('documents action hides for private or missing room id', (
    tester,
  ) async {
    for (final data in <(String, String)>[
      ('teacher_parent', 'room'),
      ('teacher_student', 'room'),
      ('support', 'room'),
      ('classroom', ' '),
    ]) {
      await tester.pumpWidget(
        _app(
          ChatHeader(
            chatTitle: 'Class',
            roomId: data.$2,
            roomType: data.$1,
            currentUserRole: 'student',
          ),
        ),
      );
      expect(find.byKey(const Key('classroomDocumentsButton')), findsNothing);
    }
  });

  testWidgets('documents navigation passes classroomId and never roomId', (
    tester,
  ) async {
    Object? received;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            body: ChatHeader(
              chatTitle: 'Class',
              roomId: 'room-id',
              roomType: 'classroom',
              classroomId: 'classroom-id',
              currentUserRole: 'teacher',
            ),
          ),
        ),
        GoRoute(
          path: Routes.classroomDocuments,
          builder: (_, state) {
            received = state.extra;
            return const Scaffold(body: Text('documents'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => _sessionCubit(),
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('classroomDocumentsButton')));
    await tester.pumpAndSettle();
    final args = received as ClassroomDocumentsRouteArgs;
    expect(args.roomId, 'room-id');
    expect(args.classroomId, 'classroom-id');
    expect(args.classroomId, isNot('room-id'));
  });

  testWidgets(
    'summary details hides optional sections and shows content fallback',
    (tester) async {
      const item = ClassroomSummaryItemModel(
        sessionName: 'Session',
        summary: ClassroomSummaryModel(
          title: null,
          content: null,
          docUrl: null,
          nextSteps: [],
        ),
      );
      await tester.pumpWidget(
        _app(const Scaffold(body: SummaryDetailsSheet(item: item))),
      );
      expect(find.text('No summary content is available'), findsOneWidget);
      expect(find.text('Open Document'), findsNothing);
      expect(find.text('Next Steps'), findsNothing);
    },
  );
}

Widget _app(Widget child) => BlocProvider(
  create: (_) => _sessionCubit(),
  child: MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: child,
  ),
);

StartSessionCubit _sessionCubit() => StartSessionCubit(
  FakeStartSessionRepo(),
  FakeGulfScheduleRepo(classrooms: const []),
  _TableRepo(),
);

class _TableRepo implements TableManagementRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
