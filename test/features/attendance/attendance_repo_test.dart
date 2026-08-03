import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bulk uses one request with the real session id', () async {
    final api = _Api()..response = {'data': <Object>[]};
    final repo = AttendanceRepoImpl(api);
    await repo.submitBulk(
      BulkAttendanceRequest(
        sessionId: 'session-9',
        students: const [
          AttendanceStudentInput(
            studentId: 'student-1',
            status: AttendanceStatus.present,
          ),
        ],
      ),
    );
    expect(api.method, 'POST');
    expect(api.path, EndPoints.bulkAttendance);
    expect((api.data as Map)['sessionId'], 'session-9');
  });

  test('delete 204 does not parse a response body', () async {
    final api = _Api()..response = null;
    final result = await AttendanceRepoImpl(api).delete('attendance-1');
    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.attendanceById('attendance-1'));
  });
}

class _Api implements ApiConsumer {
  String? method, path;
  Object? data, response;
  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    method = 'POST';
    this.path = path;
    this.data = data;
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
    method = 'DELETE';
    this.path = path;
    return response;
  }

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async => response;
  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => response;
  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => response;
}
