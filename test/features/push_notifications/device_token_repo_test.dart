import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/push_notifications/data/models/device_token_payload.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('register and delete use protected device token endpoint', () async {
    final api = _Api();
    final repo = DeviceTokenRepoImpl(api);
    await repo.register(
      const DeviceTokenPayload(
        token: 'token',
        platform: 'android',
        deviceId: 'device',
        appVersion: '1.0.0',
      ),
    );
    await repo.delete(token: 'token', deviceId: 'device');
    expect(api.paths, [EndPoints.deviceToken, EndPoints.deviceToken]);
    expect(api.protected, everyElement(isTrue));
    expect(api.bodies.last, {'token': 'token', 'deviceId': 'device'});
  });
}

class _Api implements ApiConsumer {
  final paths = <String>[];
  final bodies = <Object?>[];
  final protected = <bool>[];

  void capture(String path, Object? data, bool isProtected) {
    paths.add(path);
    bodies.add(data);
    protected.add(isProtected);
  }

  @override
  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => capture(path, data, isProtected);

  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => capture(path, data, isProtected);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
