import 'package:bnan_app/core/config/app_environment.dart';
import 'package:bnan_app/core/config/environment_config.dart';
import 'package:bnan_app/core/config/environment_type.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvironmentType.parse', () {
    test('defaults to production for null or empty strings', () {
      expect(EnvironmentType.parse(null), EnvironmentType.production);
      expect(EnvironmentType.parse(''), EnvironmentType.production);
      expect(EnvironmentType.parse('   '), EnvironmentType.production);
    });

    test('accepts production and prod case-insensitively', () {
      expect(EnvironmentType.parse('production'), EnvironmentType.production);
      expect(EnvironmentType.parse('PRODUCTION'), EnvironmentType.production);
      expect(EnvironmentType.parse('prod'), EnvironmentType.production);
      expect(EnvironmentType.parse(' Prod '), EnvironmentType.production);
    });

    test('accepts staging and stage case-insensitively', () {
      expect(EnvironmentType.parse('staging'), EnvironmentType.staging);
      expect(EnvironmentType.parse('STAGING'), EnvironmentType.staging);
      expect(EnvironmentType.parse('stage'), EnvironmentType.staging);
      expect(EnvironmentType.parse(' Stage '), EnvironmentType.staging);
    });

    test('fails fast on unknown environment strings', () {
      expect(
        () => EnvironmentType.parse('local'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Unknown environment "local"'),
          ),
        ),
      );
      expect(() => EnvironmentType.parse('dev'), throwsA(isA<StateError>()));
      expect(() => EnvironmentType.parse('qa'), throwsA(isA<StateError>()));
      expect(() => EnvironmentType.parse('test'), throwsA(isA<StateError>()));
    });
  });

  group('Conflicting Environment Flags', () {
    test('detects conflicting ENV and APP_ENV values', () {
      expect(
        () => EnvironmentConfig.resolve(env: 'production', appEnv: 'staging'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Conflicting environment flags'),
          ),
        ),
      );
      expect(
        () => EnvironmentConfig.resolve(env: 'stage', appEnv: 'prod'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Conflicting environment flags'),
          ),
        ),
      );
    });

    test('allows consistent ENV and APP_ENV values', () {
      final config = EnvironmentConfig.resolve(
        env: 'staging',
        appEnv: 'stage',
        stagingBaseUrl: 'https://staging-api.example.com/api/v1',
      );
      expect(config.type, EnvironmentType.staging);
      expect(config.baseUrl, 'https://staging-api.example.com/api/v1');
    });
  });

  group('Staging URL Guard on Production', () {
    test('fails fast if stagingBaseUrl is supplied on Production', () {
      expect(
        () => EnvironmentConfig.resolve(
          stagingBaseUrl: 'https://staging-api.example.com/api/v1',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Staging URL was supplied without selecting Staging'),
          ),
        ),
      );
      expect(
        () => EnvironmentConfig.resolve(
          env: 'production',
          stagingBaseUrl: 'https://staging-api.example.com/api/v1',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Staging URL was supplied without selecting Staging'),
          ),
        ),
      );
    });

    test('fails fast if stagingSocketUrl is supplied on Production', () {
      expect(
        () => EnvironmentConfig.resolve(
          env: 'production',
          stagingSocketUrl: 'https://staging-socket.example.com',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Staging URL was supplied without selecting Staging'),
          ),
        ),
      );
    });
  });

  group('Production Host Parsed URI Protection', () {
    test('blocks exact production host and aliases in staging base URL', () {
      for (final host in [
        'api.bnanacademysa.com',
        'bnanacademysa.com',
        'www.bnanacademysa.com',
      ]) {
        expect(
          () => EnvironmentConfig.resolve(
            env: 'staging',
            baseUrl: 'https://$host/api/v1',
          ),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('cannot point to the production host'),
            ),
          ),
        );
      }
    });

    test('blocks production host in staging socket URL', () {
      expect(
        () => EnvironmentConfig.resolve(
          env: 'staging',
          baseUrl: 'https://valid-staging.example.com/api/v1',
          socketUrl: 'https://socket.bnanacademysa.com',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('cannot point to the production host'),
          ),
        ),
      );
    });

    test('allows legitimate staging subdomains without false positives', () {
      final config = EnvironmentConfig.resolve(
        env: 'staging',
        baseUrl: 'https://staging-api.bnanacademysa.com/api/v1',
      );
      expect(config.baseUrl, 'https://staging-api.bnanacademysa.com/api/v1');
      expect(config.socketUrl, 'https://staging-api.bnanacademysa.com');
    });
  });

  group('Standard Production Compatibility & EndPoints Delegation', () {
    tearDown(() {
      AppEnvironment.setOverrideForTesting(null);
    });

    test('default environment resolves Production unchanged', () {
      AppEnvironment.setOverrideForTesting(null);
      expect(AppEnvironment.isProduction, isTrue);
      expect(AppEnvironment.isStaging, isFalse);
      expect(AppEnvironment.baseUrl, 'https://api.bnanacademysa.com/api/v1');
      expect(AppEnvironment.socketUrl, 'https://api.bnanacademysa.com');
      expect(EndPoints.baseUrl, 'https://api.bnanacademysa.com/api/v1');
      expect(EndPoints.socketUrl, 'https://api.bnanacademysa.com');
    });

    test(
      'AppEnvironment.validate() executes normally on default production',
      () {
        AppEnvironment.setOverrideForTesting(null);
        expect(() => AppEnvironment.validate(), returnsNormally);
      },
    );
  });
}
