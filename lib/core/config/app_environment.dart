import 'package:bnan_app/core/config/environment_config.dart';
import 'package:bnan_app/core/config/environment_type.dart';

abstract final class AppEnvironment {
  static const String _rawEnv = String.fromEnvironment('ENV');
  static const String _rawAppEnv = String.fromEnvironment('APP_ENV');
  static const String _stagingBase = String.fromEnvironment('STAGING_BASE_URL');
  static const String _rawBase = String.fromEnvironment('BASE_URL');
  static const String _stagingSocket = String.fromEnvironment(
    'STAGING_SOCKET_URL',
  );
  static const String _rawSocket = String.fromEnvironment('SOCKET_URL');

  static EnvironmentConfig? _override;

  static EnvironmentConfig get current =>
      _override ??
      EnvironmentConfig.resolve(
        env: _rawEnv,
        appEnv: _rawAppEnv,
        stagingBaseUrl: _stagingBase,
        baseUrl: _rawBase,
        stagingSocketUrl: _stagingSocket,
        socketUrl: _rawSocket,
      );

  static void setOverrideForTesting(EnvironmentConfig? config) =>
      _override = config;

  static void validate() {
    final _ = current;
  }

  static EnvironmentType get type => current.type;
  static String get baseUrl => current.baseUrl;
  static String get socketUrl => current.socketUrl;
  static bool get isStaging => current.type == EnvironmentType.staging;
  static bool get isProduction => current.type == EnvironmentType.production;
}
