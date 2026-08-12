import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_content.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_placeholder_page.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<GetParentChildrenCubit>(() => _ParentChildrenCubit());
    getIt.registerFactory<GetParentSubscriptionsCubit>(
      () => _ParentSubscriptionsCubit(),
    );
    getIt.registerFactory<GetChatRoomsCubit>(() => _ChatRoomsCubit());
  });

  tearDown(() => getIt.reset());

  testWidgets(
    'parent messages tab uses real chat rooms instead of placeholder',
    (tester) async {
      await tester.pumpWidget(
        _localized(
          const ParentHomeContent(
            index: 2,
            onMenuTap: _noop,
            onShowAllChildren: _noop,
          ),
        ),
      );

      expect(find.byType(GroupsView), findsOneWidget);
      expect(find.byType(ParentPlaceholderPage), findsNothing);
    },
  );
}

void _noop() {}

class _ParentChildrenCubit extends GetParentChildrenCubit {
  _ParentChildrenCubit() : super(_ParentHomeRepo());

  @override
  Future<void> getParentChildren() async {}
}

class _ParentSubscriptionsCubit extends GetParentSubscriptionsCubit {
  _ParentSubscriptionsCubit() : super(_ParentSubscriptionsRepo());

  @override
  Future<void> load() async {}
}

class _ChatRoomsCubit extends GetChatRoomsCubit {
  _ChatRoomsCubit() : super(_ChatRepo());

  @override
  Future<void> getChatRooms() async {}
}

class _ParentHomeRepo implements ParentHomeRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ParentSubscriptionsRepo implements ParentSubscriptionsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ChatRepo implements ChatRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
