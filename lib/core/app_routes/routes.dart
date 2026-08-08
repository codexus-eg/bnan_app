abstract class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signUp = '/SignUp';
  static const String logIn = '/logIn';
  static const String forgetPassword = '/forget-password';
  static const String register = '/register';
  static const String curriculum = '/curriculum';
  static const String subscription = '/subscription';
  static const String studentRegistration = '/student-registration';
  static const String parentRegistration = '/parent-registration';
  static const String changePassword = '/change-password';
  static const String home = '/home';
  static const String notification = '/notification';
  static const String chat = '/chat';
  static const String classroomDocuments = '/classroomDocuments';
  static const String studentGroups = '/studentGroups';
  static const String requestLesson = '/requestLesson';
  static const String studentSubjects = '/studentSubjects';
  static const String updatePhone = '/updatePhone';
  static const String updateUserName = '/updateUserName';
  static const String updatePassword = '/updatePassword';
  static const String teacherRegistration = '/teacherRegistration';
  static const String teacherHome = '/teacherHome';
  static const String adminHome = '/adminHome';
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
  static const String supervisorHome = '/supervisorHome';
  static const String parentHome = '/parentHome';
  static const String parentSchedule = '/parentSchedule';
  static const String teacherSections = '/teacherSections';
  static const String certificatesManagement = '/certificatesManagement';
  static const String teacherRegistrationRequest =
      '/teacherRegistrationRequest';
  static const String groups = '/groups';
  static const String teacherPerformance = '/teacherPerformance';
  static const String weeklyIdealStudents = '/weeklyIdealStudents';
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
  static const String gradesManagement = '/gradesManagement';
  static const String studentClassroomAssignment =
      '/studentClassroomAssignment';
  static const String supervisorClassRoomAssignment =
      '/supervisorClassRoomAssignment';

  static String teacherPayrollCreatePath(String teacherId) =>
      teacherPayrollCreate.replaceFirst(':teacherId', teacherId);
  static String teacherPayrollDetailsPath(String payrollId) =>
      teacherPayrollDetails.replaceFirst(':payrollId', payrollId);
  static String teacherPayrollPaymentPath(String payrollId) =>
      teacherPayrollPayment.replaceFirst(':payrollId', payrollId);
  static String teacherPayrollSessionsPath(
    String teacherId,
    String curriculumId,
  ) => teacherPayrollSessions
      .replaceFirst(':teacherId', teacherId)
      .replaceFirst(':curriculumId', curriculumId);
}
