abstract class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signUp = '/SignUp';
  static const String logIn = '/logIn';
  static const String savedAccounts = '/saved-accounts';
  static const String forgetPassword = '/forget-password';
  static const String register = '/register';
  static const String curriculum = '/curriculum';
  static const String subscription = '/subscription';
  static const String studentRegistration = '/student-registration';
  static const String parentRegistration = '/parent-registration';
  static const String changePassword = '/change-password';
  static const String home = '/home';
  static const String notification = '/notification';
  static const String notificationSettings = '/notification/settings';
  static const String globalNotificationDetails =
      '/global_notification_details/:broadcastId';
  static const String chat = '/chat/:roomId';
  static const String legacyChat = '/chat';
  static const String classroomDocuments = '/classroomDocuments';
  static const String classroomMembers = '/classroomMembers';
  static const String studentGroups = '/studentGroups';
  static const String requestLesson = '/requestLesson';
  static const String studentSubjects = '/studentSubjects';
  static const String studentSubscriptions = '/student/subscriptions';
  static const String studentSubscriptionRenewal =
      '/student/subscriptions/renew';
  static const String updatePhone = '/updatePhone';
  static const String updateUserName = '/updateUserName';
  static const String updatePassword = '/updatePassword';
  static const String teacherRegistration = '/teacherRegistration';
  static const String teacherHome = '/teacherHome';
  static const String adminHome = '/adminHome';
  static const String addClassroomSubject = '/admin/classroom-subjects/add';
  static const String discountCodes = '/discountCodes';
  static const String teacherPayrolls = '/admin/teacher-payrolls';
  static const String teacherPayrollCreate =
      '/admin/teacher-payrolls/teacher/:teacherId';
  static const String teacherPayrollSessions =
      '/admin/teacher-payrolls/teacher/:teacherId/curriculum/:curriculumId/sessions';
  static const String teacherPayrollDetails =
      '/admin/teacher-payrolls/payroll/:payrollId';
  static const String teacherPayrollPayment =
      '/admin/teacher-payrolls/payroll/:payrollId/payment';
  static const String teacherMyPayrollReport =
      '/teacher/my-payrolls/:payrollId';
  static const String supervisorHome = '/supervisorHome';
  static const String parentHome = '/parentHome';
  static const String parentAddChild = '/parent/children/add';
  static const String parentSubscriptions = '/parent/subscriptions';
  static const String parentSubscriptionRenewal =
      '/parent/subscriptions/:studentId/renew';
  static const String parentSchedule = '/parentSchedule';
  static const String teacherSections = '/teacherSections';
  static const String certificatesManagement = '/certificatesManagement';
  static const String teacherRegistrationRequest =
      '/teacherRegistrationRequest';
  static const String groups = '/groups';
  static const String teacherPerformance = '/teacherPerformance';
  static const String teacherMyEarnings = '/teacherMyEarnings';
  static const String teacherMyPayoutProfile = '/teacher/payout-profile';
  static const String weeklyIdealStudents = '/weeklyIdealStudents';
  static const String idealTeacher = '/idealTeacher';
  static const String idealSupervisor = '/idealSupervisor';
  static const String weeklyEvaluations = '/weeklyEvaluations';
  static const String attendance = '/attendance';
  static const String classSchedules = '/classSchedules';
  static const String plans = '/plans';
  static const String termPlans = '/termPlans';
  static const String parentCertificates = '/parentCertificates';
  static const String teacherSubjectAssignmentView =
      '/teacherSubjectAssignmentView';
  static const String classRoomManagement = '/classRoomManagement';
  static const String curriculumManagement = '/curriculumManagement';
  static const String tablesManagement = '/tablesManagement';
  static const String egyptianSchedulesReadOnly = '/egyptianSchedulesReadOnly';
  static const String gulfStudentScheduleReadOnly =
      '/gulfStudentScheduleReadOnly';
  static const String lessonsManagement = '/lessonsManagement';
  static const String teacherApplication = '/teacherApplication';
  static const String registrationRequests = '/registrationRequests';
  static const String adminEgyptianSubscriptionRenewals =
      '/admin/subscription-renewals/egyptian';
  static const String gradesManagement = '/gradesManagement';
  static const String studentClassroomAssignment =
      '/studentClassroomAssignment';
  static const String supervisorClassRoomAssignment =
      '/supervisorClassRoomAssignment';

  static String teacherPayrollCreatePath(String teacherId) =>
      teacherPayrollCreate.replaceFirst(':teacherId', teacherId);
  static String get directLogIn => '$logIn?direct=true';
  static String chatPath(String roomId) =>
      chat.replaceFirst(':roomId', Uri.encodeComponent(roomId));
  static String globalNotificationDetailsPath(String broadcastId) =>
      globalNotificationDetails.replaceFirst(
        ':broadcastId',
        Uri.encodeComponent(broadcastId),
      );
  static String parentSubscriptionRenewalPath(String studentId) =>
      parentSubscriptionRenewal.replaceFirst(':studentId', studentId);
  static String teacherPayrollDetailsPath(String payrollId) =>
      teacherPayrollDetails.replaceFirst(':payrollId', payrollId);
  static String teacherPayrollPaymentPath(String payrollId) =>
      teacherPayrollPayment.replaceFirst(':payrollId', payrollId);
  static String teacherMyPayrollReportPath(String payrollId) =>
      teacherMyPayrollReport.replaceFirst(':payrollId', payrollId);
  static String get teacherHomePayrollsPath => '$teacherHome?tab=payrolls';
  static String teacherPayrollSessionsPath(
    String teacherId,
    String curriculumId,
  ) => teacherPayrollSessions
      .replaceFirst(':teacherId', teacherId)
      .replaceFirst(':curriculumId', curriculumId);
}
