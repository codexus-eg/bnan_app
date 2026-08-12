import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/push_notifications/data/models/device_token_payload.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo.dart';

class DeviceTokenRepoImpl implements DeviceTokenRepo {
  const DeviceTokenRepoImpl(this._api);
  final ApiConsumer _api;

  @override
  Future<void> register(DeviceTokenPayload payload) async {
    await _api.post(
      EndPoints.deviceToken,
      data: payload.toJson(),
      isProtected: true,
    );
  }

  @override
  Future<void> delete({required String token}) async {
    await _api.delete(
      EndPoints.deviceToken,
      data: {'token': token},
      isProtected: true,
    );
  }
}
