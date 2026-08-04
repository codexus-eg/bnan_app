import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('scroll requests page two and shows only a footer loader', (
    tester,
  ) async {
    final repo = _ScrollRepo();
    final cubit = GetSubjectsCubit(repo);
    await cubit.getSubjects();
    await tester.pumpWidget(_app(cubit));

    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pump();

    expect(repo.calls, [(1, 10), (2, 10)]);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Subject 0'), findsOneWidget);
    expect(find.text('Previous'), findsNothing);
    expect(find.text('Next'), findsNothing);

    repo.complete(_response(2, start: 10));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
    await cubit.close();
  });
}

Widget _app(GetSubjectsCubit cubit) {
  return BlocProvider.value(
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
      home: const Scaffold(body: SubjectManagementList()),
    ),
  );
}

class _ScrollRepo implements SubjectsRepo {
  final calls = <(int, int)>[];
  final completer = Completer<Either<Failure, SubjectsResponseModel>>();

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int limit,
  }) {
    calls.add((page, limit));
    if (page == 1) return Future.value(Right(_response(10)));
    return completer.future;
  }

  void complete(SubjectsResponseModel response) =>
      completer.complete(Right(response));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SubjectsResponseModel _response(int length, {int start = 0}) {
  return SubjectsResponseModel(
    success: true,
    length: length,
    data: List.generate(
      length,
      (index) => SubjectModel(
        id: '${start + index}',
        name: 'Subject ${start + index}',
        isActive: true,
      ),
    ),
  );
}
