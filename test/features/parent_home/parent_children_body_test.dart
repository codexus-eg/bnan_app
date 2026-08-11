import 'dart:async';

import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_children/presentation/models/parent_add_child_args.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_curriculum_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_content.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shared provider loads once and survives index changes', (
    tester,
  ) async {
    await getIt.reset();
    addTearDown(getIt.reset);
    final repo = _FakeParentHomeRepo(
      () async => const Right(GetParentChildrenResponseModel()),
    );
    var cubitCreations = 0;
    getIt.registerFactory<GetParentChildrenCubit>(() {
      cubitCreations++;
      return GetParentChildrenCubit(repo);
    });
    getIt.registerFactory<GetParentSubscriptionsCubit>(
      () => GetParentSubscriptionsCubit(_FakeParentSubscriptionsRepo()),
    );

    await _pumpContent(tester, index: 0);
    await tester.pump();
    await _pumpContent(tester, index: 1);
    await tester.pump();

    expect(cubitCreations, 1);
    expect(repo.calls, 1);
  });

  testWidgets('loading displays the children skeleton', (tester) async {
    final pending =
        Completer<Either<Failure, GetParentChildrenResponseModel>>();
    final cubit = GetParentChildrenCubit(
      _FakeParentHomeRepo(() => pending.future),
    );
    addTearDown(cubit.close);
    unawaited(cubit.getParentChildren());

    await _pumpBody(tester, cubit);

    final skeleton = tester.widget<AppSkeletonizer>(
      find.byType(AppSkeletonizer),
    );
    expect(skeleton.isLoading, isTrue);
  });

  testWidgets('success displays real child fields', (tester) async {
    const child = ParentChildModel(
      id: 'child-1',
      fullName: 'Real Child',
      classroom: ParentChildClassroomModel(
        name: 'Class A',
        grade: ParentChildGradeModel(name: 'Grade 2'),
      ),
    );
    final cubit = await _successCubit(const [child]);
    addTearDown(cubit.close);

    await _pumpBody(tester, cubit);

    expect(find.text('Real Child'), findsOneWidget);
    expect(find.text('Class A - Grade 2'), findsOneWidget);
  });

  testWidgets('empty success displays localized no data state', (tester) async {
    final cubit = await _successCubit(const []);
    addTearDown(cubit.close);

    await _pumpBody(tester, cubit);

    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(find.text('No children are linked to this account'), findsOneWidget);
    expect(find.text('Add child'), findsOneWidget);
  });

  testWidgets('failure displays its message and retry reloads', (tester) async {
    final repo = _FakeParentHomeRepo(
      () async => Left(Failure(message: 'Unable to load children')),
    );
    final cubit = GetParentChildrenCubit(repo);
    addTearDown(cubit.close);
    await cubit.getParentChildren();

    await _pumpBody(tester, cubit);
    expect(find.text('Unable to load children'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(repo.calls, 2);
  });

  testWidgets('missing classroom and grade render without crashing', (
    tester,
  ) async {
    const children = [
      ParentChildModel(fullName: 'No Classroom'),
      ParentChildModel(
        fullName: 'No Grade',
        classroom: ParentChildClassroomModel(name: 'Class B'),
      ),
    ];
    final cubit = await _successCubit(children);
    addTearDown(cubit.close);

    await _pumpBody(tester, cubit);

    expect(find.byType(ParentChildCard), findsNWidgets(2));
    expect(find.text('- - -'), findsOneWidget);
    expect(find.text('Class B - -'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Add child opens directly with one child curriculum', (
    tester,
  ) async {
    final cubit = await _successCubit(const [_egyptianChild]);
    addTearDown(cubit.close);
    final captured = await _tapAddChild(tester, cubit);

    expect(captured.curriculumId, 'curriculum-1');
    expect(captured.registrationMode, 'egyptian');
    expect(find.text('Add Child Destination'), findsOneWidget);
    expect(find.text('Select Child'), findsNothing);
  });

  testWidgets('Add child opens directly with multiple matching children', (
    tester,
  ) async {
    const children = [_egyptianChild, _secondEgyptianChild];
    final cubit = await _successCubit(children);
    addTearDown(cubit.close);
    final captured = await _tapAddChild(tester, cubit);

    expect(captured.curriculumId, 'curriculum-1');
    expect(captured.registrationMode, 'egyptian');
    expect(find.text('Add Child Destination'), findsOneWidget);
    expect(find.text('Select Child'), findsNothing);
  });

  testWidgets('child card does not start Add child', (tester) async {
    final cubit = await _successCubit(const [_egyptianChild]);
    addTearDown(cubit.close);
    await _pumpBody(tester, cubit);

    await tester.tap(find.text('Egyptian Child'));
    await tester.pump();

    expect(find.byType(ParentChildrenBody), findsOneWidget);
    expect(find.byType(AddNewTopicButton), findsOneWidget);
  });
}

Future<ParentAddChildArgs> _tapAddChild(
  WidgetTester tester,
  GetParentChildrenCubit cubit,
) async {
  ParentAddChildArgs? captured;
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const ParentChildrenBody(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.parentAddChild,
        builder: (_, state) {
          captured = state.extra! as ParentAddChildArgs;
          return const Scaffold(body: Text('Add Child Destination'));
        },
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(_localizedRouter(router));
  await tester.tap(find.text('Add child'));
  await tester.pumpAndSettle();
  return captured!;
}

Widget _localizedRouter(GoRouter router) => MaterialApp.router(
  routerConfig: router,
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
);

Future<GetParentChildrenCubit> _successCubit(
  List<ParentChildModel> children,
) async {
  final cubit = GetParentChildrenCubit(
    _FakeParentHomeRepo(
      () async => Right(GetParentChildrenResponseModel(data: children)),
    ),
  );
  await cubit.getParentChildren();
  return cubit;
}

Future<void> _pumpBody(
  WidgetTester tester,
  GetParentChildrenCubit cubit,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: BlocProvider.value(
          value: cubit,
          child: const ParentChildrenBody(),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _pumpContent(WidgetTester tester, {required int index}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: ParentHomeContent(
          index: index,
          onMenuTap: _emptyCallback,
          onShowAllChildren: _emptyCallback,
        ),
      ),
    ),
  );
}

void _emptyCallback() {}

class _FakeParentHomeRepo implements ParentHomeRepo {
  _FakeParentHomeRepo(this.handler);

  final Future<Either<Failure, GetParentChildrenResponseModel>> Function()
  handler;
  int calls = 0;

  @override
  Future<Either<Failure, GetParentChildrenResponseModel>> getParentChildren() {
    calls++;
    return handler();
  }
}

class _FakeParentSubscriptionsRepo implements ParentSubscriptionsRepo {
  @override
  getSubscriptions() async => const Right(ParentSubscriptionsResponse());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _egyptianChild = ParentChildModel(
  id: 'child-1',
  fullName: 'Egyptian Child',
  registrationMode: RegistrationMode.egyptian,
  curriculum: ParentChildCurriculumModel(id: 'curriculum-1'),
);

const _secondEgyptianChild = ParentChildModel(
  id: 'child-2',
  fullName: 'Second Egyptian Child',
  registrationMode: RegistrationMode.egyptian,
  curriculum: ParentChildCurriculumModel(id: 'curriculum-1'),
);
