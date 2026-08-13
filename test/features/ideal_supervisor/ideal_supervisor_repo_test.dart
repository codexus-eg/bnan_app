import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/ideal_supervisor/data/models/ideal_supervisor_request.dart';
import 'package:bnan_app/features/ideal_supervisor/data/repos/admin_ideal_supervisor_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'posts exact contract to protected ideal supervisors endpoint',
    () async {
      final api = _Api();
      await AdminIdealSupervisorRepoImpl(api).issueIdealSupervisors(
        const IdealSupervisorRequest(
          supervisorIds: ['sup-1', 'sup-2'],
          signerName: 'Admin Name',
        ),
      );
      expect(api.path, '/supervisors/ideal-supervisors');
      expect(api.path, EndPoints.adminIdealSupervisors);
      expect(api.protected, isTrue);
      expect(api.body, {
        'supervisorIds': ['sup-1', 'sup-2'],
        'signerName': 'Admin Name',
      });
    },
  );
}

class _Api implements ApiConsumer {
  String? path;
  Object? body;
  bool protected = false;
  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    body = data;
    protected = isProtected;
    return {'success': true};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
