import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_session_action.dart';
import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('active chat session is enterable by allowed roles', (
    tester,
  ) async {
    for (final role in [
      UserRole.student,
      UserRole.supervisor,
      UserRole.admin,
    ]) {
      final cubit = _Cubit(_activeState());
      await tester.pumpWidget(_app(cubit, _action(role)));
      expect(find.text(S.current.joinSession), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await cubit.close();
    }
  });

  testWidgets('teacher starts scheduled session then joins active session', (
    tester,
  ) async {
    var cubit = _Cubit(const StartSessionState(scheduledChatRoomIds: {'room'}));
    await tester.pumpWidget(_app(cubit, _action(UserRole.teacher)));
    expect(find.text(S.current.startSession), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await cubit.close();

    cubit = _Cubit(_activeState());
    await tester.pumpWidget(_app(cubit, _action(UserRole.teacher)));
    expect(find.text(S.current.joinSession), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await cubit.close();
  });

  testWidgets(
    'teacher sees Start Session even when active session is next occurrence with canStart=false',
    (tester) async {
      final cubit = _Cubit(
        const StartSessionState(
          scheduledChatRoomIds: {'room'},
          scheduledClassroomIds: {'class'},
          dueLessonsByClassroom: {
            'class': ScheduledLessonData(
              classroomId: 'class',
              chatRoomId: 'room',
              occurrenceDate: '2026-10-24',
            ),
          },
          activeByClassroom: {
            'class': StartSessionData(
              session: StartedSession(
                id: '',
                status: 'scheduled',
                activeOccurrence: false,
                canStart: false,
                startStatus: 'NOT_OPEN',
                occurrenceKey: 'course:class:2026-10-26:monday:23:23',
                chatRoomId: 'other-room',
              ),
              meetingLink: '',
            ),
          },
        ),
      );
      await tester.pumpWidget(_app(cubit, _action(UserRole.teacher)));
      expect(find.text(S.current.startSession), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await cubit.close();
    },
  );

  testWidgets(
    'parent has no session action and narrow header does not overflow',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      final cubit = _Cubit(_activeState());
      await tester.pumpWidget(
        _app(
          cubit,
          const ChatHeader(
            chatTitle: 'A very long classroom group name that must be clipped',
            roomId: 'room',
            roomType: 'classroom',
            classroomId: 'class',
            currentUserRole: 'supervisor',
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        _app(
          cubit,
          const ChatHeader(
            chatTitle: 'Parent room',
            roomId: 'room',
            roomType: 'classroom',
            classroomId: 'class',
            currentUserRole: 'parent',
          ),
        ),
      );
      expect(find.byType(ChatSessionAction), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await cubit.close();
      await tester.binding.setSurfaceSize(null);
    },
  );
}

ChatSessionAction _action(UserRole role) =>
    ChatSessionAction(classroomId: 'class', roomId: 'room', role: role);

StartSessionState _activeState() => const StartSessionState(
  activeByClassroom: {
    'class': StartSessionData(
      session: StartedSession(
        id: 'session',
        status: 'live',
        activeOccurrence: true,
        joinPermission: true,
        chatRoomId: 'room',
      ),
      meetingLink: 'https://zoom.us/j/session',
    ),
  },
);

Widget _app(StartSessionCubit cubit, Widget child) => BlocProvider.value(
  value: cubit,
  child: MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(body: child),
  ),
);

class _Cubit extends StartSessionCubit {
  _Cubit(StartSessionState initial)
    : super(_StartRepo(), _GulfRepo(), _TableRepo()) {
    emit(initial);
  }

  @override
  Future<void> loadActive(String classroomId) async {}

  @override
  Future<void> loadScheduledLessons() async {}
}

class _StartRepo implements StartSessionRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GulfRepo implements GulfScheduleRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TableRepo implements TableManagementRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
