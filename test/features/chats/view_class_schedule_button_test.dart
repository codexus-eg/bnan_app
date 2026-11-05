import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/view_class_schedule_button.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders viewClassScheduleButton in ChatHeader when classroomId is present', (
    tester,
  ) async {
    final cubit = _Cubit();
    await tester.pumpWidget(
      BlocProvider<StartSessionCubit>.value(
        value: cubit,
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(
            body: ChatHeader(
              chatTitle: 'فصل لغتي',
              roomId: 'room-1',
              classroomId: 'classroom-1',
              currentUserRole: 'teacher',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ViewClassScheduleButton), findsOneWidget);
    expect(find.byKey(const Key('viewClassScheduleButton')), findsOneWidget);
    expect(find.text(S.current.viewClassSchedule), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await cubit.close();
  });
}

class _Cubit extends StartSessionCubit {
  _Cubit() : super(_StartRepo(), _GulfRepo(), _TableRepo());

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
