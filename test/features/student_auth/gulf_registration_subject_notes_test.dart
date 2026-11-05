import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/academic_selection_widgets/subject_note_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/data/repo/discount_preview_repo.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/subjects_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  group('Gulf Registration Subject Notes Unit & Contract Tests', () {
    test('1 & 2. Two subjects with different notes correctly mapped to subject IDs', () {
      const student = RegisterStudentModel(
        fullName: 'Ahmed Mohamed',
        email: 'ahmed@example.com',
        password: 'Pass',
        grade: 'grade-1',
        subjects: ['MATH_ID', 'ENG_ID'],
        subjectNotes: {
          'MATH_ID': 'Needs extra support in algebra',
          'ENG_ID': 'Focus on conversation skills',
        },
      );

      final json = student.toJson();
      expect(json['subjectNotes'], {
        'MATH_ID': 'Needs extra support in algebra',
        'ENG_ID': 'Focus on conversation skills',
      });
      expect(json['subjectNotes'] is Map, isTrue);
      expect((json['subjectNotes'] as Map)['MATH_ID'], 'Needs extra support in algebra');
      expect((json['subjectNotes'] as Map)['ENG_ID'], 'Focus on conversation skills');
    });

    test('3. One subject having notes and another having none omits empty note', () {
      const student = RegisterStudentModel(
        fullName: 'Ahmed Mohamed',
        email: 'ahmed@example.com',
        password: 'Pass',
        grade: 'grade-1',
        subjects: ['MATH_ID', 'ENG_ID'],
        subjectNotes: {
          'MATH_ID': 'Needs extra support in algebra',
          'ENG_ID': '   ',
        },
      );

      final json = student.toJson();
      expect(json['subjectNotes'], {
        'MATH_ID': 'Needs extra support in algebra',
      });
      expect((json['subjectNotes'] as Map).containsKey('ENG_ID'), isFalse);
    });

    test('4. No notes entered omits subjectNotes map completely', () {
      const student = RegisterStudentModel(
        fullName: 'Ahmed Mohamed',
        email: 'ahmed@example.com',
        password: 'Pass',
        grade: 'grade-1',
        subjects: ['MATH_ID', 'ENG_ID'],
        subjectNotes: {},
      );

      final json = student.toJson();
      expect(json.containsKey('subjectNotes'), isFalse);

      const studentNull = RegisterStudentModel(
        fullName: 'Ahmed Mohamed',
        email: 'ahmed@example.com',
        password: 'Pass',
        grade: 'grade-1',
        subjects: ['MATH_ID', 'ENG_ID'],
        subjectNotes: null,
      );
      expect(studentNull.toJson().containsKey('subjectNotes'), isFalse);
    });

    testWidgets('5. LengthLimitingTextInputFormatter enforces maximum 2000 chars in SubjectNoteField',
        (tester) async {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const SubjectNoteField(
                subjectId: 'MATH_ID',
                subjectName: 'الرياضيات',
              ),
            ),
          ),
        ),
      );

      final longText = 'A' * 2100;
      await tester.enterText(find.byType(TextField), longText);
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text.length, 2000);
      expect(cubit.subjectNotes['MATH_ID']?.length, 2000);
    });

    test('6. Wizard back/forward navigation preserves notes in RegisterCubit', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID');

      cubit.updateSubjectNote('MATH_ID', 'Preserved Note across steps');
      expect(cubit.state.currentStep, 1);

      cubit.nextStep();
      expect(cubit.state.currentStep, 2);
      expect(cubit.subjectNotes['MATH_ID'], 'Preserved Note across steps');

      cubit.nextStep();
      expect(cubit.state.currentStep, 3);
      expect(cubit.subjectNotes['MATH_ID'], 'Preserved Note across steps');

      cubit.previousStep();
      expect(cubit.state.currentStep, 2);
      expect(cubit.subjectNotes['MATH_ID'], 'Preserved Note across steps');
    });

    test('7. Subject deselection clears its note immediately', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID');

      cubit.updateSubjectNote('MATH_ID', 'Deselected Note');
      expect(cubit.subjectNotes['MATH_ID'], 'Deselected Note');

      cubit.toggleSubject('MATH_ID');
      expect(cubit.selectedSubjectIds.contains('MATH_ID'), isFalse);
      expect(cubit.subjectNotes.containsKey('MATH_ID'), isFalse);
    });

    test('8. Changing curriculum, grade, or package clears stale notes', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID');

      cubit.updateSubjectNote('MATH_ID', 'Initial Note');
      expect(cubit.subjectNotes['MATH_ID'], 'Initial Note');

      cubit.setGrade(id: 'grade-2', name: 'Grade 2');
      expect(cubit.subjectNotes, isEmpty);

      cubit.toggleSubject('ENG_ID');
      cubit.updateSubjectNote('ENG_ID', 'English Note');
      cubit.selectCurriculum(
        const CurriculumModel(
          id: 'curriculum-2',
          name: 'Gulf 2',
          baseCurriculum: 'gulf',
          icon: '',
          description: '',
          createdAt: '',
          updatedAt: '',
        ),
      );
      expect(cubit.subjectNotes, isEmpty);

      cubit.toggleSubject('SCI_ID');
      cubit.updateSubjectNote('SCI_ID', 'Science Note');
      cubit.selectPackage(const PackageModel(id: 'pkg-2', name: 'Package 2'));
      expect(cubit.subjectNotes, isEmpty);
    });

    test('9. Tamara checkout serialization includes student.subjectNotes and isMobile', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID')
        ..toggleSubject('ENG_ID');

      cubit.parentEmailController.text = 'parent@example.com';
      cubit.parentPasswordController.text = 'Parent123';
      cubit.studentNameController.text = 'Ahmed Mohamed';
      cubit.studentEmailController.text = 'ahmed@example.com';
      cubit.studentPasswordController.text = 'Student123';
      cubit.updateSubjectNote('MATH_ID', 'Needs extra support in algebra');
      cubit.updateSubjectNote('ENG_ID', 'Focus on conversation skills');

      final checkout = cubit.buildTamaraRequest(validateForm: false);
      expect(checkout, isNotNull);

      final json = checkout!.toJson();
      expect(json['provider'], 'tamara');
      expect(json['curriculum'], 'gulf-curr');
      expect(json['packageId'], 'package-1');
      expect(json['isMobile'], isTrue);
      expect(json['locale'], 'ar_SA');

      final studentJson = json['student'] as Map<String, dynamic>;
      expect(studentJson['fullName'], 'Ahmed Mohamed');
      expect(studentJson['subjects'], ['MATH_ID', 'ENG_ID']);
      expect(studentJson['subjectNotes'], {
        'MATH_ID': 'Needs extra support in algebra',
        'ENG_ID': 'Focus on conversation skills',
      });
    });

    test('10. Paymob checkout serialization includes student.subjectNotes with paymob provider', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID')
        ..selectPaymentProvider(GulfPaymentProvider.paymob);

      cubit.parentEmailController.text = 'parent@example.com';
      cubit.parentPasswordController.text = 'Parent123';
      cubit.studentNameController.text = 'Ahmed Mohamed';
      cubit.studentEmailController.text = 'ahmed@example.com';
      cubit.studentPasswordController.text = 'Student123';
      cubit.updateSubjectNote('MATH_ID', 'Paymob Note');

      final checkout = cubit.buildTamaraRequest(validateForm: false);
      expect(checkout, isNotNull);

      final json = checkout!.toJson();
      expect(json['provider'], 'paymob');
      expect(json.containsKey('paymentAddress'), isFalse);

      final studentJson = json['student'] as Map<String, dynamic>;
      expect(studentJson['subjectNotes'], {
        'MATH_ID': 'Paymob Note',
      });
    });

    test('11. Egyptian registration strictly excludes subjectNotes', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_egyptianArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID');

      cubit.parentEmailController.text = 'parent@example.com';
      cubit.parentPasswordController.text = 'Parent123';
      cubit.studentNameController.text = 'Ahmed Mohamed';
      cubit.studentEmailController.text = 'ahmed@example.com';
      cubit.studentPasswordController.text = 'Student123';

      final request = cubit.buildRegisterRequest();
      expect(request, isNotNull);

      final json = request!.toJson();
      final studentJson = json['student'] as Map<String, dynamic>;
      expect(studentJson.containsKey('subjectNotes'), isFalse);
    });

    test('12. Single-subject package items[] compatibility with subjectNotes', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfSingleSubjectArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1')
        ..toggleSubject('MATH_ID');

      cubit.parentEmailController.text = 'parent@example.com';
      cubit.parentPasswordController.text = 'Parent123';
      cubit.studentNameController.text = 'Ahmed Mohamed';
      cubit.studentEmailController.text = 'ahmed@example.com';
      cubit.studentPasswordController.text = 'Student123';
      cubit.updateSubjectNote('MATH_ID', 'Single Subject Note');

      final checkout = cubit.buildTamaraRequest(validateForm: false);
      expect(checkout, isNotNull);

      final json = checkout!.toJson();
      expect(json.containsKey('packageId'), isFalse);
      expect(json['items'], hasLength(1));
      expect(json['items'][0]['subjectId'], 'MATH_ID');
      expect(json['items'][0]['packageId'], 'package-single');

      final studentJson = json['student'] as Map<String, dynamic>;
      expect(studentJson['subjectNotes'], {
        'MATH_ID': 'Single Subject Note',
      });
    });

    test('13. Backend error handling for INVALID_SUBJECT_REQUEST_NOTES & SUBJECT_REQUEST_NOTES_TOO_LONG', () {
      final invalidNotesDioError = DioException(
        requestOptions: RequestOptions(path: '/payment/checkout'),
        response: Response(
          requestOptions: RequestOptions(path: '/payment/checkout'),
          statusCode: 400,
          data: {'code': 'INVALID_SUBJECT_REQUEST_NOTES', 'message': 'Invalid notes'},
        ),
        type: DioExceptionType.badResponse,
      );
      final exc1 = AppException.fromDio(invalidNotesDioError);
      expect(exc1.message, S.current.invalidSubjectRequestNotes);

      final tooLongDioError = DioException(
        requestOptions: RequestOptions(path: '/payment/checkout'),
        response: Response(
          requestOptions: RequestOptions(path: '/payment/checkout'),
          statusCode: 400,
          data: {'code': 'SUBJECT_REQUEST_NOTES_TOO_LONG', 'message': 'Too long'},
        ),
        type: DioExceptionType.badResponse,
      );
      final exc2 = AppException.fromDio(tooLongDioError);
      expect(exc2.message, S.current.subjectRequestNotesTooLong);
    });

    test('14. Admin/Teacher request models parse and display individual subject notes', () {
      final adminModel = AdminSubjectRequestModel.fromJson({
        'id': 'req-1',
        'status': 'pending',
        'studentName': 'Ahmed Mohamed',
        'notes': 'Needs extra support in algebra',
      });
      expect(adminModel.notes, 'Needs extra support in algebra');

      final adminEmptyModel = AdminSubjectRequestModel.fromJson({
        'id': 'req-2',
        'status': 'pending',
        'studentName': 'Ahmed Mohamed',
        'notes': '   ',
      });
      expect(adminEmptyModel.notes, isNull);
    });

    testWidgets('15. SubjectsList UI renders SubjectNoteField only for selected Gulf subjects, omitted for Egyptian', (tester) async {
      final registerCubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfArgs)
        ..setGrade(id: 'grade-1', name: 'Grade 1');

      final subjectsCubit = GetCurriculmSubjectsCubit(_FakeAuthRepo());
      final paymentCubit = TamaraPaymentCubit(
        repo: _FakeTamaraPaymentRepo(),
        authRepo: _FakeAuthRepo(),
        store: const PaymentDraftStore(),
      );
      final discountCubit = DiscountPreviewCubit(_FakeDiscountPreviewRepo());

      const subjects = [
        SubjectModel(id: 'MATH_ID', name: 'الرياضيات', grade: 'grade-1', curriculum: 'gulf-curr', isActive: true),
        SubjectModel(id: 'ENG_ID', name: 'اللغة الإنجليزية', grade: 'grade-1', curriculum: 'gulf-curr', isActive: true),
      ];
      subjectsCubit.emit(GetSubjectsSuccess(subjects: subjects));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: registerCubit),
                BlocProvider.value(value: subjectsCubit),
                BlocProvider.value(value: paymentCubit),
                BlocProvider.value(value: discountCubit),
              ],
              child: const SingleChildScrollView(child: SubjectsList()),
            ),
          ),
        ),
      );

      // Initially neither subject is selected; no notes field should exist
      expect(find.byType(SubjectNoteField), findsNothing);

      // Select Math
      await tester.tap(find.text('الرياضيات'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('subject_note_MATH_ID')), findsOneWidget);
      expect(find.byKey(const ValueKey('subject_note_ENG_ID')), findsNothing);

      // Enter note for Math
      await tester.enterText(
        find.descendant(
          of: find.byKey(const ValueKey('subject_note_MATH_ID')),
          matching: find.byType(TextField),
        ),
        'ملاحظة الرياضيات',
      );
      await tester.pump();
      expect(registerCubit.subjectNotes['MATH_ID'], 'ملاحظة الرياضيات');

      // Select English
      await tester.tap(find.text('اللغة الإنجليزية'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('subject_note_MATH_ID')), findsOneWidget);
      expect(find.byKey(const ValueKey('subject_note_ENG_ID')), findsOneWidget);

      // Enter note for English
      await tester.enterText(
        find.descendant(
          of: find.byKey(const ValueKey('subject_note_ENG_ID')),
          matching: find.byType(TextField),
        ),
        'ملاحظة الإنجليزي',
      );
      await tester.pump();
      expect(registerCubit.subjectNotes['MATH_ID'], 'ملاحظة الرياضيات');
      expect(registerCubit.subjectNotes['ENG_ID'], 'ملاحظة الإنجليزي');

      // Deselect English
      await tester.tap(find.text('اللغة الإنجليزية'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('subject_note_MATH_ID')), findsOneWidget);
      expect(find.byKey(const ValueKey('subject_note_ENG_ID')), findsNothing);
      expect(registerCubit.subjectNotes.containsKey('ENG_ID'), isFalse);
    });
  });
}

final _gulfArgs = RegisterFlowArgsModel(
  curriculumId: 'gulf-curr',
  curriculumName: 'Gulf',
  packageId: 'package-1',
  packageName: 'Package 1',
  packagePrice: '500',
  packageCurrency: 'SAR',
  registrationMode: 'gulf',
  accessScope: 'all_subjects',
);

final _gulfSingleSubjectArgs = RegisterFlowArgsModel(
  curriculumId: 'gulf-curr',
  curriculumName: 'Gulf',
  packageId: 'package-single',
  packageName: 'Package Single',
  packagePrice: '200',
  packageCurrency: 'SAR',
  registrationMode: 'gulf',
  accessScope: 'single_subject',
);

final _egyptianArgs = RegisterFlowArgsModel(
  curriculumId: 'egyptian-curr',
  curriculumName: 'Egyptian',
  packageId: 'package-eg',
  packageName: 'Package EG',
  packagePrice: '300',
  packageCurrency: 'EGP',
  registrationMode: 'egyptian',
  accessScope: 'all_subjects',
);

class _FakeAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGulfParentAuthRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTamaraPaymentRepo implements TamaraPaymentRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDiscountPreviewRepo implements DiscountPreviewRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
