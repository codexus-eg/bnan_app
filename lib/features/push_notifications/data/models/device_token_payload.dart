class DeviceTokenPayload {
  const DeviceTokenPayload({
    required this.token,
    required this.platform,
    required this.deviceId,
    required this.appVersion,
  });

  final String token, platform, deviceId, appVersion;

  Map<String, dynamic> toJson() => {
    'token': token,
    'platform': platform,
    'deviceId': deviceId,
    'appVersion': appVersion,
  };
}
