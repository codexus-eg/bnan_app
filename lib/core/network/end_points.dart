abstract class EndPoints {
  static String get baseUrl => 'https://bnan.0xcode7.xyz/api/v1';
  static String get socketUrl => 'https://bnan.0xcode7.xyz';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String verifyResetCode = '/auth/verifyResetCode';
  static const String resetPassword = '/auth/resetPassword';
  static const String updatePassword = '/auth/updatePassword';
  static const String registerTeacher = '/auth/register-teacher';
  static const String registerParent = '/auth/register-parent';
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
  static const String supervisorMyClassrooms = '/supervisors/me/classrooms';
  static const String teacherAssignedSubjects =
      '/teachers/me/assigned-subjects';
  static const String users = '/users';
  static const String teachingAssignments = '/teachers/teaching-assignments';
  static const String classrooms = '/classrooms';
  static const String egyptianSchedules = '/egyptianSchedules';
  static const String subjects = '/subjects';
  static const String grades = '/grades';
  static const String teachers = '/teachers';
  static const String supervisors = '/supervisors';
  static const String studentMonthlyCertificates =
      '/certificates/student-monthly/';
  static const String issueMonthlyCertificates =
      '/certificates/student-monthly/issue';
  static const String egyptianRegistrationRequests =
      '/admin/egyptian-registration-requests';
  // Chats - Rooms
  static const String createSupportRoom = '/chats/support-room';
  static const String getMyChatRooms = '/chats/rooms';
  static const String sendMessage = '/messages';
  static const String enrollments = '/enrollments';
  // Packages
  static const String packages = '/packages';
  static const String parentChildren = '/parents/my-childs';
  static const String parentChildrenPlans = '/parent/children-plans';
  static const String studentEvaluations = '/student-evaluations';
  static const String myEvaluations = '/student-evaluations/me';
  static const String attendance = '/attendance';
  static const String bulkAttendance = '$attendance/bulk';
  static const String gulfSchedules = '/gulfSchedules';
  static const String myGulfSchedule = '$gulfSchedules/mySchedule';

  static String updateCurriculum(String curriculumId) {
    return '$curriculums/$curriculumId';
  }

  static String confirmEgyptianRegistrationPayment(String studentId) {
    return '$egyptianRegistrationRequests/$studentId/payment';
  }

  static String approveEgyptianRegistration(String studentId) {
    return '$egyptianRegistrationRequests/$studentId/approve';
  }

  static String rejectEgyptianRegistration(String studentId) {
    return '$egyptianRegistrationRequests/$studentId/reject';
  }

  static String packageById(String packageId) {
    return '$packages/$packageId';
  }

  static String packagesByCurriculum(String curriculumId) {
    return '$packages/curriculum/$curriculumId';
  }

  static String get unassignedStudents {
    return '$enrollments/unassigned';
  }

  static String availableClassroomsForUnassignedStudent(String studentId) {
    return '$enrollments/unassigned/$studentId/classrooms';
  }

  static String get assignStudentToClassroom {
    return '$enrollments/assign';
  }

  static String getChatRoom(String roomId) {
    return '/chats/rooms/$roomId';
  }

  static String getRoomMessages(String roomId) {
    return '/chats/rooms/$roomId/messages';
  }

  // Chats - Messages

  static String editMessage(String messageId) {
    return '/messages/$messageId';
  }

  static String deleteMessage(String messageId) {
    return '/messages/$messageId';
  }

  static String monthlyCertificates({String? gradeId}) {
    if (gradeId == null || gradeId.isEmpty) {
      return '/certificates/monthly';
    }

    return '/certificates/monthly?gradeId=$gradeId';
  }

  static String teachersByStatus(String status) {
    return '$teachers?status=$status';
  }

  static String teacherById(String teacherId) {
    return '$teachers/$teacherId';
  }

  static String certificateById(String certificateId) {
    return '/certificates/$certificateId';
  }

  static String updateMonthlyCertificate(String certificateId) {
    return '/certificates/$certificateId/student-monthly/';
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

  static String getGrades({String? curriculumId}) {
    final id = curriculumId?.trim();

    if (id == null || id.isEmpty) {
      return '/grades';
    }

    return '/grades?curriculum=$id';
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

  static String assignmentSubmissions(String assignmentId) {
    return '/assignments/$assignmentId/submissions';
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

  static String assignTeacher(String teacherId) {
    return '/teachers/$teacherId/teaching-assignment';
  }

  static String unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) {
    return '/teachers/$teacherId/classrooms/$classroomId/unassign';
  }

  static String supervisorAssignments(String supervisorId) {
    return '/supervisors/$supervisorId/assignments';
  }

  static String unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) {
    return '/supervisors/$supervisorId/classrooms/$classroomId/unassign';
  }

  static String getClassroomsByGrade(String gradeId) {
    return '$classrooms?grade=$gradeId';
  }

  static String getClassroom(String classroomId) {
    return '$classrooms/$classroomId';
  }

  static String classroomStudents(String classroomId) {
    return '$classrooms/$classroomId/students';
  }

  static String classroomSessions(String classroomId) {
    return '$classrooms/$classroomId/sessions';
  }

  static String startClassroomSession(String classroomId) {
    return '${classroomSessions(classroomId)}/start';
  }

  static String attendanceById(String attendanceId) {
    return '$attendance/$attendanceId';
  }

  static String gulfScheduleByClassroom(String classroomId) {
    return '$gulfSchedules/classroom/$classroomId';
  }

  static String studentSubjects({
    required String classroomId,
    required String studentId,
  }) {
    return '$classrooms/$classroomId/students/$studentId/subjects';
  }

  static String egyptianSchedulesList({String? gradeId}) {
    final id = gradeId?.trim();

    if (id == null || id.isEmpty) {
      return egyptianSchedules;
    }

    return '$egyptianSchedules?gradeId=$id';
  }

  static String egyptianSchedulesByClassroom(String classroomId) {
    return '$egyptianSchedules/classroom/$classroomId';
  }

  static String deleteEgyptianSchedule(String scheduleId) {
    return '$egyptianSchedules/$scheduleId';
  }

  static String createClassroom = classrooms;

  static String updateClassroom(String classroomId) {
    return '$classrooms/$classroomId';
  }

  static String deleteClassroom(String classroomId) {
    return '$classrooms/$classroomId';
  }

  static String createPlan({
    required String classroomId,
    required String subjectId,
  }) {
    return '$classrooms/$classroomId/plans/$subjectId';
  }

  static String plansByWeek({required String classroomId, required int week}) {
    return '$classrooms/$classroomId/plans/week/$week';
  }

  static String termPlans(String classroomId) {
    return '$classrooms/$classroomId/plans/term';
  }

  static const String allTermPlans = '/classrooms/plans/term';

  static String elapsedPlanWeeks(String classroomId) {
    return '$classrooms/$classroomId/plans/weeks/elapsed';
  }

  static String elapsedEvaluationWeeks(String classroomId) {
    return '$classrooms/$classroomId/evaluations/weeks/elapsed';
  }

  static String classroomWeeklyEvaluations(String classroomId) {
    return '$classrooms/$classroomId/evaluations/weekly';
  }
}
