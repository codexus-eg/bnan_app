import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'admin_dashboard_test_data.dart';

class FakeAdminDashboardApi implements ApiConsumer {
  FakeAdminDashboardApi({this.fail = false});
  final bool fail;
  String? path;
  bool protected = false;

  @override
  Future<Object?> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    protected = isProtected;
    if (fail) throw const AppException('network failed');
    return dashboardResponse;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
