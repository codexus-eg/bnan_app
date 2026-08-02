import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

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
