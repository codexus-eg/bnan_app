import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/parent_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/parent_home_view.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_bottom_nav_bar.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('subscriptions cubit loads lazily and survives tab changes', (
    tester,
  ) async {
    await getIt.reset();
    addTearDown(getIt.reset);
    final repo = _SubscriptionsRepo();
    var creations = 0;
    getIt.registerFactory<GetParentSubscriptionsCubit>(() {
      creations++;
      return GetParentSubscriptionsCubit(repo);
    });

    await tester.pumpWidget(_app(const ParentHomeView()));
    expect(creations, 1);
    expect(repo.calls, 0);

    _selectTab(tester, 3);
    await tester.pump();
    await tester.pump();
    expect(repo.calls, 1);

    _selectTab(tester, 0);
    await tester.pump();
    _selectTab(tester, 3);
    await tester.pump();
    expect(creations, 1);
    expect(repo.calls, 1);
  });
}

void _selectTab(WidgetTester tester, int index) => tester
    .widget<ParentBottomNavBar>(find.byType(ParentBottomNavBar))
    .onTap(index);

Widget _app(Widget child) => BlocProvider(
  create: (_) => DashboardCubit(_DashboardRepo(), DashboardRole.parent),
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

class _SubscriptionsRepo implements ParentSubscriptionsRepo {
  int calls = 0;
  @override
  getSubscriptions() async {
    calls++;
    return const Right(ParentSubscriptionsResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DashboardRepo implements DashboardRepo {
  @override
  getDashboard() async => const Right(
    ParentDashboardModel(
      generatedAt: null,
      childrenCount: 0,
      certificates: 0,
      evaluations: 0,
      subscriptions: 0,
      children: [],
    ),
  );
}
