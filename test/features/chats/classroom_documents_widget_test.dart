import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_details_sheet.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('documents action appears only for classroom with valid id', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const ChatHeader(
          chatTitle: 'Class',
          roomType: 'classroom',
          classroomId: 'c1',
        ),
      ),
    );
    expect(find.byKey(const Key('classroomDocumentsButton')), findsOneWidget);

    for (final data in <(String, String?)>[
      ('classroom', null),
      ('teacher_parent', 'c1'),
      ('teacher_student', 'c1'),
      ('support', 'c1'),
    ]) {
      await tester.pumpWidget(
        _app(
          ChatHeader(
            chatTitle: 'Class',
            roomType: data.$1,
            classroomId: data.$2,
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
              roomType: 'classroom',
              classroomId: 'classroom-id',
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
      MaterialApp.router(
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
    );
    await tester.tap(find.byKey(const Key('classroomDocumentsButton')));
    await tester.pumpAndSettle();
    final args = received as ClassroomDocumentsRouteArgs;
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

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: child,
);
