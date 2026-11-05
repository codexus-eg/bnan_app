import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo.dart';
import 'package:dio/dio.dart';

class StudentSubjectRequestsRepoImpl implements StudentSubjectRequestsRepo {
  StudentSubjectRequestsRepoImpl(DioConsumer consumer) : _dio = consumer.dio;
  final Dio _dio;

  @override
  getAvailableSubjects() => repoGuard(
    () async => SubjectRequestAvailability.fromJson(
      _map(await _get(EndPoints.studentSubjectRequestAvailableSubjects)),
    ),
  );

  @override
  getPackages(String curriculumId) => repoGuard(() async {
    final json = _map(await _get(EndPoints.packagesByCurriculum(curriculumId)));
    final data = json['data'];
    final items = data is Map ? data['packages'] : data;
    return _list(
      items,
    ).map((item) => PackageModel.fromJson(_map(item))).toList();
  });

  @override
  getRequests() => repoGuard(() async {
    final json = _map(await _get(EndPoints.studentSubjectRequests));
    final data = json['data'];
    final items = data is Map ? data['requests'] : data;
    return _list(
      items,
    ).map((item) => StudentSubjectRequest.fromJson(_map(item))).toList();
  });

  @override
  submitEgyptian(EgyptianSubjectRequestPayload payload) => repoGuard(
    () async => StudentSubjectRequest.fromJson(
      _data(
        _map(
          await _post(EndPoints.studentSubjectRequests, data: payload.toJson()),
        ),
      ),
    ),
  );

  @override
  submitGulfSubjectRequest(GulfSubjectRequestCreatePayload payload) => repoGuard(
    () async => _post(EndPoints.studentSubjectRequests, data: payload.toJson()),
  );

  @override
  checkout({
    required GulfSubjectRequestPayload payload,
    required String idempotencyKey,
  }) => repoGuard(() async {
    final payment = SubjectRequestPayment.fromJson(
      _map(
        await _post(
          EndPoints.studentSubjectRequestCheckout,
          data: payload.toJson(),
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      ),
    );
    final checkoutUri = Uri.tryParse(payment.checkoutUrl ?? '');
    if (payment.paymentId.isEmpty ||
        checkoutUri == null ||
        !checkoutUri.hasScheme ||
        checkoutUri.host.isEmpty) {
      throw const FormatException('Incomplete subject checkout response');
    }
    return payment;
  });

  @override
  status(String paymentId) => repoGuard(
    () async => SubjectRequestPayment.fromJson(
      _map(
        await _get(EndPoints.studentSubjectRequestCheckoutStatus(paymentId)),
      ),
    ),
  );

  @override
  reconcile(String paymentId) => repoGuard(
    () async => SubjectRequestPayment.fromJson(
      _map(
        await _post(
          EndPoints.studentSubjectRequestCheckoutReconcile(paymentId),
        ),
      ),
    ),
  );

  Future<dynamic> _get(String path) async =>
      _guard(() => _dio.get(path, options: _options()));
  Future<dynamic> _post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async =>
      _guard(() => _dio.post(path, data: data, options: _options(headers)));
  Future<dynamic> _guard(Future<Response<dynamic>> Function() call) async {
    try {
      return (await call()).data;
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Options _options([Map<String, dynamic>? headers]) => Options(
    headers: headers,
    extra: {'isProtected': true, 'sensitive': true},
  );
  Map<String, dynamic> _data(Map<String, dynamic> json) =>
      json['data'] is Map ? _map(json['data']) : json;
  Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};
  List<dynamic> _list(dynamic value) => value is List ? value : const [];
}
