import 'package:bnan_app/features/student_profile/data/models/logged_user_response_model.dart';

abstract class StudentProfileLocalDataSource {
  Future<void> cacheLoggedUser({
    required LoggedUserResponseModel loggedUserResponse,
  });

  Future<LoggedUserResponseModel?> getCachedLoggedUser();

  Future<void> clearCachedLoggedUser();
}

