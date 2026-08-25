import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_bottom_nav_bar.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_student_bottom_nav_bar.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_bottom_nav_bar.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_bottom_nav_bar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => S.load(const Locale('en')));

  testWidgets('dot follows unread total and current room-read event', (
    tester,
  ) async {
    final repo = _RoomsRepo();
    final cache = ChatRoomsCache(SessionManager.instance);
    final cubit = GetChatRoomsCubit(repo, null, cache);
    addTearDown(cubit.close);
    await cubit.getChatRooms();
    await tester.pumpWidget(_app(cubit, _sharedBar()));
    expect(find.byKey(const Key('unreadBadgeDot')), findsNothing);

    repo.unreadCount = 3;
    await cubit.getChatRooms();
    await tester.pump();
    expect(find.byKey(const Key('unreadBadgeDot')), findsOneWidget);

    cache.markRoomRead('room-1');
    expect(cubit.totalUnreadCount, 0);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('unreadBadgeDot')), findsNothing);
  });

  testWidgets('all role message items opt into the shared unread dot', (
    tester,
  ) async {
    final cubit = GetChatRoomsCubit(_RoomsRepo()..unreadCount = 1);
    addTearDown(cubit.close);
    await cubit.getChatRooms();
    final bars = <Widget>[
      AdminBottomNavBar(currentIndex: 0, onTap: (_) {}),
      HomeStudentBottomNavBar(currentIndex: 0, onTap: (_) {}),
      TeacherBottomNavBar(currentIndex: 0, onTap: (_) {}),
      ParentBottomNavBar(currentIndex: 0, onTap: (_) {}),
    ];

    for (final bar in bars) {
      await tester.pumpWidget(_app(cubit, bar));
      final nav = tester.widget<CustomBottomNavBar>(
        find.byType(CustomBottomNavBar),
      );
      expect(
        nav.items.where((item) => item.tracksUnreadMessages),
        hasLength(1),
      );
      expect(find.byKey(const Key('unreadBadgeDot')), findsOneWidget);
    }

    final supervisorItems = SupervisorNavigationConfig.bottom(
      S.current,
    ).map((item) => item.toBottomItem());
    expect(
      supervisorItems.where((item) => item.tracksUnreadMessages),
      hasLength(1),
    );
  });
}

Widget _sharedBar() => CustomBottomNavBar(
  items: const [
    BottomNavItemModel(icon: ImageManager.homeIcon, title: 'Home'),
    BottomNavItemModel(
      icon: ImageManager.chatIcon,
      title: 'Messages',
      tracksUnreadMessages: true,
    ),
  ],
  currentIndex: 0,
  onTap: (_) {},
);

Widget _app(GetChatRoomsCubit cubit, Widget child) => BlocProvider.value(
  value: cubit,
  child: MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(bottomNavigationBar: child),
  ),
);

class _RoomsRepo implements ChatRepo {
  int unreadCount = 0;

  ChatRoomsResponseModel get response => ChatRoomsResponseModel(
    success: true,
    results: 1,
    rooms: [
      ChatRoomSummaryModel(
        id: 'room-1',
        type: 'support',
        displayName: 'Room',
        subtitle: '',
        unreadCount: unreadCount,
      ),
    ],
  );

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async =>
      Right(response);

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getAdminChatRooms({
    String? search,
  }) async => Right(response);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
