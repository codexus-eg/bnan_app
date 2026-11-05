import 'package:bnan_app/core/config/environment_config.dart';
import 'package:bnan_app/core/config/environment_type.dart';
import 'package:bnan_app/core/config/environment_validator.dart';

abstract final class EnvironmentResolver {
  static String? resolveEnvName(String? env, String? appEnv) {
    final e1 = env?.trim() ?? '';
    final e2 = appEnv?.trim() ?? '';
    if (e1.isNotEmpty && e2.isNotEmpty) {
      if (EnvironmentType.parse(e1) != EnvironmentType.parse(e2)) {
        throw StateError(
          'Conflicting environment flags: ENV="$env" and APP_ENV="$appEnv".',
        );
      }
      return e1;
    }
    return e1.isNotEmpty ? e1 : (e2.isNotEmpty ? e2 : null);
  }

  static void assertNoStagingUrls(EnvironmentType type, String? b, String? s) {
    final has = b?.trim().isNotEmpty == true || s?.trim().isNotEmpty == true;
    if (type == EnvironmentType.production && has) {
      throw StateError(
        'Staging URL was supplied without selecting Staging. Set ENV=staging.',
      );
    }
  }

  static EnvironmentConfig resolveStaging(
    String? b,
    String? fbB,
    String? s,
    String? fbS,
  ) {
    final base = b?.trim().isNotEmpty == true ? b : fbB;
    final socket = s?.trim().isNotEmpty == true ? s : fbS;
    final uri = EnvironmentValidator.validateStagingBase(base);
    return EnvironmentConfig(
      type: EnvironmentType.staging,
      baseUrl: uri.toString(),
      socketUrl: EnvironmentValidator.resolveSocket(uri, socket),
    );
  }
}
