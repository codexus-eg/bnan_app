import 'package:bnan_app/features/push_notifications/data/models/device_token_payload.dart';

abstract interface class DeviceTokenRepo {
  Future<void> register(DeviceTokenPayload payload);
  Future<void> delete({required String token, required String deviceId});
}
