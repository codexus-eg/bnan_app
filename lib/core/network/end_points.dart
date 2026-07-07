abstract class EndPoints {
  static String get baseUrl => 'https://bnan.0xcode7.xyz/api/v1';

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
  static const String teacherCurriculums = '/teachers/mycurriculums';
  static const String teacherProfile = '/users/teacherProfile';
  static const String assignments = '/assignments';
  static const String teacherClassrooms = '/teachers/myclassrooms';
  static const String users = '/users';
  static const String teachingAssignments = '/teachers/teaching-assignments';
  static const String classrooms = '/classrooms';
  static const String subjects = '/subjects';
  static const String grades = '/grades';
  static const String teachers = '/teachers';

  static String teachersByStatus(String status) {
    return '$teachers?status=$status';
  }

  static String teacherById(String teacherId) {
    return '$teachers/$teacherId';
  }

  static String teacherStatus(String teacherId) {
    return '$teachers/$teacherId/status';
  }

  static String gradeById(String gradeId) {
    return '$grades/$gradeId';
  }

  static String subjectById(String subjectId) {
    return '$subjects/$subjectId';
  }

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

  static String teacherGradesByCurriculum(String curriculumId) {
    return '/teachers/$curriculumId/grades';
  }

  static String teacherClassroomStudents(String classroomId) {
    return '/teachers/$classroomId/students';
  }

  static String teacherGrades(String curriculumId) {
    return '/teachers/$curriculumId/grades';
  }

  static String assignmentById(String assignmentId) {
    return '/assignments/$assignmentId';
  }

  static String reviewSubmission({
    required String assignmentId,
    required String submissionId,
  }) {
    return '/assignments/$assignmentId/submissions/$submissionId/review';
  }

  static String gradeClassrooms(String gradeId) {
    return '/grades/$gradeId/classrooms';
  }

  static String classroomSubjectsDetails(String classroomId) {
    return '/classrooms/$classroomId/subjects';
  }

  static String classroomSubjects(String classroomId) {
    return '/classroomsubjects?classroom=$classroomId';
  }

  static String subjectDetails(String subjectId) {
    return '/subjects/$subjectId';
  }

  static String userById(String userId) {
    return '/users/$userId';
  }

  static String userPassword(String userId) {
    return '/users/$userId/password';
  }

  static String userStatus(String userId) {
    return '/users/$userId/status';
  }

  static String assignCurriculumsToTeacher(String teacherId) {
    return '/teachers/$teacherId/curriculums/assign';
  }

  static String bulkAssignTeachingAssignments(String teacherId) {
    return '/teachers/$teacherId/teaching-assignments';
  }

  static String getClassroomsByGrade(String gradeId) {
    return '$classrooms?grade=$gradeId';
  }

  static String getClassroom(String classroomId) {
    return '$classrooms/$classroomId';
  }

  static String createClassroom = classrooms;

  static String updateClassroom(String classroomId) {
    return '$classrooms/$classroomId';
  }

  static String deleteClassroom(String classroomId) {
    return '$classrooms/$classroomId';
  }
}
