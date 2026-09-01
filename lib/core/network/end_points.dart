import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';

abstract class EndPoints {
  static String get baseUrl => 'https://api.bnanacademysa.com/api/v1';
  static String get socketUrl => 'https://api.bnanacademysa.com';
  // static String get baseUrl => 'https://bnan.0xcode7.xyz/api/v1';
  // static String get socketUrl => 'https://bnan.0xcode7.xyz';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String verifyResetCode = '/auth/verifyResetCode';
  static const String resetPassword = '/auth/resetPassword';
  static const String verifyAccount = '/auth/verify-account';
  static const String resendVerificationCode = '/auth/resend-verification-code';
  static const String updatePassword = '/auth/updatePassword';
  static const String deviceToken = '/devices/token';
  static const String notifications = '/notifications';
  static const String adminEgyptianSubscriptionRenewals =
      '/admin/subscription-renewals/egyptian';
  static String confirmEgyptianSubscriptionRenewal(String paymentId) =>
      '$adminEgyptianSubscriptionRenewals/$paymentId/confirm';
  static String approveEgyptianSubscriptionRenewal(String paymentId) =>
      '$adminEgyptianSubscriptionRenewals/$paymentId/approve';
  static String rejectEgyptianSubscriptionRenewal(String paymentId) =>
      '$adminEgyptianSubscriptionRenewals/$paymentId/reject';
  static const String notificationsRead = '/notifications/read';
  static String globalNotification(String broadcastId) =>
      '$notifications/global/$broadcastId';
  static const String notificationPreferences = '/notification-preferences/me';
  static const String dashboard = '/dashboard';
  static const String registerTeacher = '/auth/register-teacher';
  static const String registerParent = '/auth/register-parent';
  static const String getLoggedUser = '/users/me';
  static const String updateLoggedUserName = '/users/me/name';
  static const String updateLoggedUserPhone = '/users/me/phone';
  static const String myAssignments = '/students/me/assignments';
  static const String mySubjects = '/students/me/subjects';
  static const String studentHome = '/students/me/home';
  static const String myCertificates = '/certificates/my';
  static const String curriculums = '/curriculums';
  static const String myEnrollments = '/students/me/enrollments';
  static const String teacherCurriculums = '/teachers/mycurriculums';
  static const String teacherProfile = '/users/teacherProfile';
  static const String assignments = '/assignments';
  static const String teacherClassrooms = '/teachers/myclassrooms';
  static const String gulfTeacherRequests = '/gulf-teacher-requests';
  static const String supervisorMyClassrooms = '/supervisors/me/classrooms';
  static const String supervisorTeachers = '/supervisors/me/teachers';
  static const String supervisorTeacherCertificates =
      '/supervisors/me/teacher-certificates';
  static const String supervisorIdealTeachers =
      '/supervisors/me/ideal-teachers';
  static const String teacherAssignedSubjects =
      '/teachers/me/assigned-subjects';
  static const String users = '/users';
  static const String teachingAssignments = '/teachers/teaching-assignments';
  static const String classrooms = '/classrooms';
  static const String egyptianSchedules = '/egyptianSchedules';
  static const String myEgyptianSchedule = '$egyptianSchedules/mySchedule';
  static const String subjects = '/subjects';
  static const String classroomSubjectsRoot = '/classroomsubjects/';
  static const String grades = '/grades';
  static const String teachers = '/teachers';
  static const String supervisors = '/supervisors';
  static const String adminIdealSupervisors = '/supervisors/ideal-supervisors';
  static const String studentMonthlyCertificates =
      '/certificates/student-monthly/';
  static const String issueMonthlyCertificates =
      '/certificates/student-monthly/issue';
  static const String egyptianRegistrationRequests =
      '/admin/egyptian-registration-requests';
  static const String adminDiscountCodes = '/admin/discount-codes';
  static const String adminPayrolls = '/admin/payrolls';
  static const String adminSubjectRequests = '/admin/subject-requests';
  static const String adminClassroomChangeRequests =
      '/admin/classroom-change-requests';
  static const String adminPayrollsPreview = '$adminPayrolls/preview';
  static const String teacherMyPayrolls = '/teachers/me/payrolls';
  static const String teacherMyPayoutProfile = '/teachers/me/payout-profile';
  // Chats - Rooms
  static const String createSupportRoom = '/chats/support-room';
  static const String supervisorStudentRoom = '/chats/supervisor-student-room';
  static const String adminChatRooms = '/chats/admin/rooms';
  static const String getMyChatRooms = '/chats/rooms';
  static const String sendMessage = '/messages';
  static const String enrollments = '/enrollments';
  // Packages
  static const String packages = '/packages';
  static const String parentChildren = '/parents/my-childs';
  static const String parentChildrenSubscriptions =
      '/parents/children-subscriptions';
  static const String egyptianSubscriptionRenewal =
      '/subscription-renewals/egyptian';
  static const String gulfSubscriptionRenewal = '/subscription-renewals/gulf';
  static const String parentChildEgyptianRegistration =
      '/parents/children/egyptian-registration';
  static const String parentChildGulfCheckout =
      '/parents/children/gulf-checkout';
  static const String parentChildrenPlans = '/parent/children-plans';
  static const String studentEvaluations = '/student-evaluations';
  static const String myEvaluations = '/student-evaluations/me';
  static const String attendance = '/attendance';
  static const String bulkAttendance = '$attendance/bulk';
  static const String gulfSchedules = '/gulfSchedules';
  static const String myGulfSchedule = '$gulfSchedules/mySchedule';
  static const String paymentCheckout = '/payment/checkout';
  static const String discountPreview = '/payment/discount/preview';
  static const String studentSubjectRequests = '/gulf-student-subject-requests';
  static const String studentSubjectRequestAvailableSubjects =
      '$studentSubjectRequests/available-subjects';
  static const String studentSubjectRequestCheckout =
      '$studentSubjectRequests/checkout';

  static String classroomWeeklyRanking(String classroomId) {
    return '$classrooms/$classroomId/weekly-ranking';
  }

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

  static String adminDiscountCode(String id) {
    return '$adminDiscountCodes/$id';
  }

  static String adminPayroll(String id) => '$adminPayrolls/$id';

  static String approveAdminSubjectRequest(String id) =>
      '$adminSubjectRequests/$id/approve';

  static String rejectAdminSubjectRequest(String id) =>
      '$adminSubjectRequests/$id/reject';

  static String classroomChangeRequests(String classroomId) =>
      '$classrooms/$classroomId/change-requests';

  static String classroomTeacherRequests(String classroomId) =>
      '$classrooms/$classroomId/teacher-requests';

  static String adminClassroomChangeRequest(String id) =>
      '$adminClassroomChangeRequests/$id';

  static String approveClassroomChangeRequest(String id) =>
      '${adminClassroomChangeRequest(id)}/approve';

  static String rejectClassroomChangeRequest(String id) =>
      '${adminClassroomChangeRequest(id)}/reject';

  static String teacherMyPayroll(String id) => '$teacherMyPayrolls/$id';

  static String teacherPayrollPreview(String teacherId) =>
      '$adminPayrolls/teachers/$teacherId/preview';

  static String teacherPayrollSessions(String teacherId, String curriculumId) =>
      '$adminPayrolls/teachers/$teacherId/curriculums/$curriculumId/sessions';

  static String teacherPayoutProfile(String teacherId) =>
      '$adminPayrolls/teachers/$teacherId/payout-profile';

  static String payTeacherPayroll(String payrollId) =>
      '${adminPayroll(payrollId)}/pay';

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

  static String markRoomAsRead(String roomId) {
    return '/chats/rooms/$roomId/read';
  }

  static String deleteRoomMessages(String roomId) {
    return '/chats/rooms/$roomId/messages';
  }

  // Chats - Messages

  static String editMessage(String messageId) {
    return '/messages/$messageId';
  }

  static String deleteMessage(String messageId) {
    return '/messages/$messageId';
  }

  static String monthlyCertificates({String? classroomId}) {
    if (classroomId == null || classroomId.isEmpty) {
      return '/certificates/monthly';
    }

    return '/certificates/monthly?classroomId=$classroomId';
  }

  static String createMonthlyStudentCertificate(String studentId) {
    return '/certificates/monthly/student/$studentId';
  }

  static String teachersByStatus(String status) {
    return '$teachers?status=$status';
  }

  static String teacherById(String teacherId) {
    return '$teachers/$teacherId';
  }

  static String acceptGulfTeacherRequest(String requestId) {
    return '$gulfTeacherRequests/$requestId/accept';
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

  static String gradesByCurriculum(String curriculumId) {
    return '/grades/curriculum/$curriculumId';
  }

  static String gradeSubjects(String gradeId) {
    return '/grades/$gradeId/subjects';
  }

  static String tamaraReconcile(String paymentId) {
    return '/payment/tamara/$paymentId/reconcile';
  }

  static String paymentStatus(GulfPaymentProvider provider, String paymentId) =>
      '/payment/${provider.apiValue}/$paymentId/status';

  static String studentSubjectRequestCheckoutStatus(String paymentId) =>
      '$studentSubjectRequestCheckout/$paymentId/status';

  static String studentSubjectRequestCheckoutReconcile(String paymentId) =>
      '$studentSubjectRequestCheckout/$paymentId/reconcile';

  static String egyptianRenewalStatus(String paymentId) =>
      '$egyptianSubscriptionRenewal/$paymentId/status';

  static String gulfRenewalStatus(String paymentId) =>
      '$gulfSubscriptionRenewal/$paymentId/status';

  static String gulfRenewalReconcile(String paymentId) =>
      '$gulfSubscriptionRenewal/$paymentId/reconcile';

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

  static String supervisorCallStudent(String studentId) {
    return '/supervisors/me/students/$studentId/call';
  }

  static String supervisorTeacherCertificate(String teacherId) {
    return '/supervisors/me/teachers/$teacherId/certificate';
  }

  static String classroomSessions(String classroomId) {
    return '$classrooms/$classroomId/sessions';
  }

  static String classroomRecordings(String classroomId) {
    return '$classrooms/$classroomId/recordings';
  }

  static String classroomSummaries(String classroomId) {
    return '$classrooms/$classroomId/summaries';
  }

  static String startClassroomSession(String classroomId) {
    return '${classroomSessions(classroomId)}/start';
  }

  static String activeClassroomSession(String classroomId) {
    return '${classroomSessions(classroomId)}/active';
  }

  static String joinActiveClassroomSession(String classroomId) {
    return '${activeClassroomSession(classroomId)}/join';
  }

  static String endSession(String sessionId) => '/sessions/$sessionId/end';

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

  static String egyptianScheduleDay(String classroomId, String date) {
    return '${egyptianSchedulesByClassroom(classroomId)}/days/$date';
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

  static String classroomPlans(String classroomId) {
    return '$classrooms/$classroomId/plans';
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
