import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthUserModel registration modes', () {
    for (final role in ['student', 'supervisor']) {
      for (final mode in RegistrationMode.values) {
        test('parses $role ${mode.name}', () {
          final user = _user({'role': role, 'registrationMode': mode.name});
          expect(user.registrationMode, mode);
          expect(user.registrationModes, isEmpty);
        });
      }
    }

    test('supports null and missing single mode', () {
      expect(_user({'registrationMode': null}).registrationMode, isNull);
      expect(_user({}).registrationMode, isNull);
    });

    for (final mode in RegistrationMode.values) {
      test('parses teacher ${mode.name} only', () {
        final user = _user({
          'role': 'teacher',
          'registrationModes': [mode.name],
        });
        expect(user.registrationModes, [mode]);
      });
    }

    for (final modes in [
      ['egyptian', 'gulf'],
      ['gulf', 'egyptian'],
    ]) {
      test('parses mixed teacher modes in $modes order', () {
        final user = _user({'role': 'teacher', 'registrationModes': modes});
        expect(user.registrationModes, containsAll(RegistrationMode.values));
      });
    }

    test('defaults missing or empty teacher modes to empty', () {
      expect(_user({}).registrationModes, isEmpty);
      expect(_user({'registrationModes': []}).registrationModes, isEmpty);
    });

    test('ignores unknown and malformed values', () {
      final user = _user({
        'registrationMode': 'international',
        'registrationModes': ['gulf', 'international', null, 1],
      });
      expect(user.registrationMode, isNull);
      expect(user.registrationModes, [RegistrationMode.gulf]);
    });

    test('serializes known values for session-compatible JSON', () {
      final json = _user({
        'registrationMode': 'egyptian',
        'registrationModes': ['gulf'],
      }).toJson();
      expect(json['registrationMode'], 'egyptian');
      expect(json['registrationModes'], ['gulf']);
    });
  });
}

AuthUserModel _user(Map<String, dynamic> values) =>
    AuthUserModel.fromJson({'role': 'teacher', ...values});
