import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/curriculum_management/data/models/create_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculums_response_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/update_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/dialogs/curriculm_form_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('curriculum form remains scrollable above a keyboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 560);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.reset);
    final cubit = CurriculumActionsCubit(_Repo());
    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(S.current.save),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(S.current.save), findsOneWidget);
    await cubit.close();
  });
}

Widget _app(CurriculumActionsCubit cubit) => BlocProvider.value(
  value: cubit,
  child: MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const Scaffold(body: CurriculumFormDialog()),
  ),
);

class _Repo implements CurriculumManagementRepo {
  @override
  Future<Either<Failure, CurriculumModel>> createCurriculum(
    CreateCurriculumRequestModel request,
  ) => throw UnimplementedError();
  @override
  Future<Either<Failure, CurriculumsResponseModel>> getCurriculums() =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, CurriculumModel>> updateCurriculum({
    required String curriculumId,
    required UpdateCurriculumRequestModel request,
  }) => throw UnimplementedError();
}
