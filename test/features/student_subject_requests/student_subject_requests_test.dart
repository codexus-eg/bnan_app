import 'dart:async';

import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment_draft.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo_impl.dart';
import 'package:bnan_app/features/student_subject_requests/data/store/subject_request_payment_store.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_state.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('request payload contract', () {
    test('assigned request parses teacher and navigation ids', () {
      final request = StudentSubjectRequest.fromJson({
        'id': 'request-1',
        'status': 'assigned',
        'teacher': {'_id': 'teacher-1', 'fullName': 'Ahmed'},
        'classroom': {'id': 'class-1', 'displayName': 'Math class'},
        'chatRoom': 'room-1',
      });

      expect(request.teacher?.name, 'Ahmed');
      expect(request.classroom?.name, 'Math class');
      expect(request.chatRoom?.id, 'room-1');
    });

    test('Egyptian submit uses subjectIds array and omits empty notes', () {
      final json = const EgyptianSubjectRequestPayload(
        subjectId: 's1',
        packageId: 'p1',
        notes: ' ',
      ).toJson();
      expect(json['subjectIds'], ['s1']);
      expect(json.containsKey('subjectId'), isFalse);
      expect(json.containsKey('notes'), isFalse);
    });

    test('checkout response safely parses numeric amount variants', () {
      final payment = SubjectRequestPayment.fromJson({
        'data': {
          'paymentId': 'pay-1',
          'status': 'pending',
          'originalAmount': 300,
          'discountAmount': '50.5',
          'finalAmount': 249.5,
          'currency': 'SAR',
        },
      });
      expect(payment.originalAmount, 300);
      expect(payment.discountAmount, 50.5);
      expect(payment.finalAmount, 249.5);
      expect(payment.currency, 'SAR');
    });

    test('Gulf checkout uses singular subjectId', () {
      final json = const GulfSubjectRequestPayload(
        subjectId: 's1',
        packageId: 'p1',
        curriculumId: 'c1',
        paymentAddress: PaymentAddress(
          city: 'Riyadh',
          region: 'Riyadh',
          line1: 'Road',
        ),
      ).toJson();
      expect(json['subjectId'], 's1');
      expect(json['provider'], 'tamara');
      expect(json, contains('paymentAddress'));
      expect(json['curriculumId'], 'c1');
      expect(json.containsKey('subjectIds'), isFalse);
      expect(json['locale'], 'ar_SA');
      expect(json['isMobile'], isTrue);
    });

    test('Paymob Gulf subject checkout omits paymentAddress', () {
      final json = const GulfSubjectRequestPayload(
        subjectId: 's1',
        packageId: 'p1',
        curriculumId: 'c1',
        paymentAddress: PaymentAddress(
          city: 'Riyadh',
          region: 'Riyadh',
          line1: 'Road',
        ),
        provider: GulfPaymentProvider.paymob,
      ).toJson();
      expect(json['provider'], 'paymob');
      expect(json, isNot(contains('paymentAddress')));
    });

    test('legacy subject draft without provider defaults to Tamara', () {
      final draft = SubjectRequestPaymentDraft.fromJson({
        'paymentId': 'payment-1',
        'idempotencyKey': 'key-1',
        'subjectId': 'subject-1',
        'packageId': 'package-1',
        'payloadFingerprint': 'fingerprint-1',
        'ownerUserId': 'student-1',
      });
      expect(draft.provider, GulfPaymentProvider.tamara);
    });
  });

  test(
    'repository uses documented protected endpoints and checkout header',
    () async {
      final dio = Dio();
      final consumer = DioConsumer(dio: dio);
      dio.interceptors.clear();
      final captured = <RequestOptions>[];
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured.add(options);
            final data = switch (options.path) {
              EndPoints.studentSubjectRequestAvailableSubjects => {
                'data': {
                  'curriculum': {
                    'id': 'c1',
                    'name': 'Curriculum',
                    'registrationMode': 'egyptian',
                  },
                  'grade': {'id': 'g1', 'name': 'Grade'},
                  'subjects': <dynamic>[],
                },
              },
              EndPoints.studentSubjectRequestCheckout => {
                'data': {
                  'paymentId': 'pay-1',
                  'checkoutUrl': 'https://checkout.example/pay-1',
                  'status': 'pending',
                },
              },
              _ => {'data': <dynamic>[]},
            };
            handler.resolve(Response(requestOptions: options, data: data));
          },
        ),
      );
      final repo = StudentSubjectRequestsRepoImpl(consumer);
      await repo.getAvailableSubjects();
      await repo.getPackages('c1');
      await repo.getRequests();
      await repo.checkout(payload: _gulfPayload(), idempotencyKey: 'attempt-1');
      await repo.status('pay-1');
      await repo.reconcile('pay-1');

      expect(captured.map((item) => item.path), [
        EndPoints.studentSubjectRequestAvailableSubjects,
        EndPoints.packagesByCurriculum('c1'),
        EndPoints.studentSubjectRequests,
        EndPoints.studentSubjectRequestCheckout,
        EndPoints.studentSubjectRequestCheckoutStatus('pay-1'),
        EndPoints.studentSubjectRequestCheckoutReconcile('pay-1'),
      ]);
      expect(
        captured.every((item) => item.extra['isProtected'] == true),
        isTrue,
      );
      final checkoutRequest = captured.singleWhere(
        (item) => item.path == EndPoints.studentSubjectRequestCheckout,
      );
      expect(checkoutRequest.headers['Idempotency-Key'], 'attempt-1');
      expect(
        captured.any((item) => item.uri.toString().contains('teacherId')),
        isFalse,
      );
    },
  );

  group('student subject requests cubit', () {
    test('filters Egyptian single-subject hours packages only', () {
      final result = StudentSubjectRequestsCubit.filterPackages(const [
        PackageModel(
          id: 'valid',
          type: 'hours',
          accessScope: PackageAccessScope.singleSubject,
          isActive: true,
        ),
        PackageModel(id: 'all', type: 'hours', isActive: true),
        PackageModel(
          id: 'month',
          type: 'months',
          accessScope: PackageAccessScope.singleSubject,
          isActive: true,
        ),
        PackageModel(
          id: 'inactive',
          type: 'hours',
          accessScope: PackageAccessScope.singleSubject,
        ),
      ], RegistrationMode.egyptian);
      expect(result.map((item) => item.id), ['valid']);
    });

    test('filters Gulf single-subject hours packages only', () {
      final result = StudentSubjectRequestsCubit.filterPackages(const [
        PackageModel(
          id: 'single',
          type: 'hours',
          accessScope: PackageAccessScope.singleSubject,
          isActive: true,
        ),
        PackageModel(id: 'all', type: 'hours', isActive: true),
        PackageModel(id: 'inactive', type: 'hours'),
      ], RegistrationMode.gulf);

      expect(result.map((item) => item.id), ['single']);
    });

    test('Gulf load uses the student curriculum id once', () async {
      final repo = FakeRepo()
        ..availability = _availability(registrationMode: RegistrationMode.gulf);
      final cubit = StudentSubjectRequestsCubit(repo);

      await cubit.load(gulfCurriculumId: 'student-curriculum');

      expect(repo.packageCurriculumIds, ['student-curriculum']);
      expect(cubit.state.packages.map((item) => item.id), ['valid']);
      await cubit.close();
    });

    test('Gulf rejects a selected package from another curriculum', () async {
      final repo = FakeRepo()
        ..availability = _availability(registrationMode: RegistrationMode.gulf)
        ..packages = const [
          PackageModel(
            id: 'wrong',
            type: 'hours',
            curriculum: 'other-curriculum',
            accessScope: PackageAccessScope.singleSubject,
            isActive: true,
          ),
        ];
      final cubit = StudentSubjectRequestsCubit(repo);

      await cubit.load(gulfCurriculumId: 'student-curriculum');
      cubit.selectPackage('wrong');

      expect(cubit.hasValidSelectedGulfPackage, isFalse);
      await cubit.close();
    });

    test('availability parses curriculum registration mode', () {
      final availability = SubjectRequestAvailability.fromJson({
        'data': {
          'curriculum': {
            'id': 'c1',
            'name': 'Curriculum',
            'registrationMode': 'gulf',
          },
          'grade': {'id': 'g1', 'name': 'Grade'},
          'subjects': <dynamic>[],
        },
      });

      expect(availability.registrationMode, RegistrationMode.gulf);
    });

    test(
      'disabled subject cannot be selected and notes stop at 2000',
      () async {
        final cubit = StudentSubjectRequestsCubit(FakeRepo());
        await cubit.load();
        cubit.selectSubject('disabled');
        expect(cubit.state.selectedSubjectId, isNull);
        final accepted = List.filled(2000, 'a').join();
        cubit.updateNotes(accepted);
        cubit.updateNotes(List.filled(2001, 'b').join());
        expect(cubit.state.notes, accepted);
        await cubit.close();
      },
    );

    test('completed payment reloads creation availability only', () async {
      final repo = FakeRepo();
      final cubit = StudentSubjectRequestsCubit(repo);
      await cubit.load();
      await cubit.paymentCompleted();
      expect(repo.availableCalls, 2);
      expect(repo.requestCalls, 0);
      await cubit.close();
    });

    test('changing subject clears the selected package', () async {
      final cubit = StudentSubjectRequestsCubit(FakeRepo());
      await cubit.load();
      cubit.selectSubject('enabled');
      cubit.selectPackage('valid');
      cubit.selectSubject('other');

      expect(cubit.state.selectedSubjectId, 'other');
      expect(cubit.state.selectedPackageId, isNull);
      await cubit.close();
    });

    test('delayed availability response after close is ignored', () async {
      final repo = PendingAvailabilityRepo();
      final cubit = StudentSubjectRequestsCubit(repo);
      final request = cubit.load();

      await cubit.close();
      repo.complete(_availability());

      await expectLater(request, completes);
    });

    test('refresh keeps valid selections and clears stale ones', () async {
      final repo = FakeRepo();
      final cubit = StudentSubjectRequestsCubit(repo);
      await cubit.load();
      cubit.selectSubject('enabled');
      cubit.selectPackage('valid');
      await cubit.load(refresh: true);
      expect(cubit.state.selectedSubjectId, 'enabled');
      expect(cubit.state.selectedPackageId, 'valid');

      repo.availability = _availability(enabledSelectable: false);
      repo.packages = const [];
      await cubit.load(refresh: true);
      expect(cubit.state.selectedSubjectId, isNull);
      expect(cubit.state.selectedPackageId, isNull);
      await cubit.close();
    });

    test('SUBJECT_ALREADY_REQUESTED refreshes creation availability', () async {
      final repo = FakeRepo()
        ..submitResult = Left(
          Failure(
            message: 'duplicate',
            statusCode: 409,
            code: 'SUBJECT_ALREADY_REQUESTED',
            responseReceived: true,
          ),
        );
      final cubit = StudentSubjectRequestsCubit(repo);
      await cubit.load();
      cubit.selectSubject('enabled');
      cubit.selectPackage('valid');
      await cubit.submitEgyptian();
      expect(repo.availableCalls, 2);
      expect(repo.requestCalls, 0);
      expect(cubit.state.message, 'duplicate');
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('Egyptian success resets submitting state', () async {
      final cubit = StudentSubjectRequestsCubit(FakeRepo());
      await cubit.load();
      cubit.selectSubject('enabled');
      cubit.selectPackage('valid');

      await cubit.submitEgyptian();

      expect(cubit.state.message, 'subject_request_submitted');
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });
  });

  group('subject request payment cubit', () {
    test('network timeout retry preserves idempotency key', () async {
      final store = MemoryPaymentStore();
      final repo = FakeRepo()
        ..checkoutResults.add(
          Left(Failure(message: 'timeout', responseReceived: false)),
        )
        ..checkoutResults.add(Right(_payment()));
      final cubit = _paymentCubit(repo, store: store);
      await cubit.checkout(_gulfPayload());
      expect(store.draft?.paymentId, isEmpty);
      expect(store.draft?.idempotencyKey, 'key-1');
      await cubit.checkout(_gulfPayload());
      expect(repo.checkoutKeys, ['key-1', 'key-1']);
      await cubit.close();
    });

    test('changed checkout payload gets a new key after timeout', () async {
      final repo = FakeRepo()
        ..checkoutResults.add(
          Left(Failure(message: 'timeout', responseReceived: false)),
        )
        ..checkoutResults.add(Right(_payment()));
      final cubit = _paymentCubit(repo);
      await cubit.checkout(_gulfPayload());
      await cubit.checkout(_gulfPayload(notes: 'changed'));
      expect(repo.checkoutKeys, ['key-1', 'key-2']);
      await cubit.close();
    });

    test(
      'failed launcher reopens saved checkout without another API',
      () async {
        final repo = FakeRepo()..checkoutResults.add(Right(_payment()));
        final cubit = _paymentCubit(repo);
        await cubit.checkout(_gulfPayload());
        cubit.checkoutLaunchFailed('cannot open');
        await cubit.checkout(_gulfPayload());
        expect(repo.checkoutKeys, ['key-1']);
        expect(cubit.state.phase, SubjectRequestPaymentPhase.openingTamara);
        await cubit.close();
      },
    );

    test('terminal failure allows new attempt with new key', () async {
      final repo = FakeRepo()
        ..checkoutResults.addAll([Right(_payment()), Right(_payment('pay-2'))])
        ..reconcileResults.add(
          Right(_payment('pay-1', SubjectRequestPaymentStatus.failed)),
        );
      final cubit = _paymentCubit(repo);
      await cubit.checkout(_gulfPayload());
      await cubit.tamaraReturned();
      await cubit.checkout(_gulfPayload());
      expect(repo.checkoutKeys, ['key-1', 'key-2']);
      await cubit.close();
    });

    test('different form starts a new key after uncertain failure', () async {
      final repo = FakeRepo()
        ..checkoutResults.add(
          Left(Failure(message: 'timeout', responseReceived: false)),
        )
        ..checkoutResults.add(Right(_payment()));
      final cubit = _paymentCubit(repo);
      await cubit.checkout(_gulfPayload());
      await cubit.checkout(_gulfPayload(subjectId: 'other'));
      expect(repo.checkoutKeys, ['key-1', 'key-2']);
      await cubit.close();
    });

    test('polling stops on terminal status', () async {
      final repo = FakeRepo()
        ..checkoutResults.add(Right(_payment()))
        ..reconcileResults.add(Right(_payment()))
        ..statusResults.add(
          Right(_payment('pay-1', SubjectRequestPaymentStatus.cancelled)),
        );
      final cubit = _paymentCubit(repo, maxPollAttempts: 5);
      await cubit.checkout(_gulfPayload());
      await cubit.tamaraReturned();
      expect(repo.statusCalls, 1);
      expect(cubit.state.phase, SubjectRequestPaymentPhase.terminalFailure);
      await cubit.close();
    });

    test('Paymob verification skips reconcile', () async {
      final repo = FakeRepo()
        ..checkoutResults.add(Right(_payment()))
        ..statusResults.add(
          Right(_payment('pay-1', SubjectRequestPaymentStatus.completed)),
        );
      final cubit = _paymentCubit(repo);
      await cubit.checkout(_gulfPayload(provider: GulfPaymentProvider.paymob));
      await cubit.tamaraReturned();
      expect(repo.reconcileCalls, 0);
      expect(repo.statusCalls, 1);
      await cubit.close();
    });

    test('subject purchase defaults to Tamara and can select Paymob', () async {
      final repo = FakeRepo()..checkoutResults.add(Right(_payment()));
      final cubit = _paymentCubit(repo);
      expect(cubit.state.selectedProvider, GulfPaymentProvider.tamara);
      cubit.selectPaymentProvider(GulfPaymentProvider.paymob);
      await cubit.checkout(
        _gulfPayload(provider: cubit.state.selectedProvider),
      );
      expect(cubit.state.selectedProvider, GulfPaymentProvider.paymob);
      expect(repo.lastPayload?.provider, GulfPaymentProvider.paymob);
      expect(repo.lastPayload?.toJson(), isNot(contains('paymentAddress')));
      cubit.checkoutLaunchDeferred();
      expect(cubit.state.phase, SubjectRequestPaymentPhase.failure);
      await cubit.close();
    });

    test('subject purchase restore keeps Paymob provider', () async {
      final store = MemoryPaymentStore()
        ..draft = const SubjectRequestPaymentDraft(
          paymentId: '',
          idempotencyKey: 'key-1',
          subjectId: 'subject-1',
          packageId: 'package-1',
          payloadFingerprint: 'fingerprint-1',
          ownerUserId: '',
          provider: GulfPaymentProvider.paymob,
        );
      final cubit = _paymentCubit(FakeRepo(), store: store);
      await cubit.restore();
      expect(cubit.state.selectedProvider, GulfPaymentProvider.paymob);
      await cubit.close();
    });

    test('polling timeout exposes manual verification', () async {
      final repo = FakeRepo()
        ..checkoutResults.add(Right(_payment()))
        ..reconcileResults.add(Right(_payment()))
        ..statusResults.addAll([Right(_payment()), Right(_payment())]);
      final cubit = _paymentCubit(repo, maxPollAttempts: 2);
      await cubit.checkout(_gulfPayload());
      await cubit.tamaraReturned();
      expect(cubit.state.phase, SubjectRequestPaymentPhase.verificationTimeout);
      expect(repo.statusCalls, 2);
      await cubit.close();
    });

    test(
      'completed payment clears feature draft without subscription',
      () async {
        final store = MemoryPaymentStore();
        final repo = FakeRepo()
          ..checkoutResults.add(Right(_payment()))
          ..reconcileResults.add(
            const Right(
              SubjectRequestPayment(
                paymentId: 'pay-1',
                status: SubjectRequestPaymentStatus.completed,
              ),
            ),
          );
        final cubit = _paymentCubit(repo, store: store);
        await cubit.checkout(_gulfPayload());
        await cubit.tamaraReturned();
        expect(store.clearCalls, 1);
        expect(cubit.state.phase, SubjectRequestPaymentPhase.completed);
        await cubit.close();
      },
    );

    test('Tamara cancel checks once and keeps checkout retryable', () async {
      final repo = FakeRepo()..checkoutResults.add(Right(_payment()));
      final cubit = _paymentCubit(repo);
      await cubit.checkout(_gulfPayload());

      await cubit.checkoutClosed();

      expect(cubit.state.phase, SubjectRequestPaymentPhase.failure);
      expect(repo.reconcileCalls, 1);
      expect(repo.statusCalls, 1);
      await cubit.checkout(_gulfPayload());
      expect(repo.checkoutKeys, ['key-1']);
      expect(cubit.state.phase, SubjectRequestPaymentPhase.openingTamara);
      await cubit.close();
    });
  });
}

SubjectRequestPaymentCubit _paymentCubit(
  FakeRepo repo, {
  int maxPollAttempts = 1,
  MemoryPaymentStore? store,
}) => SubjectRequestPaymentCubit(
  repo: repo,
  keyGenerator: SequenceKeyGenerator(),
  store: store ?? MemoryPaymentStore(),
  pollInterval: Duration.zero,
  maxPollAttempts: maxPollAttempts,
);

GulfSubjectRequestPayload _gulfPayload({
  String subjectId = 'enabled',
  String? notes,
  GulfPaymentProvider provider = GulfPaymentProvider.tamara,
}) => GulfSubjectRequestPayload(
  subjectId: subjectId,
  packageId: 'valid',
  curriculumId: 'c1',
  notes: notes,
  provider: provider,
  paymentAddress: const PaymentAddress(
    city: 'Riyadh',
    region: 'Riyadh',
    line1: 'Road',
  ),
);

SubjectRequestPayment _payment([
  String id = 'pay-1',
  SubjectRequestPaymentStatus status = SubjectRequestPaymentStatus.pending,
]) => SubjectRequestPayment(
  paymentId: id,
  status: status,
  checkoutUrl: 'https://checkout.example/$id',
);

class SequenceKeyGenerator extends IdempotencyKeyGenerator {
  int _value = 0;
  @override
  String create() => 'key-${++_value}';
}

class MemoryPaymentStore extends SubjectRequestPaymentStore {
  SubjectRequestPaymentDraft? draft;
  int clearCalls = 0;
  @override
  SubjectRequestPaymentDraft? read() => draft;
  @override
  Future<void> save(SubjectRequestPaymentDraft value) async => draft = value;
  @override
  Future<void> clear() async {
    clearCalls++;
    draft = null;
  }
}

class FakeRepo implements StudentSubjectRequestsRepo {
  int availableCalls = 0, requestCalls = 0, statusCalls = 0;
  int reconcileCalls = 0;
  final checkoutKeys = <String>[];
  final checkoutResults = <Either<Failure, SubjectRequestPayment>>[];
  final statusResults = <Either<Failure, SubjectRequestPayment>>[];
  final reconcileResults = <Either<Failure, SubjectRequestPayment>>[];
  final packageCurriculumIds = <String>[];
  GulfSubjectRequestPayload? lastPayload;
  Either<Failure, StudentSubjectRequest> submitResult = const Right(
    StudentSubjectRequest(id: 'r1', status: 'pending'),
  );
  SubjectRequestAvailability availability = _availability();
  List<PackageModel> packages = const [
    PackageModel(
      id: 'valid',
      name: 'Hours',
      type: 'hours',
      accessScope: PackageAccessScope.singleSubject,
      isActive: true,
    ),
  ];

  @override
  Future<Either<Failure, SubjectRequestAvailability>>
  getAvailableSubjects() async {
    availableCalls++;
    return Right(availability);
  }

  @override
  Future<Either<Failure, List<PackageModel>>> getPackages(String id) async {
    packageCurriculumIds.add(id);
    return Right(packages);
  }

  @override
  Future<Either<Failure, List<StudentSubjectRequest>>> getRequests() async {
    requestCalls++;
    return const Right([]);
  }

  @override
  Future<Either<Failure, StudentSubjectRequest>> submitEgyptian(
    EgyptianSubjectRequestPayload payload,
  ) async => submitResult;

  @override
  Future<Either<Failure, SubjectRequestPayment>> checkout({
    required GulfSubjectRequestPayload payload,
    required String idempotencyKey,
  }) async {
    lastPayload = payload;
    checkoutKeys.add(idempotencyKey);
    return checkoutResults.removeAt(0);
  }

  @override
  Future<Either<Failure, SubjectRequestPayment>> status(String id) async {
    statusCalls++;
    return statusResults.isEmpty
        ? Right(_payment())
        : statusResults.removeAt(0);
  }

  @override
  Future<Either<Failure, SubjectRequestPayment>> reconcile(String id) async {
    reconcileCalls++;
    return reconcileResults.isEmpty
        ? Right(_payment())
        : reconcileResults.removeAt(0);
  }
}

class PendingAvailabilityRepo implements StudentSubjectRequestsRepo {
  final _availability =
      Completer<Either<Failure, SubjectRequestAvailability>>();

  @override
  Future<Either<Failure, SubjectRequestAvailability>> getAvailableSubjects() =>
      _availability.future;

  void complete(SubjectRequestAvailability value) =>
      _availability.complete(Right(value));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SubjectRequestAvailability _availability({
  bool enabledSelectable = true,
  RegistrationMode registrationMode = RegistrationMode.egyptian,
}) => SubjectRequestAvailability(
  curriculum: const SubjectRequestLookup(id: 'c1', name: 'Curriculum'),
  grade: const SubjectRequestLookup(id: 'g1', name: 'Grade'),
  registrationMode: registrationMode,
  subjects: [
    AvailableSubject(
      id: 'enabled',
      name: 'Math',
      isSelectable: enabledSelectable,
    ),
    const AvailableSubject(id: 'other', name: 'Arabic', isSelectable: true),
    const AvailableSubject(
      id: 'disabled',
      name: 'Science',
      isSelectable: false,
      requestStatus: 'pending',
    ),
  ],
);
