import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_drawer_items.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_role_navigation.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_room_navigation.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_drawer_items.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('all role message entries resolve to the shared rooms route', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      _localized(
        Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );

    final s = S.of(context);
    final adminItems = adminDrawerItems(context);
    final teacherItems = teacherDrawerItems(context);
    final studentItems = studentDrawerItems(context);
    final supervisorDrawer = SupervisorNavigationConfig.drawer(s);
    final supervisorBottom = SupervisorNavigationConfig.bottom(s);

    expect(ChatRoleNavigation.messagesRoute, Routes.groups);
    expect(adminItems[ChatRoleNavigation.adminDrawerIndex].title, s.messages);
    expect(teacherItems.last.title, s.messages);
    expect(
      ChatRoleNavigation.isTeacherMessagesIndex(
        teacherItems.length - 1,
        teacherItems.length,
      ),
      isTrue,
    );
    expect(
      studentItems[ChatRoleNavigation.studentDrawerIndex].title,
      s.messages,
    );
    expect(
      supervisorDrawer.singleWhere((item) => item.title == s.messages).route,
      Routes.groups,
    );
    expect(
      supervisorBottom.singleWhere((item) => item.title == s.messages).route,
      Routes.groups,
    );
  });

  test('all supported room types open chat with room id', () {
    for (final type in [
      'classroom',
      'teacher_parent',
      'teacher_student',
      'support',
    ]) {
      final room = _room(type: type);
      final args = ChatRoomNavigation.arguments(
        room,
        currentUserRole: 'teacher',
      );

      expect(ChatRoomNavigation.path(room), Routes.chatPath('room-id'));
      expect(args.roomType, type);
      expect(args.classroomId, type == 'classroom' ? 'classroom-id' : isNull);
      expect(
        args.classroomSubjectId,
        type == 'classroom' ? 'classroom-subject-id' : isNull,
      );
    }
  });

  test('invalid room id cannot create a chat destination', () {
    expect(ChatRoomNavigation.path(_room(type: 'support', id: '  ')), isNull);
  });
}

ChatRoomSummaryModel _room({required String type, String id = 'room-id'}) {
  return ChatRoomSummaryModel(
    id: id,
    type: type,
    displayName: 'Room',
    subtitle: '',
    classroomId: type == 'classroom' ? 'classroom-id' : null,
    classroomSubjectId: type == 'classroom' ? 'classroom-subject-id' : null,
  );
}

Widget _localized(Widget child) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(body: child),
);
