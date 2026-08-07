import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_request.dart';
import 'package:bnan_app/features/discount_codes/data/repos/discount_codes_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const request = DiscountCodeRequest(
    code: 'FAMILY25',
    type: DiscountCodeType.children,
    percentage: 25,
    isActive: true,
    childrenCount: 3,
  );

  test('CRUD uses protected Admin discount endpoints', () async {
    final api = _Api();
    final repo = DiscountCodesRepoImpl(api);
    await repo.getAll();
    await repo.getById('id-1');
    await repo.create(request);
    await repo.update('id-1', request);
    await repo.delete('id-1');
    expect(api.calls, [
      'GET ${EndPoints.adminDiscountCodes} true',
      'GET ${EndPoints.adminDiscountCode('id-1')} true',
      'POST ${EndPoints.adminDiscountCodes} true',
      'PATCH ${EndPoints.adminDiscountCode('id-1')} true',
      'DELETE ${EndPoints.adminDiscountCode('id-1')} true',
    ]);
  });
}

class _Api implements ApiConsumer {
  final calls = <String>[];
  final response = {
    'data': {
      '_id': 'id-1',
      'code': 'FAMILY25',
      'type': 'children',
      'percentage': 25,
      'childrenCount': 3,
      'isActive': true,
    },
  };

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    calls.add('GET $path $isProtected');
    return path == EndPoints.adminDiscountCodes
        ? {
            'data': [response['data']],
          }
        : response;
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    calls.add('POST $path $isProtected');
    return response;
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    calls.add('PATCH $path $isProtected');
    return response;
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    calls.add('DELETE $path $isProtected');
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
