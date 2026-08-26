import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_egyptian_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_gulf_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_submission.dart';
import 'package:bnan_app/features/parent_children/data/repo/parent_add_child_repo.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_grade_step.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.load(const Locale('en'));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (_) async => null,
        );
  });

  test('grade changes reset dependent subject selections', () async {
    final cubit = _cubit(_Repo());
    cubit.selectGrade(_grade);
    cubit.selectPackage(_allPackage);
    cubit.toggleSubject('subject-1');

    cubit.selectGrade(const AcademicGradeModel(id: 'g2', name: 'Grade 2'));
    expect(cubit.state.selectedSubjectIds, isEmpty);
    expect(cubit.state.curriculum, same(_egypt));
    await cubit.close();
  });

  test('starts with the source child curriculum already selected', () async {
    final egyptian = _cubit(_Repo(), curriculum: _egypt);
    final gulf = _cubit(_Repo(), curriculum: _gulf);
    expect(egyptian.state.curriculum, same(_egypt));
    expect(egyptian.state.isGulf, isFalse);
    expect(gulf.state.curriculum, same(_gulf));
    expect(gulf.state.isGulf, isTrue);
    await egyptian.close();
    await gulf.close();
  });

  test('existing family curriculum cannot be replaced', () async {
    final cubit = _cubit(_Repo());
    cubit.selectCurriculum(_gulf);
    expect(cubit.state.curriculum, same(_egypt));
    await cubit.close();
  });

  test('first child selects curriculum manually', () async {
    final cubit = ParentAddChildCubit(repo: _Repo(), keyGenerator: _Keys())
      ..start(null, parentHasChildren: false);
    cubit.selectCurriculum(_gulf);
    expect(cubit.state.curriculum, same(_gulf));
    expect(cubit.state.parentHasChildren, isFalse);
    await cubit.close();
  });

  test('all subjects accepts multiple selections', () async {
    final cubit = _cubit(_Repo())
      ..selectGrade(_grade)
      ..selectPackage(_allPackage)
      ..toggleSubject('subject-1')
      ..toggleSubject('subject-2');
    expect(cubit.state.selectedSubjectIds, ['subject-1', 'subject-2']);
    await cubit.close();
  });

  testWidgets('all-subject package selects every loaded grade subject', (
    tester,
  ) async {
    final parent = _cubit(_Repo())..selectPackage(_allPackage);
    final lookups = AcademicLookupsCubit(
      repo: _LookupRepo(),
      loadClassroomsOnGrade: false,
      loadSubjectsWithoutClassroom: true,
    );
    await lookups.selectCurriculum(_egypt);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: parent),
          BlocProvider.value(value: lookups),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(body: ParentGradeStep()),
        ),
      ),
    );

    tester.widget<CustomDropdown>(find.byType(CustomDropdown)).onChanged!(
      _grade.id,
    );
    await tester.pumpAndSettle();
    expect(parent.state.selectedSubjectIds, [
      'subject-1',
      'subject-2',
      'subject-3',
    ]);
    await parent.close();
    await lookups.close();
  });

  test('simple child password is accepted by registration rules', () async {
    final cubit = _cubit(_Repo())..selectPackage(_allPackage);
    expect(cubit.nextStep(), isTrue);
    cubit.selectGrade(_grade);
    expect(cubit.nextStep(), isTrue);
    cubit.updateAccount(
      fullName: 'Student Name',
      email: 'student@example.com',
      password: 'password',
    );
    expect(cubit.nextStep(), isTrue);
    expect(cubit.state.currentStep, 4);
    await cubit.close();
  });

  test('Egyptian all-subject request submits every grade subject', () async {
    final repo = _Repo();
    final cubit = _cubit(repo)
      ..updateAccount(
        fullName: 'Student Name',
        email: 'student@example.com',
        password: 'Password1',
      );
    expect(cubit.state.lastStep, 4);
    cubit.selectPackage(_allPackage);
    expect(cubit.nextStep(), isTrue);
    cubit.selectGrade(_grade);
    expect(cubit.nextStep(), isTrue);
    cubit.updateAccount(
      fullName: 'Student Name',
      email: 'student@example.com',
      password: 'Password1',
    );
    expect(cubit.nextStep(), isTrue);
    cubit.setGradeSubjectIds(['subject-1', 'subject-2', 'subject-3']);
    expect(cubit.nextStep(), isTrue);
    await cubit.submit();
    expect(repo.egyptianCalls, 1);
    expect(repo.lastEgyptianRequest?.student.subjectIds, [
      'subject-1',
      'subject-2',
      'subject-3',
    ]);
    expect(cubit.state.receipt, isNull);
    expect(cubit.state.phase, ParentAddChildPhase.pendingReview);
    await cubit.close();
  });

  for (final subjects in const <List<String>>[
    [],
    ['subject-1'],
    ['subject-1', 'subject-2'],
    ['subject-1', 'subject-2', 'subject-3'],
  ]) {
    test(
      'Parent Egyptian private accepts ${subjects.length} subjects',
      () async {
        final repo = _Repo();
        final cubit = _cubit(repo)..selectPackage(_singlePackage);
        expect(cubit.nextStep(), isTrue);
        cubit.selectGrade(_grade);
        expect(cubit.nextStep(), isTrue);
        cubit.updateAccount(
          fullName: 'Student Name',
          email: 'student@example.com',
          password: 'Password1',
        );
        expect(cubit.nextStep(), isTrue);
        for (final subject in subjects) {
          cubit.toggleSubject(subject);
        }

        final valid = cubit.nextStep();
        expect(valid, subjects.isNotEmpty);
        if (subjects.isEmpty) {
          expect(
            cubit.state.errorMessage,
            isNot(S.current.parentSingleSubjectRequired),
          );
          expect(repo.egyptianCalls, 0);
        } else {
          await cubit.submit();
          expect(repo.lastEgyptianRequest?.student.subjectIds, subjects);
        }
        await cubit.close();
      },
    );
  }

  for (final subjects in const <List<String>>[
    [],
    ['subject-1'],
    ['subject-1', 'subject-2'],
    ['subject-1', 'subject-2', 'subject-3'],
  ]) {
    test('Parent Gulf private accepts ${subjects.length} subjects', () async {
      final repo = _Repo()..statuses.add(_status(PaymentStatus.completed));
      final cubit = _cubit(repo, curriculum: _gulf)
        ..selectPackage(_singlePackage);
      expect(cubit.nextStep(), isTrue);
      cubit.selectGrade(_grade);
      expect(cubit.nextStep(), isTrue);
      cubit.updateAccount(
        fullName: 'Student Name',
        email: 'student@example.com',
        password: 'Password1',
      );
      expect(cubit.nextStep(), isTrue);
      for (final subject in subjects) {
        cubit.toggleSubject(subject);
      }

      final valid = cubit.nextStep();
      expect(valid, subjects.isNotEmpty);
      if (subjects.isNotEmpty) {
        expect(cubit.nextStep(), isTrue);
        await cubit.submit();
        expect(repo.lastGulfRequest?.student.subjectIds, subjects);
      }
      await cubit.close();
    });
  }

  test('Gulf private checkout maps selected subjects to final items', () async {
    final repo = _Repo()..statuses.add(_status(PaymentStatus.completed));
    final cubit = _cubit(repo, curriculum: _gulf)
      ..selectPackage(_singlePackage);
    expect(cubit.nextStep(), isTrue);
    cubit.selectGrade(_grade);
    expect(cubit.nextStep(), isTrue);
    cubit.updateAccount(
      fullName: 'Student Name',
      email: 'student@example.com',
      password: 'Password1',
    );
    expect(cubit.nextStep(), isTrue);
    cubit.toggleSubject('subject-1');
    cubit.toggleSubject('subject-2');
    expect(cubit.nextStep(), isTrue);
    expect(cubit.nextStep(), isTrue);

    await cubit.submit();

    final json = repo.lastGulfRequest!.toJson();
    expect(json.containsKey('packageId'), isFalse);
    expect(json['items'], [
      {'subjectId': 'subject-1', 'packageId': 'single'},
      {'subjectId': 'subject-2', 'packageId': 'single'},
    ]);
    expect((json['student'] as Map<String, dynamic>)['subjects'], [
      'subject-1',
      'subject-2',
    ]);
    await cubit.close();
  });

  test('completed Gulf payment preserves parent session', () async {
    try {
      await SessionManager.instance.saveSession(
        accessToken: 'parent-token',
        refreshToken: 'parent-refresh',
        userRole: UserRole.parent.name,
      );
    } catch (_) {}
    final repo = _Repo()..statuses.add(_status(PaymentStatus.completed));
    final cubit = _readyGulf(repo);
    await cubit.submit();
    await cubit.verifyPaymentSuccess();

    expect(cubit.state.phase, ParentAddChildPhase.completed);
    expect(SessionManager.instance.accessToken, 'parent-token');
    expect(SessionManager.instance.role, UserRole.parent);
    await cubit.close();
    try {
      await SessionManager.instance.clearSession();
    } catch (_) {}
  });

  for (final terminal in [
    PaymentStatus.failed,
    PaymentStatus.cancelled,
    PaymentStatus.expired,
  ]) {
    test('$terminal allows retry with a new idempotency key', () async {
      final repo = _Repo()
        ..statuses.addAll([
          _status(terminal),
          _status(PaymentStatus.completed),
        ]);
      final cubit = _readyGulf(repo);
      await cubit.submit();
      await cubit.verifyPaymentSuccess();
      expect(cubit.state.phase, ParentAddChildPhase.failure);
      await cubit.retryPayment();
      await cubit.verifyPaymentSuccess();
      expect(cubit.state.phase, ParentAddChildPhase.completed);
      expect(repo.keys, ['key-1', 'key-2']);
      await cubit.close();
    });
  }

  test('duplicate submit is ignored while checkout is pending', () async {
    final repo = _Repo(checkoutDelay: const Duration(milliseconds: 20))
      ..statuses.add(_status(PaymentStatus.completed));
    final cubit = _readyGulf(repo);
    await Future.wait([cubit.submit(), cubit.submit()]);
    expect(repo.checkoutCalls, 1);
    await cubit.close();
  });

  test('uncertain checkout retry reuses the same idempotency key', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final cubit = _readyGulf(repo);
    await cubit.submit();
    await cubit.submit();
    expect(repo.keys, ['key-1', 'key-1']);
    await cubit.close();
  });

  test(
    'server checkout failure retry reuses the same idempotency key',
    () async {
      final repo = _Repo()
        ..checkoutFailures.add(
          Failure(
            message: 'checkout failed',
            responseReceived: true,
            statusCode: 500,
          ),
        );
      final cubit = _readyGulf(repo);
      await cubit.submit();
      await cubit.submit();
      expect(repo.keys, ['key-1', 'key-1']);
      await cubit.close();
    },
  );

  test('same payload restores its key after cubit recreation', () async {
    final store = _MemoryStore();
    final firstRepo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final first = _readyGulf(firstRepo, store: store);
    await first.submit();
    await first.close();

    final laterKeys = _Keys()..count = 40;
    final secondRepo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final second = _readyGulf(
      secondRepo,
      store: store,
      keyGenerator: laterKeys,
    );
    await second.submit();

    expect(firstRepo.keys, ['key-1']);
    expect(secondRepo.keys, ['key-1']);
    await second.close();
  });

  test('checkout context is persisted before launch', () async {
    final store = _MemoryStore();
    final cubit = _readyGulf(_Repo(), store: store);
    await cubit.submit();

    expect(store.value?.paymentId, 'payment-1');
    expect(store.value?.checkoutUrl, 'https://checkout.example.com');
    expect(store.value?.idempotencyKey, 'key-1');
    expect(cubit.state.shouldOpenCheckout, isTrue);
    await cubit.close();
  });

  test('payment input error stays on its editable step', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(
          message: 'Please update the parent payment phone.',
          code: 'INVALID_PAYMENT_PHONE',
          responseReceived: true,
          statusCode: 422,
        ),
      );
    final cubit = _readyGulf(repo);
    await cubit.submit();

    expect(cubit.state.phase, ParentAddChildPhase.editing);
    expect(cubit.state.currentStep, 5);
    expect(cubit.state.errorMessage, 'Please update the parent payment phone.');
    await cubit.close();
  });

  test('payload change after timeout creates a new key', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final cubit = _readyGulf(repo);
    await cubit.submit();
    cubit.updateDiscount('NEW');
    await cubit.submit();
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test(
    'polling exhaustion leaves processing and supports manual check',
    () async {
      final repo = _Repo();
      final cubit = _readyGulf(repo);
      await cubit.submit();
      await cubit.verifyPaymentSuccess();
      expect(cubit.state.phase, ParentAddChildPhase.paymentStatusUnknown);
      repo.statuses.add(_status(PaymentStatus.completed));
      await cubit.checkPaymentStatus();
      expect(cubit.state.phase, ParentAddChildPhase.completed);
      await cubit.close();
    },
  );

  test('checkout URL can be reopened after polling timeout', () async {
    final repo = _Repo();
    final cubit = _readyGulf(repo);
    await cubit.submit();
    await cubit.verifyPaymentSuccess();
    expect(cubit.state.phase, ParentAddChildPhase.paymentStatusUnknown);
    cubit.reopenCheckout();
    expect(cubit.state.shouldOpenCheckout, isTrue);
    expect(cubit.state.checkoutUrl, 'https://checkout.example.com');
    expect(repo.checkoutCalls, 1);
    await cubit.close();
  });

  test('Tamara back checks once and keeps checkout retryable', () async {
    final repo = _Repo();
    final cubit = _readyGulf(repo);
    await cubit.submit();

    await cubit.checkoutClosed();

    expect(cubit.state.phase, ParentAddChildPhase.paymentStatusUnknown);
    expect(cubit.state.isBusy, isFalse);
    expect(repo.reconcileCalls, 1);
    expect(repo.statusCalls, 1);
    cubit.reopenCheckout();
    expect(cubit.state.shouldOpenCheckout, isTrue);
    expect(repo.checkoutCalls, 1);
    await cubit.close();
  });

  test('Paymob status check does not call reconcile', () async {
    final repo = _Repo();
    final cubit = _readyGulf(repo, provider: GulfPaymentProvider.paymob);
    await cubit.submit();
    await cubit.checkoutClosed();
    expect(repo.reconcileCalls, 0);
    expect(repo.statusCalls, 1);
    await cubit.close();
  });

  test('add-child restore ignores a registration draft', () async {
    final store = _MemoryStore()
      ..value = PaymentDraft(
        paymentId: 'registration-payment',
        idempotencyKey: 'saved-key',
        packageId: 'package-1',
        curriculumId: _gulf.id,
        gradeId: 'grade-1',
        subjectIds: const ['subject-1'],
        studentEmail: 'student@example.com',
        paymentStartedAt: DateTime(2026),
        lastKnownStatus: PaymentStatus.pending,
        purpose: PaymentDraftPurpose.registration,
      );
    final cubit = _cubit(_Repo(), curriculum: _gulf, store: store);
    expect(cubit.state.paymentId, isNull);
    expect(store.value?.purpose, PaymentDraftPurpose.registration);
    await cubit.close();
  });

  test('unknown registration mode cannot submit', () async {
    const unknown = AcademicCurriculumModel(id: 'x', name: 'Unknown');
    final cubit = _cubit(_Repo(), curriculum: unknown);
    cubit.selectPackage(_allPackage);
    expect(cubit.state.package, isNull);
    await cubit.close();
  });
}

const _egypt = AcademicCurriculumModel(
  id: 'egypt',
  name: 'Egypt',
  registrationMode: 'egyptian',
);
const _gulf = AcademicCurriculumModel(
  id: 'gulf',
  name: 'Gulf',
  registrationMode: 'gulf',
);
const _grade = AcademicGradeModel(id: 'grade', name: 'Grade');
const _allPackage = PackageModel(
  id: 'all',
  name: 'All',
  type: 'monthly',
  accessScope: PackageAccessScope.allSubjects,
  isActive: true,
);
final _singlePackage = PackageModel.fromJson({
  'id': 'single',
  'name': 'Single',
  'packageType': 'hours',
  'accessScope': PackageAccessScope.singleSubject,
  'isActive': true,
});

ParentAddChildCubit _cubit(
  _Repo repo, {
  AcademicCurriculumModel curriculum = _egypt,
  PaymentDraftStore? store,
  IdempotencyKeyGenerator? keyGenerator,
  GulfPaymentProvider provider = GulfPaymentProvider.tamara,
}) => ParentAddChildCubit(
  repo: repo,
  keyGenerator: keyGenerator ?? _Keys(),
  store: store,
  pollInterval: Duration.zero,
  maxPollAttempts: 2,
  provider: provider,
)..start(curriculum);

ParentAddChildCubit _readyGulf(
  _Repo repo, {
  PaymentDraftStore? store,
  IdempotencyKeyGenerator? keyGenerator,
  GulfPaymentProvider provider = GulfPaymentProvider.tamara,
}) {
  final cubit = _cubit(
    repo,
    curriculum: _gulf,
    store: store,
    keyGenerator: keyGenerator,
    provider: provider,
  )..selectPackage(_allPackage);
  expect(cubit.nextStep(), isTrue);
  cubit.selectGrade(_grade);
  expect(cubit.nextStep(), isTrue);
  cubit.updateAccount(
    fullName: 'Student Name',
    email: 'student@example.com',
    password: 'Password1',
  );
  expect(cubit.nextStep(), isTrue);
  cubit.toggleSubject('subject-1');
  expect(cubit.nextStep(), isTrue);
  expect(cubit.nextStep(), isTrue);
  return cubit;
}

TamaraStatusResponse _status(PaymentStatus status) =>
    TamaraStatusResponse(paymentId: 'payment-1', status: status);

class _Keys extends IdempotencyKeyGenerator {
  int count = 0;
  @override
  String create() => 'key-${++count}';
}

class _Repo implements ParentAddChildRepo {
  _Repo({this.checkoutDelay = Duration.zero});
  final Duration checkoutDelay;
  final List<TamaraStatusResponse> statuses = [];
  final List<Failure> checkoutFailures = [];
  final List<String> keys = [];
  int checkoutCalls = 0;
  int egyptianCalls = 0;
  int reconcileCalls = 0, statusCalls = 0;
  ParentAddChildEgyptianRequest? lastEgyptianRequest;
  ParentAddChildGulfRequest? lastGulfRequest;

  @override
  registerEgyptian(ParentAddChildEgyptianRequest request) async {
    lastEgyptianRequest = request;
    egyptianCalls++;
    return const Right(ParentAddChildSubmission(status: 'pending_review'));
  }

  @override
  checkoutGulf({
    required ParentAddChildGulfRequest request,
    required String idempotencyKey,
  }) async {
    checkoutCalls++;
    lastGulfRequest = request;
    keys.add(idempotencyKey);
    await Future<void>.delayed(checkoutDelay);
    if (checkoutFailures.isNotEmpty) {
      return Left(checkoutFailures.removeAt(0));
    }
    return const Right(
      TamaraCheckoutResponse(
        paymentId: 'payment-1',
        checkoutUrl: 'https://checkout.example.com',
        orderId: 'order-1',
        status: 'pending',
        providerStatus: 'pending',
      ),
    );
  }

  @override
  reconcile(String paymentId) async {
    reconcileCalls++;
    return Right(
      statuses.isEmpty ? _status(PaymentStatus.pending) : statuses.removeAt(0),
    );
  }

  @override
  status(
    String paymentId, {
    GulfPaymentProvider provider = GulfPaymentProvider.tamara,
  }) async {
    statusCalls++;
    return Right(_status(PaymentStatus.pending));
  }
}

class _LookupRepo implements AcademicLookupsRepo {
  @override
  getGrades({String? curriculumId}) async => const Right([_grade]);

  @override
  getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) async => const Right([
    AcademicSubjectModel(id: 'subject-1', name: 'Subject 1'),
    AcademicSubjectModel(id: 'subject-2', name: 'Subject 2'),
    AcademicSubjectModel(id: 'subject-3', name: 'Subject 3'),
  ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MemoryStore extends PaymentDraftStore {
  PaymentDraft? value;

  @override
  PaymentDraft? read() => value;

  @override
  Future<void> save(PaymentDraft draft) async => value = draft;

  @override
  Future<void> clear() async => value = null;
}
