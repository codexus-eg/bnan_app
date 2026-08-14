import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_requests_page.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo_impl.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_state.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_state.dart';
import 'package:bnan_app/features/registration_requests/data/models/confirm_registration_payment_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/get_registration_requests_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_action_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_requests_pagination_model.dart';
import 'package:bnan_app/features/registration_requests/data/repo/registration_requests_repo.dart';
import 'package:bnan_app/features/registration_requests/data/repo/registration_requests_repo_impl.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses nested student user name and subject object name', () {
    final request = AdminSubjectRequestModel.fromJson({
      'id': 'request-1',
      'student': {
        'user': {'fullName': 'Salmon'},
      },
      'subject': {'_id': 'subject-1', 'name': 'Arabic'},
    });

    expect(request.studentName, 'Salmon');
    expect(request.subject, 'Arabic');
  });

  test('does not expose a subject id as its display name', () {
    final request = AdminSubjectRequestModel.fromJson({
      'id': 'request-1',
      'subject': '64b123456789012345678901',
    });

    expect(request.subject, isNull);
  });

  test(
    'fetch uses protected page/limit query without status and parses pagination',
    () async {
      final api = RecordingApi()
        ..getResponse = {
          'data': [
            {
              'id': 'request-1',
              'status': 'awaiting_admin_approval',
              'student': {'fullName': 'Student'},
              'subject': {'name': 'Math'},
            },
          ],
          'total': '21',
          'page': 2,
          'limit': '20',
        };
      final result = await AdminSubjectRequestsRepoImpl(
        api,
      ).getRequests(page: 2, limit: 20);
      final page = result.getOrElse(() => throw StateError('failed'));
      expect(api.path, EndPoints.adminSubjectRequests);
      expect(api.query, {'page': 2, 'limit': 20});
      expect(api.isProtected, isTrue);
      expect(page.requests.single.id, 'request-1');
      expect(page.hasMore, isFalse);
    },
  );

  test('lesson registration fetch sends page without status', () async {
    final api = RecordingApi()
      ..getResponse = {
        'success': true,
        'results': 0,
        'pagination': {
          'currentPage': 2,
          'perPage': 20,
          'total': 0,
          'lastPage': 1,
        },
        'data': <Object>[],
      };

    await RegistrationRequestsRepoImpl(
      api,
    ).getEgyptianRegistrationRequests(page: 2);

    expect(api.path, EndPoints.egyptianRegistrationRequests);
    expect(api.query, {'page': 2});
    expect(api.query, isNot(contains('status')));
  });

  test('approve uses protected multipart and receiptImage is a file', () async {
    final directory = await Directory.systemTemp.createTemp('subject-request-');
    final receipt = File('${directory.path}/receipt.png');
    await receipt.writeAsBytes([1, 2, 3]);
    final api = RecordingApi();
    await AdminSubjectRequestsRepoImpl(api).approve(
      requestId: 'request-1',
      approval: AdminSubjectRequestApproval(
        receiptImagePath: receipt.path,
        amount: 120,
        method: 'instapay',
        referenceNumber: 'REF-1',
        paymentNotes: 'Paid',
      ),
    );
    final form = api.data as FormData;
    expect(api.path, EndPoints.approveAdminSubjectRequest('request-1'));
    expect(api.isProtected, isTrue);
    expect(api.isFormData, isTrue);
    expect(form.files.single.key, 'receiptImage');
    expect(form.files.single.value, isA<MultipartFile>());
    expect(Map.fromEntries(form.fields), containsPair('method', 'instapay'));
    await receipt.delete();
    await directory.delete();
  });

  test('reject uses documented protected endpoint', () async {
    final api = RecordingApi();
    await AdminSubjectRequestsRepoImpl(api).reject('request-2');
    expect(api.path, EndPoints.rejectAdminSubjectRequest('request-2'));
    expect(api.isProtected, isTrue);
    expect(api.isFormData, isFalse);
  });

  test('cubit loads all statuses and sends the next pagination page', () async {
    final repo = FakeAdminRepo()
      ..pages.addAll([
        const Right(
          AdminSubjectRequestsPage(requests: [], total: 21, page: 1, limit: 20),
        ),
        const Right(
          AdminSubjectRequestsPage(requests: [], total: 21, page: 2, limit: 20),
        ),
      ]);
    final cubit = AdminSubjectRequestsCubit(repo);
    await cubit.load();
    await cubit.loadMore();
    expect(repo.fetches, [(1, 20), (2, 20)]);
    await cubit.close();
  });

  test('subject requests ignore duplicate initial load', () async {
    final pending = Completer<Either<Failure, AdminSubjectRequestsPage>>();
    final repo = FakeAdminRepo()..pendingPages[1] = pending;
    final cubit = AdminSubjectRequestsCubit(repo);

    final first = cubit.load();
    final second = cubit.load();
    expect(repo.fetches, [(1, 20)]);
    pending.complete(const Right(_emptyPage));
    await Future.wait([first, second]);

    await cubit.close();
  });

  test('stale load-more cannot replace a newer subject refresh', () async {
    final oldMore = Completer<Either<Failure, AdminSubjectRequestsPage>>();
    final repo = FakeAdminRepo()
      ..pages.add(const Right(_firstPage))
      ..pendingPages[2] = oldMore;
    final cubit = AdminSubjectRequestsCubit(repo);
    await cubit.load();

    final loadMore = cubit.loadMore();
    repo.pages.add(const Right(_newPage));
    await cubit.load(refresh: true);
    oldMore.complete(const Right(_oldSecondPage));
    await loadMore;

    final state = cubit.state as AdminSubjectRequestsSuccess;
    expect(state.requests.map((request) => request.id), ['new']);
    await cubit.close();
  });

  test('approve and reject refresh list after success', () async {
    final repo = FakeAdminRepo();
    final actions = AdminSubjectRequestActionsCubit(repo);
    var refreshes = 0;
    actions.onRefresh = () async => refreshes++;
    await actions.approve(
      'r1',
      const AdminSubjectRequestApproval(receiptImagePath: 'unused-in-fake.png'),
    );
    await actions.reject('r2');
    expect(refreshes, 2);
    await actions.close();
  });

  test('409 not-awaiting error emits failure and refreshes', () async {
    final repo = FakeAdminRepo()
      ..rejectResult = Left(
        Failure(
          message: 'stale',
          statusCode: 409,
          code: 'SUBJECT_REQUEST_NOT_AWAITING_APPROVAL',
        ),
      );
    final actions = AdminSubjectRequestActionsCubit(repo);
    var refreshes = 0;
    actions.onRefresh = () async => refreshes++;
    await actions.reject('r1');
    expect(actions.state, isA<AdminSubjectRequestActionFailure>());
    expect(refreshes, 1);
    await actions.close();
  });

  test(
    'subject section loading does not alter registration cubit state',
    () async {
      final registrationRepo = FakeRegistrationRepo();
      final registration = GetRegistrationRequestsCubit(registrationRepo);
      await registration.getRegistrationRequests(refresh: true);
      final registrationState = registration.state;
      final admin = AdminSubjectRequestsCubit(FakeAdminRepo());
      await admin.load();
      expect(identical(registration.state, registrationState), isTrue);
      expect(registrationRepo.fetchCalls, 1);
      await admin.close();
      await registration.close();
    },
  );
}

class RecordingApi implements ApiConsumer {
  dynamic getResponse = const <String, dynamic>{};
  String? path;
  Object? data;
  Map<String, dynamic>? query;
  bool isProtected = false;
  bool isFormData = false;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    _record(path, data, queryParameter, isProtected, false);
    return getResponse;
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    _record(path, data, queryParameter, isProtected, isFormData);
    return {'success': true, 'message': 'ok'};
  }

  void _record(
    String value,
    Object? body,
    Map<String, dynamic>? params,
    bool protected,
    bool formData,
  ) {
    path = value;
    data = body;
    query = params;
    isProtected = protected;
    isFormData = formData;
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) => throw UnimplementedError();
  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) => throw UnimplementedError();
  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) => throw UnimplementedError();
}

class FakeAdminRepo implements AdminSubjectRequestsRepo {
  final pages = <Either<Failure, AdminSubjectRequestsPage>>[];
  final pendingPages =
      <int, Completer<Either<Failure, AdminSubjectRequestsPage>>>{};
  final fetches = <(int, int)>[];
  Either<Failure, String> approveResult = const Right('approved');
  Either<Failure, String> rejectResult = const Right('rejected');
  @override
  Future<Either<Failure, AdminSubjectRequestsPage>> getRequests({
    int page = 1,
    int limit = 20,
  }) async {
    fetches.add((page, limit));
    final pending = pendingPages[page];
    if (pending != null) return pending.future;
    return pages.isEmpty
        ? const Right(
            AdminSubjectRequestsPage(
              requests: [],
              total: 0,
              page: 1,
              limit: 20,
            ),
          )
        : pages.removeAt(0);
  }

  @override
  Future<Either<Failure, String>> approve({
    required String requestId,
    required AdminSubjectRequestApproval approval,
  }) async => approveResult;
  @override
  Future<Either<Failure, String>> reject(String requestId) async =>
      rejectResult;
}

const _emptyPage = AdminSubjectRequestsPage(
  requests: [],
  total: 0,
  page: 1,
  limit: 20,
);
const _firstPage = AdminSubjectRequestsPage(
  requests: [
    AdminSubjectRequestModel(id: 'first', status: 'pending', studentName: 'A'),
  ],
  total: 2,
  page: 1,
  limit: 1,
);
const _newPage = AdminSubjectRequestsPage(
  requests: [
    AdminSubjectRequestModel(id: 'new', status: 'pending', studentName: 'B'),
  ],
  total: 1,
  page: 1,
  limit: 20,
);
const _oldSecondPage = AdminSubjectRequestsPage(
  requests: [
    AdminSubjectRequestModel(id: 'old', status: 'pending', studentName: 'C'),
  ],
  total: 2,
  page: 2,
  limit: 1,
);

class FakeRegistrationRepo implements RegistrationRequestsRepo {
  int fetchCalls = 0;
  @override
  Future<Either<Failure, GetRegistrationRequestsResponseModel>>
  getEgyptianRegistrationRequests({int page = 1}) async {
    fetchCalls++;
    return const Right(
      GetRegistrationRequestsResponseModel(
        success: true,
        results: 0,
        pagination: RegistrationRequestsPaginationModel(
          currentPage: 1,
          perPage: 20,
          total: 0,
          lastPage: 1,
        ),
        requests: [],
      ),
    );
  }

  static const _action = RegistrationRequestActionResponseModel(
    success: true,
    message: 'ok',
    student: null,
  );
  @override
  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  approveEgyptianRegistration({required String studentId}) async =>
      const Right(_action);
  @override
  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  confirmEgyptianRegistrationPayment({
    required String studentId,
    required ConfirmRegistrationPaymentRequestModel request,
  }) async => const Right(_action);
  @override
  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  rejectEgyptianRegistration({required String studentId}) async =>
      const Right(_action);
}
