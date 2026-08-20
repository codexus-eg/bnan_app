import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final session = SessionManager.instance;

  for (final testCase in <(List<String>, bool, bool)>[
    (['egyptian'], true, false),
    (['gulf'], false, true),
    (['egyptian', 'gulf'], true, true),
  ]) {
    test('stores root registrationModes ${testCase.$1}', () async {
      FlutterSecureStorage.setMockInitialValues({});
      await session.clearSession();
      final response = AuthResponseModel.fromJson({
        'success': true,
        'token': 'token',
        'registrationModes': testCase.$1,
        'data': {
          'user': {'id': 'teacher-id', 'role': 'teacher'},
        },
      });

      await session.saveSession(
        accessToken: response.token,
        refreshToken: '',
        userRole: response.user.role,
        registrationModes: response.user.registrationModes,
      );

      expect(session.hasEgyptianRegistration, testCase.$2);
      expect(session.hasGulfRegistration, testCase.$3);
    });
  }
}
