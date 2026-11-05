import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/student_info_step.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Simplified Student Registration Flow', () {
    test('RegisterCubit dynamic selection and validation methods work correctly', () {
      final cubit = RegisterCubit(_AuthRepo(), _GulfParentAuthRepo());
      addTearDown(cubit.close);

      expect(cubit.validateStudentInfo(), isFalse);
      expect(cubit.validateAcademicSelection(), isFalse);

      cubit.studentNameController.text = 'Ahmed Ali';
      cubit.studentEmailController.text = 'ahmed@example.com';
      cubit.studentPasswordController.text = 'password123';

      expect(cubit.studentNameController.text.isNotEmpty, isTrue);

      const curriculum = CurriculumModel(
        id: 'curriculum-1',
        name: 'Egyptian Curriculum',
        baseCurriculum: '',
        icon: '',
        description: '',
        createdAt: '',
        updatedAt: '',
        registrationMode: 'egyptian',
      );
      cubit.selectCurriculum(curriculum);

      expect(cubit.curriculumId, 'curriculum-1');
      expect(cubit.curriculumName, 'Egyptian Curriculum');
      expect(cubit.registrationMode, 'egyptian');
      expect(cubit.isGulf, isFalse);

      cubit.setGrade(id: 'grade-1', name: 'Primary 1');
      expect(cubit.selectedGradeId, 'grade-1');

      const package = PackageModel(
        id: 'pkg-1',
        name: 'All Subjects Package',
        accessScope: 'all_subjects',
        price: 500,
        currency: 'EGP',
        isActive: true,
      );
      cubit.selectPackage(package);

      expect(cubit.packageId, 'pkg-1');
      expect(cubit.packageName, 'All Subjects Package');
      expect(cubit.validateAcademicSelection(), isTrue);
    });

    testWidgets('StudentInfoStep contains only name, email and password fields', (tester) async {
      final cubit = RegisterCubit(_AuthRepo(), _GulfParentAuthRepo());
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
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
              child: const StudentInfoStep(),
            ),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
      expect(find.text(S.current.studentName), findsOneWidget);
      expect(find.text(S.current.studentEmail), findsOneWidget);
      expect(find.text(S.current.studentPasswordField), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsNothing);
    });
  });
}

class _AuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GulfParentAuthRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
