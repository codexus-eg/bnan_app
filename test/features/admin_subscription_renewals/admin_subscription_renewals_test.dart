import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewal_model.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewals_page.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/repo/admin_subscription_renewals_repo.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/repo/admin_subscription_renewals_repo_impl.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/manager/admin_subscription_renewals_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parsing', () {
    test('parses every status and nullable fields safely', () {
      for (final status in AdminRenewalStatus.values) {
        final item = AdminSubscriptionRenewalModel.fromJson(
          _item(status.apiValue),
        );
        expect(item.status, status);
        expect(item.studentName, 'Student');
        expect(item.requestedBy, 'Parent');
      }
      final monthly = AdminSubscriptionRenewalModel.fromJson(
        _item('pending')..addAll({'subject': null, 'receiptImage': null}),
      );
      expect(monthly.subject, isNull);
      expect(monthly.receiptImage, isNull);
      final single = AdminSubscriptionRenewalModel.fromJson(
        _item('pending')..['subject'] = {'id': 's1', 'name': 'Arabic'},
      );
      expect(single.subject, 'Arabic');
    });

    test('parses snake-case pagination', () {
      final page = AdminSubscriptionRenewalsPage.fromJson({
        'data': [_item('pending')],
        'pagination': {
          'current_page': 1,
          'last_page': 3,
          'per_page': 20,
          'total': 45,
        },
      });
      expect(page.items, hasLength(1));
      expect(
        (page.currentPage, page.lastPage, page.perPage, page.total),
        (1, 3, 20, 45),
      );
    });
  });

  group('repository contract', () {
    test('fetch sends status, page, and limit', () async {
      final api = _RecordingApi();
      await AdminSubscriptionRenewalsRepoImpl(
        api,
      ).getRenewals(status: AdminRenewalStatus.confirmed, page: 2);
      expect(api.path, EndPoints.adminEgyptianSubscriptionRenewals);
      expect(api.query, {'status': 'confirmed', 'page': 2, 'limit': 20});
      expect(api.protected, isTrue);
    });

    test('confirm and approve use PATCH without body', () async {
      final api = _RecordingApi();
      final repo = AdminSubscriptionRenewalsRepoImpl(api);
      await repo.confirm('p1');
      await repo.approve('p2');
      expect(api.patches[0], (
        path: EndPoints.confirmEgyptianSubscriptionRenewal('p1'),
        data: null,
      ));
      expect(api.patches[1], (
        path: EndPoints.approveEgyptianSubscriptionRenewal('p2'),
        data: null,
      ));
    });

    test('reject omits empty reason and sends a non-empty reason', () async {
      final api = _RecordingApi();
      final repo = AdminSubscriptionRenewalsRepoImpl(api);
      await repo.reject('p1');
      await repo.reject('p2', rejectionReason: '  invalid receipt  ');
      expect(api.patches[0].data, isNull);
      expect(api.patches[1].data, {'rejectionReason': 'invalid receipt'});
    });
  });

  group('cubit', () {
    test('appends pages once and stops at last_page', () async {
      final repo = _FakeRepo()
        ..pages.addAll([
          Right(_page(1, 2, ['p1'])),
          Right(_page(2, 2, ['p1', 'p2'])),
        ]);
      final cubit = AdminSubscriptionRenewalsCubit(repo);
      await cubit.load();
      await cubit.loadMore();
      await cubit.loadMore();
      expect(cubit.state.items.map((item) => item.id), ['p1', 'p2']);
      expect(repo.fetches.map((call) => call.page), [1, 2]);
      await cubit.close();
    });

    test('tab switch starts its status from page one', () async {
      final repo = _FakeRepo();
      final cubit = AdminSubscriptionRenewalsCubit(repo);
      await cubit.load();
      await cubit.selectStatus(AdminRenewalStatus.completed);
      expect(repo.fetches, [
        (status: AdminRenewalStatus.pending, page: 1),
        (status: AdminRenewalStatus.completed, page: 1),
      ]);
      expect(cubit.state.status, AdminRenewalStatus.completed);
      await cubit.close();
    });

    test(
      'processing id prevents duplicate action and refreshes after success',
      () async {
        final gate = Completer<Either<Failure, void>>();
        final repo = _FakeRepo()..confirmGate = gate;
        final cubit = AdminSubscriptionRenewalsCubit(repo);
        await cubit.load();
        final first = cubit.confirm('p1');
        final duplicate = cubit.confirm('p1');
        expect(cubit.state.processingPaymentId, 'p1');
        expect(repo.confirmCalls, 1);
        gate.complete(const Right(null));
        await Future.wait([first, duplicate]);
        expect(repo.fetches, hasLength(2));
        expect(cubit.state.processingPaymentId, isNull);
        await cubit.close();
      },
    );

    test('approve and reject each refetch the selected status', () async {
      final repo = _FakeRepo();
      final cubit = AdminSubscriptionRenewalsCubit(repo);
      await cubit.selectStatus(AdminRenewalStatus.confirmed);
      await cubit.approve('p1');
      await cubit.reject('p2', reason: 'reason');
      expect(repo.approveCalls, 1);
      expect(repo.rejectReasons, ['reason']);
      expect(repo.fetches, hasLength(3));
      expect(
        repo.fetches.every(
          (call) =>
              call.status == AdminRenewalStatus.confirmed && call.page == 1,
        ),
        isTrue,
      );
      await cubit.close();
    });
  });
}

Map<String, dynamic> _item(String status, {String id = 'p1'}) => {
  'id': id,
  'student': {
    'user': {'fullName': 'Student', 'email': 'student@example.com'},
    'curriculum': {'name': 'Egyptian'},
    'grade': {'name': 'First'},
  },
  'package': {'name': 'Monthly', 'type': 'monthly', 'currency': 'EGP'},
  'requestedBy': {'fullName': 'Parent'},
  'amount': 300,
  'status': status,
};

AdminSubscriptionRenewalsPage _page(int current, int last, List<String> ids) =>
    AdminSubscriptionRenewalsPage(
      items: ids
          .map(
            (id) => AdminSubscriptionRenewalModel.fromJson(
              _item('pending', id: id),
            ),
          )
          .toList(),
      currentPage: current,
      lastPage: last,
      perPage: 20,
      total: ids.length,
    );

class _FakeRepo implements AdminSubscriptionRenewalsRepo {
  final pages = <Either<Failure, AdminSubscriptionRenewalsPage>>[];
  final fetches = <({AdminRenewalStatus status, int page})>[];
  Completer<Either<Failure, void>>? confirmGate;
  int confirmCalls = 0, approveCalls = 0;
  final rejectReasons = <String?>[];

  @override
  Future<Either<Failure, AdminSubscriptionRenewalsPage>> getRenewals({
    required AdminRenewalStatus status,
    int page = 1,
    int limit = 20,
  }) async {
    fetches.add((status: status, page: page));
    return pages.isEmpty ? Right(_page(1, 1, [])) : pages.removeAt(0);
  }

  @override
  Future<Either<Failure, void>> confirm(String paymentId) {
    confirmCalls++;
    return confirmGate?.future ?? Future.value(const Right(null));
  }

  @override
  Future<Either<Failure, void>> approve(String paymentId) async {
    approveCalls++;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> reject(
    String paymentId, {
    String? rejectionReason,
  }) async {
    rejectReasons.add(rejectionReason);
    return const Right(null);
  }
}

class _RecordingApi implements ApiConsumer {
  String? path;
  Map<String, dynamic>? query;
  bool protected = false;
  final patches = <({String path, Object? data})>[];

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    query = queryParameter;
    protected = isProtected;
    return {'data': [], 'pagination': {}};
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    patches.add((path: path, data: data));
    protected = isProtected;
    return const {};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
