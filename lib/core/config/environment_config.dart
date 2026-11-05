import 'package:bnan_app/core/config/environment_resolver.dart';
import 'package:bnan_app/core/config/environment_type.dart';

class EnvironmentConfig {
  const EnvironmentConfig({
    required this.type,
    required this.baseUrl,
    required this.socketUrl,
  });

  final EnvironmentType type;
  final String baseUrl;
  final String socketUrl;

  static const String prodBaseUrl = 'https://api.bnanacademysa.com/api/v1';
  static const String prodSocketUrl = 'https://api.bnanacademysa.com';
  static const EnvironmentConfig production = EnvironmentConfig(
    type: EnvironmentType.production,
    baseUrl: prodBaseUrl,
    socketUrl: prodSocketUrl,
  );

  static EnvironmentConfig resolve({
    String? env,
    String? appEnv,
    String? stagingBaseUrl,
    String? baseUrl,
    String? stagingSocketUrl,
    String? socketUrl,
  }) {
    final envName = EnvironmentResolver.resolveEnvName(env, appEnv);
    final type = EnvironmentType.parse(envName);
    EnvironmentResolver.assertNoStagingUrls(
      type,
      stagingBaseUrl,
      stagingSocketUrl,
    );
    if (type == EnvironmentType.production) return production;
    return EnvironmentResolver.resolveStaging(
      stagingBaseUrl,
      baseUrl,
      stagingSocketUrl,
      socketUrl,
    );
  }
}
