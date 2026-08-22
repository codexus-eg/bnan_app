import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/parent_home_view.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_drawer_items.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fake_parent_schedule_repos.dart';

void main() {
  testWidgets('existing Parent schedule drawer item opens its route', (
    tester,
  ) async {
    final repo = FakeParentScheduleChildrenRepo(
      () async => const Right(GetParentChildrenResponseModel()),
    );
    getIt.registerSingleton<ParentHomeRepo>(repo);
    getIt.registerFactory(() => GetParentChildrenCubit(repo));
    getIt.registerFactory(
      () => GetParentSubscriptionsCubit(_FakeParentSubscriptionsRepo()),
    );
    addTearDown(getIt.reset);

    final router = GoRouter(
      initialLocation: Routes.parentHome,
      routes: [
        GoRoute(
          path: Routes.parentHome,
          builder: (_, _) => const ParentHomeView(),
        ),
        GoRoute(
          path: Routes.parentSchedule,
          builder: (_, _) => const Scaffold(body: Text('schedule-target')),
        ),
      ],
    );
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ParentHomeView));
    expect(parentDrawerItems(context), hasLength(10));
    expect(parentDrawerItems(context)[3].title, S.of(context).parentSchedule);

    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.of(context).parentSchedule));
    await tester.tap(find.text(S.of(context).parentSchedule));
    await tester.pumpAndSettle();

    expect(find.text('schedule-target'), findsOneWidget);
  });
}

Widget _app(GoRouter router) => MaterialApp.router(
  routerConfig: router,
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
);

class _FakeParentSubscriptionsRepo implements ParentSubscriptionsRepo {
  @override
  Future<Either<Failure, ParentSubscriptionsResponse>>
  getSubscriptions() async {
    return const Right(ParentSubscriptionsResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
