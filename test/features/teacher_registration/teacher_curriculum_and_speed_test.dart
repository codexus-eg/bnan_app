import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_register_request_model.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_internet_proof_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => S.load(const Locale('ar')));

  test('curriculum step is valid without selecting additional curriculums', () {
    final cubit = TeacherRegistrationCubit(_FakeTeacherRepo());
    addTearDown(cubit.close);

    expect(
      cubit.validateTeachingCurriculumStep(),
      S.current.pleaseChooseTeachingCurriculum,
    );

    cubit.changeTeachingCurriculum(id: 'curriculum-1', name: 'Egyptian');
    expect(cubit.additionalCurriculumIds, isEmpty);
    expect(cubit.validateTeachingCurriculumStep(), isNull);
  });

  testWidgets('internet proof card displays fast.com speed test link', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(
          body: TeacherInternetProofCard(file: null, onTap: _noop),
        ),
      ),
    );

    expect(find.text('اختبر سرعة الإنترنت من هنا'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
  });
}

void _noop() {}

class _FakeTeacherRepo implements TeacherRegistrationRepo {
  @override
  Future<Either<Failure, AuthResponseModel>> registerTeacher({
    required TeacherRegisterRequestModel request,
  }) async => Left(Failure(message: 'error'));
}
