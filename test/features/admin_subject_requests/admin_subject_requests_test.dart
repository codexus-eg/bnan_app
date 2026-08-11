import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_status.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_requests_page.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo_impl.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_state.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
import 'package:bnan_app/features/registration_requests/data/models/confirm_registration_payment_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/get_registration_requests_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_action_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_requests_pagination_model.dart';
import 'package:bnan_app/features/registration_requests/data/repo/registration_requests_repo.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'fetch uses protected status/page/limit query and parses pagination',
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
      ).getRequests(status: 'awaiting_admin_approval', page: 2, limit: 20);
      final page = result.getOrElse(() => throw StateError('failed'));
      expect(api.path, EndPoints.adminSubjectRequests);
      expect(api.query, {
        'status': 'awaiting_admin_approval',
        'page': 2,
        'limit': 20,
      });
      expect(api.isProtected, isTrue);
      expect(page.requests.single.id, 'request-1');
      expect(page.hasMore, isFalse);
    },
  );

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

  test('cubit sends status and next pagination page', () async {
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
    await cubit.load(status: AdminSubjectRequestStatus.awaitingAdminApproval);
    await cubit.loadMore();
    expect(repo.fetches, [
      ('awaiting_admin_approval', 1, 20),
      ('awaiting_admin_approval', 2, 20),
    ]);
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
  final fetches = <(String, int, int)>[];
  Either<Failure, String> approveResult = const Right('approved');
  Either<Failure, String> rejectResult = const Right('rejected');
  @override
  Future<Either<Failure, AdminSubjectRequestsPage>> getRequests({
    required String status,
    int page = 1,
    int limit = 20,
  }) async {
    fetches.add((status, page, limit));
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

class FakeRegistrationRepo implements RegistrationRequestsRepo {
  int fetchCalls = 0;
  @override
  Future<Either<Failure, GetRegistrationRequestsResponseModel>>
  getEgyptianRegistrationRequests({
    required String status,
    int page = 1,
  }) async {
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
