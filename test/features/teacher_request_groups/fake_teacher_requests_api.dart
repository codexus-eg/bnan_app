import 'package:bnan_app/core/network/api_consumer.dart';

class FakeTeacherRequestsApi implements ApiConsumer {
  String? getPath;
  String? patchPath;
  Object? patchData;
  Map<String, dynamic>? query;
  bool getProtected = false;
  bool patchProtected = false;
  @override
  Future<Object?> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    getPath = path;
    query = queryParameter;
    getProtected = isProtected;
    return {
      'data': [
        {'requestId': 'request-1', 'studentName': 'Student'},
      ],
      'pagination': {'currentPage': 1, 'lastPage': 1},
    };
  }

  @override
  Future<Object?> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    patchPath = path;
    patchData = data;
    patchProtected = isProtected;
    return {
      'data': {
        'requestId': 'request-1',
        'classroom': {'id': 'classroom-1'},
        'chatRoom': {'id': 'chat-1'},
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
