import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/policies/change_request_access_policy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final mode in RegistrationMode.values) {
    test(
      '${mode.name} student can request only from private classroom',
      () async {
        FlutterSecureStorage.setMockInitialValues({});
        await SessionManager.instance.saveSession(
          accessToken: 'token',
          refreshToken: 'refresh',
          userRole: 'student',
          registrationMode: mode,
        );

        expect(
          ChangeRequestAccessPolicy.canShow(
            role: UserRole.student,
            roomType: 'classroom',
            accessScope: 'private',
          ),
          isTrue,
        );
        expect(
          ChangeRequestAccessPolicy.canShow(
            role: UserRole.student,
            roomType: 'classroom',
            accessScope: 'shared_group',
          ),
          isFalse,
        );
      },
    );
  }
}
