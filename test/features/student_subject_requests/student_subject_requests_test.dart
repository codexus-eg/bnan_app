import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
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

    test('Gulf checkout uses singular subjectId', () {
      final json = const GulfSubjectRequestPayload(
        subjectId: 's1',
        packageId: 'p1',
        paymentAddress: PaymentAddress(
          city: 'Riyadh',
          region: 'Riyadh',
          line1: 'Road',
        ),
      ).toJson();
      expect(json['subjectId'], 's1');
      expect(json.containsKey('subjectIds'), isFalse);
      expect(json['locale'], 'ar_SA');
      expect(json['isMobile'], isTrue);
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
                  'curriculum': {'id': 'c1', 'name': 'Curriculum'},
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
    test('filters single_subject hours packages only', () {
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
      ]);
      expect(result.map((item) => item.id), ['valid']);
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

    test('completed payment reloads subjects and requests', () async {
      final repo = FakeRepo();
      final cubit = StudentSubjectRequestsCubit(repo);
      await cubit.load();
      await cubit.paymentCompleted();
      expect(repo.availableCalls, 2);
      expect(repo.requestCalls, 2);
      await cubit.close();
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

    test(
      'SUBJECT_ALREADY_REQUESTED refreshes availability and requests',
      () async {
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
        expect(repo.requestCalls, 2);
        await cubit.close();
      },
    );
  });

  group('subject request payment cubit', () {
    test('network timeout retry preserves idempotency key', () async {
      final repo = FakeRepo()
        ..checkoutResults.add(
          Left(Failure(message: 'timeout', responseReceived: false)),
        )
        ..checkoutResults.add(Right(_payment()));
      final cubit = _paymentCubit(repo);
      await cubit.checkout(_gulfPayload());
      await cubit.checkout(_gulfPayload());
      expect(repo.checkoutKeys, ['key-1', 'key-1']);
      await cubit.close();
    });

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
      'completed payment clears feature draft after request id exists',
      () async {
        final store = MemoryPaymentStore();
        final repo = FakeRepo()
          ..checkoutResults.add(Right(_payment()))
          ..reconcileResults.add(
            Right(
              SubjectRequestPayment(
                paymentId: 'pay-1',
                status: SubjectRequestPaymentStatus.completed,
                subjectRequestId: 'request-1',
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

GulfSubjectRequestPayload _gulfPayload({String subjectId = 'enabled'}) =>
    GulfSubjectRequestPayload(
      subjectId: subjectId,
      packageId: 'valid',
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
  final checkoutKeys = <String>[];
  final checkoutResults = <Either<Failure, SubjectRequestPayment>>[];
  final statusResults = <Either<Failure, SubjectRequestPayment>>[];
  final reconcileResults = <Either<Failure, SubjectRequestPayment>>[];
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
  Future<Either<Failure, List<PackageModel>>> getPackages(String id) async =>
      Right(packages);

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
  Future<Either<Failure, SubjectRequestPayment>> reconcile(String id) async =>
      reconcileResults.isEmpty
      ? Right(_payment())
      : reconcileResults.removeAt(0);
}

SubjectRequestAvailability _availability({bool enabledSelectable = true}) =>
    SubjectRequestAvailability(
      curriculum: const SubjectRequestLookup(id: 'c1', name: 'Curriculum'),
      grade: const SubjectRequestLookup(id: 'g1', name: 'Grade'),
      subjects: [
        AvailableSubject(
          id: 'enabled',
          name: 'Math',
          isSelectable: enabledSelectable,
        ),
        const AvailableSubject(
          id: 'disabled',
          name: 'Science',
          isSelectable: false,
          requestStatus: 'pending',
        ),
      ],
    );
