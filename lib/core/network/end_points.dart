abstract class EndPoints {
  static String get baseUrl => 'https://bnan.0xcode7.xyz/api/v1/';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String verifyResetCode = '/auth/verifyResetCode';
  static const String resetPassword = '/auth/resetPassword';
  static const String updatePassword = '/auth/updatePassword';
  static const String registerTeacher = '/auth/register-teacher';
  static const String getLoggedUser = '/users/me';
  static const String updateLoggedUserName = '/users/me/name';
  static const String updateLoggedUserPhone = '/users/me/phone';
  static const String myAssignments = '/students/me/assignments';
  static const String curriculums = '/curriculums';
  static const String studentSubscription = '/students/me/subscription';
  static const String myEnrollments = '/students/me/enrollments';
  static String curriculumPackages(String curriculumId) {
    return '/packages/curriculum/$curriculumId';
  }

  static String curriculumGrades(String curriculumId) {
    return '/grades?curriculum=$curriculumId';
  }

  static String curriculumSubjects({
    required String curriculumId,
    required String gradeId,
  }) {
    return '/subjects/curriculum/$curriculumId?grade=$gradeId';
  }

  static String submitAssignment(String assignmentId) {
    return '/assignments/$assignmentId/submit';
  }
}
