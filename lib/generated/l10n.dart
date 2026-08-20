// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Connection timed out.`
  String get errorConnectionTimeout {
    return Intl.message(
      'Connection timed out.',
      name: 'errorConnectionTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Send timeout occurred.`
  String get errorSendTimeout {
    return Intl.message(
      'Send timeout occurred.',
      name: 'errorSendTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Receive timeout occurred.`
  String get errorReceiveTimeout {
    return Intl.message(
      'Receive timeout occurred.',
      name: 'errorReceiveTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Untrusted SSL certificate.`
  String get errorBadCertificate {
    return Intl.message(
      'Untrusted SSL certificate.',
      name: 'errorBadCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Request was cancelled.`
  String get errorCancel {
    return Intl.message(
      'Request was cancelled.',
      name: 'errorCancel',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get errorNoInternet {
    return Intl.message(
      'No internet connection.',
      name: 'errorNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred.`
  String get errorUnknown {
    return Intl.message(
      'An unexpected error occurred.',
      name: 'errorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Bad request.`
  String get errorBadRequest {
    return Intl.message(
      'Bad request.',
      name: 'errorBadRequest',
      desc: '',
      args: [],
    );
  }

  /// `Please check the entered data and try again.`
  String get errorValidation {
    return Intl.message(
      'Please check the entered data and try again.',
      name: 'errorValidation',
      desc: '',
      args: [],
    );
  }

  /// `Session expired.`
  String get errorUnauthorized {
    return Intl.message(
      'Session expired.',
      name: 'errorUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Search for a student`
  String get searchForStudent {
    return Intl.message(
      'Search for a student',
      name: 'searchForStudent',
      desc: '',
      args: [],
    );
  }

  /// `No student found with this name`
  String get noStudentWithThisName {
    return Intl.message(
      'No student found with this name',
      name: 'noStudentWithThisName',
      desc: '',
      args: [],
    );
  }

  /// `This student cannot be assigned because the account has not been approved yet`
  String get studentAssignmentNotApproved {
    return Intl.message(
      'This student cannot be assigned because the account has not been approved yet',
      name: 'studentAssignmentNotApproved',
      desc: '',
      args: [],
    );
  }

  /// `No classrooms are available for this student`
  String get studentAssignmentNoClassrooms {
    return Intl.message(
      'No classrooms are available for this student',
      name: 'studentAssignmentNoClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `This student is already assigned`
  String get studentAssignmentAlreadyAssigned {
    return Intl.message(
      'This student is already assigned',
      name: 'studentAssignmentAlreadyAssigned',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired. Please sign in again`
  String get sessionExpiredLoginAgain {
    return Intl.message(
      'Your session has expired. Please sign in again',
      name: 'sessionExpiredLoginAgain',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription has ended. Please renew it to continue.`
  String get subscriptionAccessExpired {
    return Intl.message(
      'Your subscription has ended. Please renew it to continue.',
      name: 'subscriptionAccessExpired',
      desc: '',
      args: [],
    );
  }

  /// `Unable to connect to the internet. Please try again`
  String get internetConnectionFailedRetry {
    return Intl.message(
      'Unable to connect to the internet. Please try again',
      name: 'internetConnectionFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load classrooms. Please try again`
  String get studentClassroomsLoadFailed {
    return Intl.message(
      'Unable to load classrooms. Please try again',
      name: 'studentClassroomsLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Access denied.`
  String get errorForbidden {
    return Intl.message(
      'Access denied.',
      name: 'errorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Item not found.`
  String get errorNotFound {
    return Intl.message(
      'Item not found.',
      name: 'errorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Internal server error.`
  String get errorInternalServer {
    return Intl.message(
      'Internal server error.',
      name: 'errorInternalServer',
      desc: '',
      args: [],
    );
  }

  /// `Unknown status code: {statusCode}`
  String errorUnknownStatusCode(Object statusCode) {
    return Intl.message(
      'Unknown status code: $statusCode',
      name: 'errorUnknownStatusCode',
      desc: '',
      args: [statusCode],
    );
  }

  /// `Name cannot be empty.`
  String get nameCannotBeEmpty {
    return Intl.message(
      'Name cannot be empty.',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters.`
  String get nameMinLength {
    return Intl.message(
      'Name must be at least 3 characters.',
      name: 'nameMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty.`
  String get emailCannotBeEmpty {
    return Intl.message(
      'Email cannot be empty.',
      name: 'emailCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty.`
  String get passwordCannotBeEmpty {
    return Intl.message(
      'Password cannot be empty.',
      name: 'passwordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters.`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 8 characters.',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one uppercase letter.`
  String get passwordMustHaveUpperCase {
    return Intl.message(
      'Password must contain at least one uppercase letter.',
      name: 'passwordMustHaveUpperCase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one number.`
  String get passwordMustHaveNumber {
    return Intl.message(
      'Password must contain at least one number.',
      name: 'passwordMustHaveNumber',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password cannot be empty.`
  String get confirmPasswordCannotBeEmpty {
    return Intl.message(
      'Confirm password cannot be empty.',
      name: 'confirmPasswordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Send reset Code`
  String get sendResetLink {
    return Intl.message(
      'Send reset Code',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Sent successfully`
  String get resetPasswordSuccessTitle {
    return Intl.message(
      'Sent successfully',
      name: 'resetPasswordSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Check your email {email} and follow the instructions to reset your password.`
  String resetPasswordSuccessSubtitle(Object email) {
    return Intl.message(
      'Check your email $email and follow the instructions to reset your password.',
      name: 'resetPasswordSuccessSubtitle',
      desc: '',
      args: [email],
    );
  }

  /// `Back to login`
  String get backToLogin {
    return Intl.message(
      'Back to login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Check your email `
  String get checkYourEmailPrefix {
    return Intl.message(
      'Check your email ',
      name: 'checkYourEmailPrefix',
      desc: '',
      args: [],
    );
  }

  /// ` and follow the instructions to reset your password.`
  String get resetPasswordInstructions {
    return Intl.message(
      ' and follow the instructions to reset your password.',
      name: 'resetPasswordInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get loginWelcomeTitle {
    return Intl.message(
      'Welcome',
      name: 'loginWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Log in to access your dashboard`
  String get loginWelcomeSubtitle {
    return Intl.message(
      'Log in to access your dashboard',
      name: 'loginWelcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `At least 6 characters`
  String get passwordHint {
    return Intl.message(
      'At least 6 characters',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account? `
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get createNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Choose account type to continue`
  String get chooseAccountType {
    return Intl.message(
      'Choose account type to continue',
      name: 'chooseAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Register as Student`
  String get registerAsStudent {
    return Intl.message(
      'Register as Student',
      name: 'registerAsStudent',
      desc: '',
      args: [],
    );
  }

  /// `Join classes and start your learning journey`
  String get registerAsStudentSubtitle {
    return Intl.message(
      'Join classes and start your learning journey',
      name: 'registerAsStudentSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Register as Parent`
  String get registerAsParent {
    return Intl.message(
      'Register as Parent',
      name: 'registerAsParent',
      desc: '',
      args: [],
    );
  }

  /// `Track your children’s progress and contact teachers`
  String get registerAsParentSubtitle {
    return Intl.message(
      'Track your children’s progress and contact teachers',
      name: 'registerAsParentSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Apply as Teacher`
  String get applyAsTeacher {
    return Intl.message(
      'Apply as Teacher',
      name: 'applyAsTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Share your expertise and join our teaching team`
  String get applyAsTeacherSubtitle {
    return Intl.message(
      'Share your expertise and join our teaching team',
      name: 'applyAsTeacherSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginNow {
    return Intl.message('Login', name: 'loginNow', desc: '', args: []);
  }

  /// `Curricula`
  String get curricula {
    return Intl.message('Curricula', name: 'curricula', desc: '', args: []);
  }

  /// `Study Curricula `
  String get studyCurriculaTitle {
    return Intl.message(
      'Study Curricula ',
      name: 'studyCurriculaTitle',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `Choose the suitable curriculum  and start the learning journey with us`
  String get chooseCurriculum {
    return Intl.message(
      'Choose the suitable curriculum  and start the learning journey with us',
      name: 'chooseCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Saudi Curriculum`
  String get saudiCurriculum {
    return Intl.message(
      'Saudi Curriculum',
      name: 'saudiCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `We provide all subjects for primary, middle, and secondary stages according to the approved curriculum.`
  String get saudiCurriculumDesc {
    return Intl.message(
      'We provide all subjects for primary, middle, and secondary stages according to the approved curriculum.',
      name: 'saudiCurriculumDesc',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian Curriculum`
  String get egyptianCurriculum {
    return Intl.message(
      'Egyptian Curriculum',
      name: 'egyptianCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Integrated education for primary, preparatory, and secondary grades according to the modern Egyptian curriculum.`
  String get egyptianCurriculumDesc {
    return Intl.message(
      'Integrated education for primary, preparatory, and secondary grades according to the modern Egyptian curriculum.',
      name: 'egyptianCurriculumDesc',
      desc: '',
      args: [],
    );
  }

  /// `Qatari Curriculum`
  String get qatariCurriculum {
    return Intl.message(
      'Qatari Curriculum',
      name: 'qatariCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `A curriculum approved by the Ministry of Education in Qatar, covering basic stages up to secondary school.`
  String get qatariCurriculumDesc {
    return Intl.message(
      'A curriculum approved by the Ministry of Education in Qatar, covering basic stages up to secondary school.',
      name: 'qatariCurriculumDesc',
      desc: '',
      args: [],
    );
  }

  /// `Browse section`
  String get browseSection {
    return Intl.message(
      'Browse section',
      name: 'browseSection',
      desc: '',
      args: [],
    );
  }

  /// `Packages`
  String get packages {
    return Intl.message('Packages', name: 'packages', desc: '', args: []);
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Packages`
  String get Packages {
    return Intl.message('Packages', name: 'Packages', desc: '', args: []);
  }

  /// `You can change the currency from the list`
  String get canChangeCurrency {
    return Intl.message(
      'You can change the currency from the list',
      name: 'canChangeCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Currency:`
  String get currency {
    return Intl.message('Currency:', name: 'currency', desc: '', args: []);
  }

  /// `Saudi Riyal (SAR)`
  String get sarCurrency {
    return Intl.message(
      'Saudi Riyal (SAR)',
      name: 'sarCurrency',
      desc: '',
      args: [],
    );
  }

  /// `{hours} training hours`
  String trainingHours(Object hours) {
    return Intl.message(
      '$hours training hours',
      name: 'trainingHours',
      desc: '',
      args: [hours],
    );
  }

  /// `{count} weekly lessons`
  String weeklyLessons(Object count) {
    return Intl.message(
      '$count weekly lessons',
      name: 'weeklyLessons',
      desc: '',
      args: [count],
    );
  }

  /// `SAR {price}`
  String oldPrice(Object price) {
    return Intl.message(
      'SAR $price',
      name: 'oldPrice',
      desc: '',
      args: [price],
    );
  }

  /// `SAR {price}`
  String currentPrice(Object price) {
    return Intl.message(
      'SAR $price',
      name: 'currentPrice',
      desc: '',
      args: [price],
    );
  }

  /// `Save SAR {amount}`
  String saveAmount(Object amount) {
    return Intl.message(
      'Save SAR $amount',
      name: 'saveAmount',
      desc: '',
      args: [amount],
    );
  }

  /// `Subscribe now`
  String get subscribeNow {
    return Intl.message(
      'Subscribe now',
      name: 'subscribeNow',
      desc: '',
      args: [],
    );
  }

  /// `Most popular`
  String get mostPopular {
    return Intl.message(
      'Most popular',
      name: 'mostPopular',
      desc: '',
      args: [],
    );
  }

  /// `8-hour package`
  String get eightHoursPlan {
    return Intl.message(
      '8-hour package',
      name: 'eightHoursPlan',
      desc: '',
      args: [],
    );
  }

  /// `4-hour package`
  String get fourHoursPlan {
    return Intl.message(
      '4-hour package',
      name: 'fourHoursPlan',
      desc: '',
      args: [],
    );
  }

  /// `20-hour package`
  String get twentyHoursPlan {
    return Intl.message(
      '20-hour package',
      name: 'twentyHoursPlan',
      desc: '',
      args: [],
    );
  }

  /// `12-hour package`
  String get twelveHoursPlan {
    return Intl.message(
      '12-hour package',
      name: 'twelveHoursPlan',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian Pound (EGP)`
  String get egpCurrency {
    return Intl.message(
      'Egyptian Pound (EGP)',
      name: 'egpCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Qatari Riyal (QAR)`
  String get qarCurrency {
    return Intl.message(
      'Qatari Riyal (QAR)',
      name: 'qarCurrency',
      desc: '',
      args: [],
    );
  }

  /// `QAR`
  String get qarShort {
    return Intl.message('QAR', name: 'qarShort', desc: '', args: []);
  }

  /// `Student Registration Form`
  String get studentRegistrationForm {
    return Intl.message(
      'Student Registration Form',
      name: 'studentRegistrationForm',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields`
  String get pleaseFillRequiredInfo {
    return Intl.message(
      'Please fill in all required fields',
      name: 'pleaseFillRequiredInfo',
      desc: '',
      args: [],
    );
  }

  /// `Parent Information`
  String get parentInfo {
    return Intl.message(
      'Parent Information',
      name: 'parentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Parent Name`
  String get parentName {
    return Intl.message('Parent Name', name: 'parentName', desc: '', args: []);
  }

  /// `Enter parent name`
  String get parentNameHint {
    return Intl.message(
      'Enter parent name',
      name: 'parentNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Parent Registration Form`
  String get parentRegistrationForm {
    return Intl.message(
      'Parent Registration Form',
      name: 'parentRegistrationForm',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard Password`
  String get dashboardPassword {
    return Intl.message(
      'Dashboard Password',
      name: 'dashboardPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get parentPasswordMinLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'parentPasswordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get invalidPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp number`
  String get whatsappNumber {
    return Intl.message(
      'WhatsApp number',
      name: 'whatsappNumber',
      desc: '',
      args: [],
    );
  }

  /// `Student platform password`
  String get studentPassword {
    return Intl.message(
      'Student platform password',
      name: 'studentPassword',
      desc: '',
      args: [],
    );
  }

  /// `You will use it to log in with your email after completing payment.`
  String get passwordWillBeUsed {
    return Intl.message(
      'You will use it to log in with your email after completing payment.',
      name: 'passwordWillBeUsed',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum Selection`
  String get curriculumSelection {
    return Intl.message(
      'Curriculum Selection',
      name: 'curriculumSelection',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum`
  String get curriculum {
    return Intl.message('Curriculum', name: 'curriculum', desc: '', args: []);
  }

  /// `Student Information`
  String get studentInfo {
    return Intl.message(
      'Student Information',
      name: 'studentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Student name`
  String get studentName {
    return Intl.message(
      'Student name',
      name: 'studentName',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get grade {
    return Intl.message('Grade', name: 'grade', desc: '', args: []);
  }

  /// `Select grade`
  String get selectGrade {
    return Intl.message(
      'Select grade',
      name: 'selectGrade',
      desc: '',
      args: [],
    );
  }

  /// `Subjects`
  String get subjects {
    return Intl.message('Subjects', name: 'subjects', desc: '', args: []);
  }

  /// `Math`
  String get math {
    return Intl.message('Math', name: 'math', desc: '', args: []);
  }

  /// `Science`
  String get science {
    return Intl.message('Science', name: 'science', desc: '', args: []);
  }

  /// `Arabic Language`
  String get arabicLanguage {
    return Intl.message(
      'Arabic Language',
      name: 'arabicLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Physics`
  String get physics {
    return Intl.message('Physics', name: 'physics', desc: '', args: []);
  }

  /// `Chemistry`
  String get chemistry {
    return Intl.message('Chemistry', name: 'chemistry', desc: '', args: []);
  }

  /// `Social Studies`
  String get socialStudies {
    return Intl.message(
      'Social Studies',
      name: 'socialStudies',
      desc: '',
      args: [],
    );
  }

  /// `Quran`
  String get quran {
    return Intl.message('Quran', name: 'quran', desc: '', args: []);
  }

  /// `Student Email`
  String get studentEmail {
    return Intl.message(
      'Student Email',
      name: 'studentEmail',
      desc: '',
      args: [],
    );
  }

  /// `Student password`
  String get studentPasswordField {
    return Intl.message(
      'Student password',
      name: 'studentPasswordField',
      desc: '',
      args: [],
    );
  }

  /// `Preferred student schedule`
  String get preferredDays {
    return Intl.message(
      'Preferred student schedule',
      name: 'preferredDays',
      desc: '',
      args: [],
    );
  }

  /// `Select preferred days and times`
  String get preferredDaysHint {
    return Intl.message(
      'Select preferred days and times',
      name: 'preferredDaysHint',
      desc: '',
      args: [],
    );
  }

  /// `Additional notes or details`
  String get notes {
    return Intl.message(
      'Additional notes or details',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Example: every Monday and Wednesday at 5 PM`
  String get notesHint {
    return Intl.message(
      'Example: every Monday and Wednesday at 5 PM',
      name: 'notesHint',
      desc: '',
      args: [],
    );
  }

  /// `Available day`
  String get availableDay {
    return Intl.message(
      'Available day',
      name: 'availableDay',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Selected Package`
  String get selectedPackage {
    return Intl.message(
      'Selected Package',
      name: 'selectedPackage',
      desc: '',
      args: [],
    );
  }

  /// `4-hour package`
  String get package4Hours {
    return Intl.message(
      '4-hour package',
      name: 'package4Hours',
      desc: '',
      args: [],
    );
  }

  /// `{price} SAR × {studentsCount} student = {total} SAR`
  String packageCalculation(Object price, Object studentsCount, Object total) {
    return Intl.message(
      '$price SAR × $studentsCount student = $total SAR',
      name: 'packageCalculation',
      desc: '',
      args: [price, studentsCount, total],
    );
  }

  /// `Apple Pay`
  String get applePay {
    return Intl.message('Apple Pay', name: 'applePay', desc: '', args: []);
  }

  /// `Credit Card`
  String get creditCard {
    return Intl.message('Credit Card', name: 'creditCard', desc: '', args: []);
  }

  /// `Split your bill with Tamara`
  String get tabbyTamara {
    return Intl.message(
      'Split your bill with Tamara',
      name: 'tabbyTamara',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Payment`
  String get goToPayment {
    return Intl.message(
      'Proceed to Payment',
      name: 'goToPayment',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Tamara`
  String get payWithTamara {
    return Intl.message(
      'Pay with Tamara',
      name: 'payWithTamara',
      desc: '',
      args: [],
    );
  }

  /// `Please enter {fieldName}`
  String fieldIsRequired(Object fieldName) {
    return Intl.message(
      'Please enter $fieldName',
      name: 'fieldIsRequired',
      desc: '',
      args: [fieldName],
    );
  }

  /// `Payment Information`
  String get paymentInfo {
    return Intl.message(
      'Payment Information',
      name: 'paymentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Card number`
  String get cardNumber {
    return Intl.message('Card number', name: 'cardNumber', desc: '', args: []);
  }

  /// `Cardholder name`
  String get cardHolderName {
    return Intl.message(
      'Cardholder name',
      name: 'cardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date`
  String get expiryDate {
    return Intl.message('Expiry date', name: 'expiryDate', desc: '', args: []);
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Student notes and schedule preferences`
  String get studentNotesAndSchedule {
    return Intl.message(
      'Student notes and schedule preferences',
      name: 'studentNotesAndSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `Notes about lessons that need explanation, goals, or any other comments`
  String get studentNotesAndScheduleHint {
    return Intl.message(
      'Notes about lessons that need explanation, goals, or any other comments',
      name: 'studentNotesAndScheduleHint',
      desc: '',
      args: [],
    );
  }

  /// `Example: Needs explanation for fractions and long division ...`
  String get studentNotesExample {
    return Intl.message(
      'Example: Needs explanation for fractions and long division ...',
      name: 'studentNotesExample',
      desc: '',
      args: [],
    );
  }

  /// `The student will use it to log in to the dashboard`
  String get studentUsesItForDashboard {
    return Intl.message(
      'The student will use it to log in to the dashboard',
      name: 'studentUsesItForDashboard',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sarShort {
    return Intl.message('SAR', name: 'sarShort', desc: '', args: []);
  }

  /// `student`
  String get student {
    return Intl.message('student', name: 'student', desc: '', args: []);
  }

  /// `Forgot Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and we will send you a reset code`
  String get forgotPasswordSubtitle {
    return Intl.message(
      'Enter your email and we will send you a reset code',
      name: 'forgotPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Send reset code`
  String get sendResetCode {
    return Intl.message(
      'Send reset code',
      name: 'sendResetCode',
      desc: '',
      args: [],
    );
  }

  /// `Check your email and enter the code sent to you`
  String get resetCodeSubtitle {
    return Intl.message(
      'Check your email and enter the code sent to you',
      name: 'resetCodeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Resend code?`
  String get resendCode {
    return Intl.message('Resend code?', name: 'resendCode', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Start your learning journey easily`
  String get onboardingTitle1 {
    return Intl.message(
      'Start your learning journey easily',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `An educational platform that helps you develop your skills`
  String get onboardingSubtitle1 {
    return Intl.message(
      'An educational platform that helps you develop your skills',
      name: 'onboardingSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Interactive lessons and engaging content`
  String get onboardingTitle2 {
    return Intl.message(
      'Interactive lessons and engaging content',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy a flexible learning experience that fits your day and style`
  String get onboardingSubtitle2 {
    return Intl.message(
      'Enjoy a flexible learning experience that fits your day and style',
      name: 'onboardingSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Success starts here`
  String get onboardingTitle3 {
    return Intl.message(
      'Success starts here',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Interactive content that helps you learn in a more enjoyable way`
  String get onboardingSubtitle3 {
    return Intl.message(
      'Interactive content that helps you learn in a more enjoyable way',
      name: 'onboardingSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Start now`
  String get startNow {
    return Intl.message('Start now', name: 'startNow', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Schedule`
  String get schedule {
    return Intl.message('Schedule', name: 'schedule', desc: '', args: []);
  }

  /// `Assignments`
  String get assignments {
    return Intl.message('Assignments', name: 'assignments', desc: '', args: []);
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Welcome`
  String get welcomeYou {
    return Intl.message('Welcome', name: 'welcomeYou', desc: '', args: []);
  }

  /// `Home`
  String get dashboard {
    return Intl.message('Home', name: 'dashboard', desc: '', args: []);
  }

  /// `Study Materials`
  String get studyMaterials {
    return Intl.message(
      'Study Materials',
      name: 'studyMaterials',
      desc: '',
      args: [],
    );
  }

  /// `School Subjects`
  String get schoolSubjects {
    return Intl.message(
      'School Subjects',
      name: 'schoolSubjects',
      desc: '',
      args: [],
    );
  }

  /// `Search for a subject`
  String get searchForSubject {
    return Intl.message(
      'Search for a subject',
      name: 'searchForSubject',
      desc: '',
      args: [],
    );
  }

  /// `No subjects registered yet`
  String get noSubjectsRegistered {
    return Intl.message(
      'No subjects registered yet',
      name: 'noSubjectsRegistered',
      desc: '',
      args: [],
    );
  }

  /// `No subjects match your search`
  String get noSubjectsMatchSearch {
    return Intl.message(
      'No subjects match your search',
      name: 'noSubjectsMatchSearch',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load subjects`
  String get unableToLoadSubjects {
    return Intl.message(
      'Unable to load subjects',
      name: 'unableToLoadSubjects',
      desc: '',
      args: [],
    );
  }

  /// `Request New Lesson`
  String get requestNewLesson {
    return Intl.message(
      'Request New Lesson',
      name: 'requestNewLesson',
      desc: '',
      args: [],
    );
  }

  /// `My Groups`
  String get myGroups {
    return Intl.message('My Groups', name: 'myGroups', desc: '', args: []);
  }

  /// `Certificates`
  String get certificates {
    return Intl.message(
      'Certificates',
      name: 'certificates',
      desc: '',
      args: [],
    );
  }

  /// `No certificates are available yet`
  String get noCertificatesAvailable {
    return Intl.message(
      'No certificates are available yet',
      name: 'noCertificatesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `There are no certificates for this student`
  String get noCertificatesForStudent {
    return Intl.message(
      'There are no certificates for this student',
      name: 'noCertificatesForStudent',
      desc: '',
      args: [],
    );
  }

  /// `This student's certificates cannot be displayed`
  String get cannotDisplayStudentCertificates {
    return Intl.message(
      'This student\'s certificates cannot be displayed',
      name: 'cannotDisplayStudentCertificates',
      desc: '',
      args: [],
    );
  }

  /// `There are no registered children`
  String get noRegisteredChildren {
    return Intl.message(
      'There are no registered children',
      name: 'noRegisteredChildren',
      desc: '',
      args: [],
    );
  }

  /// `Student Certificate`
  String get studentCertificate {
    return Intl.message(
      'Student Certificate',
      name: 'studentCertificate',
      desc: '',
      args: [],
    );
  }

  /// `{month} Certificate`
  String monthlyCertificateTitle(Object month) {
    return Intl.message(
      '$month Certificate',
      name: 'monthlyCertificateTitle',
      desc: '',
      args: [month],
    );
  }

  /// `Certificate file is unavailable`
  String get certificateFileUnavailable {
    return Intl.message(
      'Certificate file is unavailable',
      name: 'certificateFileUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Packages and Subscriptions`
  String get PackagesandSubscriptions {
    return Intl.message(
      'Packages and Subscriptions',
      name: 'PackagesandSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get subscriptions {
    return Intl.message(
      'Subscriptions',
      name: 'subscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Grade 5 Primary`
  String get primaryGradeFive {
    return Intl.message(
      'Grade 5 Primary',
      name: 'primaryGradeFive',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Package Details`
  String get packageDetails {
    return Intl.message(
      'Package Details',
      name: 'packageDetails',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `{hours} Hours`
  String hoursPackage(Object hours) {
    return Intl.message(
      '$hours Hours',
      name: 'hoursPackage',
      desc: '',
      args: [hours],
    );
  }

  /// `{hours} hours remaining`
  String remainingHours(Object hours) {
    return Intl.message(
      '$hours hours remaining',
      name: 'remainingHours',
      desc: '',
      args: [hours],
    );
  }

  /// `{used} of {total} used`
  String usedHours(Object used, Object total) {
    return Intl.message(
      '$used of $total used',
      name: 'usedHours',
      desc: '',
      args: [used, total],
    );
  }

  /// `Expires in 18 days. Auto renewal`
  String get packageExpiryText {
    return Intl.message(
      'Expires in 18 days. Auto renewal',
      name: 'packageExpiryText',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Package`
  String get upgradePackage {
    return Intl.message(
      'Upgrade Package',
      name: 'upgradePackage',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Lesson`
  String get upcomingLesson {
    return Intl.message(
      'Upcoming Lesson',
      name: 'upcomingLesson',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `With Ms. Sarah Abdullah`
  String get withTeacher {
    return Intl.message(
      'With Ms. Sarah Abdullah',
      name: 'withTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Start lesson via Zoom`
  String get startLessonViaZoom {
    return Intl.message(
      'Start lesson via Zoom',
      name: 'startLessonViaZoom',
      desc: '',
      args: [],
    );
  }

  /// `Interaction`
  String get interaction {
    return Intl.message('Interaction', name: 'interaction', desc: '', args: []);
  }

  /// `Attendance`
  String get attendance {
    return Intl.message('Attendance', name: 'attendance', desc: '', args: []);
  }

  /// `Weekly evaluation`
  String get weeklyEvaluation {
    return Intl.message(
      'Weekly evaluation',
      name: 'weeklyEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Attendance Rate`
  String get attendanceRate {
    return Intl.message(
      'Attendance Rate',
      name: 'attendanceRate',
      desc: '',
      args: [],
    );
  }

  /// `Interaction Level`
  String get interactionLevel {
    return Intl.message(
      'Interaction Level',
      name: 'interactionLevel',
      desc: '',
      args: [],
    );
  }

  /// `Assignments Evaluation`
  String get assignmentsEvaluation {
    return Intl.message(
      'Assignments Evaluation',
      name: 'assignmentsEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Note`
  String get teacherNote {
    return Intl.message(
      'Teacher Note',
      name: 'teacherNote',
      desc: '',
      args: [],
    );
  }

  /// `Excellent work on solving the assignments this time.`
  String get teacherNoteText {
    return Intl.message(
      'Excellent work on solving the assignments this time.',
      name: 'teacherNoteText',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `Ms. Sarah`
  String get teacherSarahShort {
    return Intl.message(
      'Ms. Sarah',
      name: 'teacherSarahShort',
      desc: '',
      args: [],
    );
  }

  /// `Grade: {grade}`
  String gradeLabel(Object grade) {
    return Intl.message(
      'Grade: $grade',
      name: 'gradeLabel',
      desc: '',
      args: [grade],
    );
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `Submit Assignment`
  String get submitAssignment {
    return Intl.message(
      'Submit Assignment',
      name: 'submitAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Submitting...`
  String get submittingAssignment {
    return Intl.message(
      'Submitting...',
      name: 'submittingAssignment',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newBadge {
    return Intl.message('New', name: 'newBadge', desc: '', args: []);
  }

  /// `Submitted`
  String get submittedBadge {
    return Intl.message(
      'Submitted',
      name: 'submittedBadge',
      desc: '',
      args: [],
    );
  }

  /// `Third Term Exercises`
  String get thirdTermExercises {
    return Intl.message(
      'Third Term Exercises',
      name: 'thirdTermExercises',
      desc: '',
      args: [],
    );
  }

  /// `Due Friday`
  String get dueFriday {
    return Intl.message('Due Friday', name: 'dueFriday', desc: '', args: []);
  }

  /// `Due Sunday`
  String get dueSunday {
    return Intl.message('Due Sunday', name: 'dueSunday', desc: '', args: []);
  }

  /// `May Certificate`
  String get mayCertificate {
    return Intl.message(
      'May Certificate',
      name: 'mayCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Average {percent}%`
  String averagePercent(Object percent) {
    return Intl.message(
      'Average $percent%',
      name: 'averagePercent',
      desc: '',
      args: [percent],
    );
  }

  /// `Mark as read`
  String get markAsRead {
    return Intl.message('Mark as read', name: 'markAsRead', desc: '', args: []);
  }

  /// `Math lesson starts in 15 min`
  String get lessonStartsSoon {
    return Intl.message(
      'Math lesson starts in 15 min',
      name: 'lessonStartsSoon',
      desc: '',
      args: [],
    );
  }

  /// `New weekly rating for Ahmed`
  String get newRating {
    return Intl.message(
      'New weekly rating for Ahmed',
      name: 'newRating',
      desc: '',
      args: [],
    );
  }

  /// `You received May certificate`
  String get certificateReceived {
    return Intl.message(
      'You received May certificate',
      name: 'certificateReceived',
      desc: '',
      args: [],
    );
  }

  /// `New message from Ms. Sarah`
  String get newMessage {
    return Intl.message(
      'New message from Ms. Sarah',
      name: 'newMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription ends in 5 days`
  String get subscriptionEndsSoon {
    return Intl.message(
      'Your subscription ends in 5 days',
      name: 'subscriptionEndsSoon',
      desc: '',
      args: [],
    );
  }

  /// `Next week schedule was updated`
  String get scheduleUpdated {
    return Intl.message(
      'Next week schedule was updated',
      name: 'scheduleUpdated',
      desc: '',
      args: [],
    );
  }

  /// `A new assignment was uploaded`
  String get newAssignmentUploaded {
    return Intl.message(
      'A new assignment was uploaded',
      name: 'newAssignmentUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Today, {time}`
  String todayAtTime(Object time) {
    return Intl.message(
      'Today, $time',
      name: 'todayAtTime',
      desc: '',
      args: [time],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `2 days ago`
  String get twoDaysAgo {
    return Intl.message('2 days ago', name: 'twoDaysAgo', desc: '', args: []);
  }

  /// `3 days ago`
  String get threeDaysAgo {
    return Intl.message('3 days ago', name: 'threeDaysAgo', desc: '', args: []);
  }

  /// `4 days ago`
  String get fourDaysAgo {
    return Intl.message('4 days ago', name: 'fourDaysAgo', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `In Progress`
  String get pending {
    return Intl.message('In Progress', name: 'pending', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Light and Shadow Experiment`
  String get lightAndShadowExperiment {
    return Intl.message(
      'Light and Shadow Experiment',
      name: 'lightAndShadowExperiment',
      desc: '',
      args: [],
    );
  }

  /// `Poem Analysis`
  String get poemAnalysis {
    return Intl.message(
      'Poem Analysis',
      name: 'poemAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Submitted`
  String get noSubmission {
    return Intl.message('Submitted', name: 'noSubmission', desc: '', args: []);
  }

  /// `Algebra Course Completion Certificate`
  String get algebraCourseCertificate {
    return Intl.message(
      'Algebra Course Completion Certificate',
      name: 'algebraCourseCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Appreciation Certificate - Interaction`
  String get interactionAppreciationCertificate {
    return Intl.message(
      'Appreciation Certificate - Interaction',
      name: 'interactionAppreciationCertificate',
      desc: '',
      args: [],
    );
  }

  /// `April 2026`
  String get april2026 {
    return Intl.message('April 2026', name: 'april2026', desc: '', args: []);
  }

  /// `March 2026`
  String get march2026 {
    return Intl.message('March 2026', name: 'march2026', desc: '', args: []);
  }

  /// `This Month Achievement`
  String get congratsThisMonth {
    return Intl.message(
      'This Month Achievement',
      name: 'congratsThisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Certificate of Appreciation`
  String get newCertificate {
    return Intl.message(
      'Certificate of Appreciation',
      name: 'newCertificate',
      desc: '',
      args: [],
    );
  }

  /// `For excellence in academic performance`
  String get academicPerformanceMessage {
    return Intl.message(
      'For excellence in academic performance',
      name: 'academicPerformanceMessage',
      desc: '',
      args: [],
    );
  }

  /// `Study Schedule`
  String get studySchedule {
    return Intl.message(
      'Study Schedule',
      name: 'studySchedule',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Math`
  String get mathShort {
    return Intl.message('Math', name: 'mathShort', desc: '', args: []);
  }

  /// `Subject`
  String get subject {
    return Intl.message('Subject', name: 'subject', desc: '', args: []);
  }

  /// `Participation`
  String get participation {
    return Intl.message(
      'Participation',
      name: 'participation',
      desc: '',
      args: [],
    );
  }

  /// `Excellent`
  String get excellent {
    return Intl.message('Excellent', name: 'excellent', desc: '', args: []);
  }

  /// `Absent`
  String get absent {
    return Intl.message('Absent', name: 'absent', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Online now`
  String get onlineNow {
    return Intl.message('Online now', name: 'onlineNow', desc: '', args: []);
  }

  /// `Type message.....`
  String get typeMessage {
    return Intl.message(
      'Type message.....',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Ms. Sarah Abdullah`
  String get teacherSarahName {
    return Intl.message(
      'Ms. Sarah Abdullah',
      name: 'teacherSarahName',
      desc: '',
      args: [],
    );
  }

  /// `Hi Ahmed, how is the new assignment going?`
  String get chatMsg1 {
    return Intl.message(
      'Hi Ahmed, how is the new assignment going?',
      name: 'chatMsg1',
      desc: '',
      args: [],
    );
  }

  /// `Great, Ms. Sarah. Thanks for the explanation.`
  String get chatMsg2 {
    return Intl.message(
      'Great, Ms. Sarah. Thanks for the explanation.',
      name: 'chatMsg2',
      desc: '',
      args: [],
    );
  }

  /// `Excellent. Don’t forget to review chapter three before the lesson.`
  String get chatMsg3 {
    return Intl.message(
      'Excellent. Don’t forget to review chapter three before the lesson.',
      name: 'chatMsg3',
      desc: '',
      args: [],
    );
  }

  /// `Okay, I’ll start now`
  String get chatMsg4 {
    return Intl.message(
      'Okay, I’ll start now',
      name: 'chatMsg4',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been accepted!`
  String get requestAccepted {
    return Intl.message(
      'Your request has been accepted!',
      name: 'requestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Math - Ready group`
  String get readyGroupSubtitle {
    return Intl.message(
      'Math - Ready group',
      name: 'readyGroupSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Pending Requests`
  String get pendingRequests {
    return Intl.message(
      'Pending Requests',
      name: 'pendingRequests',
      desc: '',
      args: [],
    );
  }

  /// `Fractions lesson, waiting for a teacher`
  String get pendingMathSubtitle {
    return Intl.message(
      'Fractions lesson, waiting for a teacher',
      name: 'pendingMathSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Light lesson, waiting for a teacher`
  String get pendingScienceSubtitle {
    return Intl.message(
      'Light lesson, waiting for a teacher',
      name: 'pendingScienceSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Active Groups`
  String get activeGroups {
    return Intl.message(
      'Active Groups',
      name: 'activeGroups',
      desc: '',
      args: [],
    );
  }

  /// `Math . Ms. Sarah Abdullah`
  String get mathTeacherSarah {
    return Intl.message(
      'Math . Ms. Sarah Abdullah',
      name: 'mathTeacherSarah',
      desc: '',
      args: [],
    );
  }

  /// `Group created, start now`
  String get groupCreatedByYou {
    return Intl.message(
      'Group created, start now',
      name: 'groupCreatedByYou',
      desc: '',
      args: [],
    );
  }

  /// `Mr. Ahmed Fouad`
  String get teacherAhmedFouad {
    return Intl.message(
      'Mr. Ahmed Fouad',
      name: 'teacherAhmedFouad',
      desc: '',
      args: [],
    );
  }

  /// `Congrats!`
  String get congrats {
    return Intl.message('Congrats!', name: 'congrats', desc: '', args: []);
  }

  /// `Choose a grade`
  String get chooseGrade {
    return Intl.message(
      'Choose a grade',
      name: 'chooseGrade',
      desc: '',
      args: [],
    );
  }

  /// `Student Notes`
  String get studentNotes {
    return Intl.message(
      'Student Notes',
      name: 'studentNotes',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Request`
  String get confirmRequest {
    return Intl.message(
      'Confirm Request',
      name: 'confirmRequest',
      desc: '',
      args: [],
    );
  }

  /// `Biology`
  String get biology {
    return Intl.message('Biology', name: 'biology', desc: '', args: []);
  }

  /// `My requests`
  String get myRequests {
    return Intl.message('My requests', name: 'myRequests', desc: '', args: []);
  }

  /// `Choose curriculum`
  String get chooseNewCurriculum {
    return Intl.message(
      'Choose curriculum',
      name: 'chooseNewCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `The required lesson`
  String get theRequiredLesson {
    return Intl.message(
      'The required lesson',
      name: 'theRequiredLesson',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get resetCodeRequired {
    return Intl.message(
      'Please enter the verification code',
      name: 'resetCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter and confirm your password`
  String get passwordAndConfirmRequired {
    return Intl.message(
      'Please enter and confirm your password',
      name: 'passwordAndConfirmRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Personal Profile`
  String get personalProfile {
    return Intl.message(
      'Personal Profile',
      name: 'personalProfile',
      desc: '',
      args: [],
    );
  }

  /// `الصف الثاني الإعدادي`
  String get studentProfileGrade {
    return Intl.message(
      'الصف الثاني الإعدادي',
      name: 'studentProfileGrade',
      desc: '',
      args: [],
    );
  }

  /// `القسم المصري`
  String get studentProfileClass {
    return Intl.message(
      'القسم المصري',
      name: 'studentProfileClass',
      desc: '',
      args: [],
    );
  }

  /// `Contact Info`
  String get contactInfo {
    return Intl.message(
      'Contact Info',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `userName`
  String get userName {
    return Intl.message('userName', name: 'userName', desc: '', args: []);
  }

  /// `privacy`
  String get privacy {
    return Intl.message('privacy', name: 'privacy', desc: '', args: []);
  }

  /// `Edit Phone Number`
  String get changePhoneTitle {
    return Intl.message(
      'Edit Phone Number',
      name: 'changePhoneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Username`
  String get changeUsernameTitle {
    return Intl.message(
      'Edit Username',
      name: 'changeUsernameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePasswordTitle {
    return Intl.message(
      'Change Password',
      name: 'changePasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPasswordLabel {
    return Intl.message(
      'Old Password',
      name: 'oldPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordLabel {
    return Intl.message(
      'New Password',
      name: 'newPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `No subjects available for this grade`
  String get noSubjectsAvailable {
    return Intl.message(
      'No subjects available for this grade',
      name: 'noSubjectsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Upload Assignment`
  String get uploadAssignment {
    return Intl.message(
      'Upload Assignment',
      name: 'uploadAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Assignment submitted successfully`
  String get assignmentSubmittedSuccessfully {
    return Intl.message(
      'Assignment submitted successfully',
      name: 'assignmentSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Assignment file opened`
  String get fileDownloadStarted {
    return Intl.message(
      'Assignment file opened',
      name: 'fileDownloadStarted',
      desc: '',
      args: [],
    );
  }

  /// `Please select a file first`
  String get pleaseSelectFile {
    return Intl.message(
      'Please select a file first',
      name: 'pleaseSelectFile',
      desc: '',
      args: [],
    );
  }

  /// `No assignments yet`
  String get noAssignmentsYet {
    return Intl.message(
      'No assignments yet',
      name: 'noAssignmentsYet',
      desc: '',
      args: [],
    );
  }

  /// `New assignments will appear here once they are added.`
  String get noAssignmentsYetSubtitle {
    return Intl.message(
      'New assignments will appear here once they are added.',
      name: 'noAssignmentsYetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `No pending assignments`
  String get noPendingAssignments {
    return Intl.message(
      'No pending assignments',
      name: 'noPendingAssignments',
      desc: '',
      args: [],
    );
  }

  /// `All current assignments are completed or there are no new assignments yet.`
  String get noPendingAssignmentsSubtitle {
    return Intl.message(
      'All current assignments are completed or there are no new assignments yet.',
      name: 'noPendingAssignmentsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `No completed assignments`
  String get noCompletedAssignments {
    return Intl.message(
      'No completed assignments',
      name: 'noCompletedAssignments',
      desc: '',
      args: [],
    );
  }

  /// `Completed assignments will appear here.`
  String get noCompletedAssignmentsSubtitle {
    return Intl.message(
      'Completed assignments will appear here.',
      name: 'noCompletedAssignmentsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `InActive`
  String get inactive {
    return Intl.message('InActive', name: 'inactive', desc: '', args: []);
  }

  /// `No groups yet`
  String get noGroupsYet {
    return Intl.message(
      'No groups yet',
      name: 'noGroupsYet',
      desc: '',
      args: [],
    );
  }

  /// `Your groups and pending requests will appear here.`
  String get noGroupsYetSubtitle {
    return Intl.message(
      'Your groups and pending requests will appear here.',
      name: 'noGroupsYetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for teacher approval`
  String get waitingForTeacherApproval {
    return Intl.message(
      'Waiting for teacher approval',
      name: 'waitingForTeacherApproval',
      desc: '',
      args: [],
    );
  }

  /// `{days} Days Package`
  String daysPackage(int days) {
    return Intl.message(
      '$days Days Package',
      name: 'daysPackage',
      desc: '',
      args: [days],
    );
  }

  /// `Used {used} of {total} days`
  String usedDays(int used, int total) {
    return Intl.message(
      'Used $used of $total days',
      name: 'usedDays',
      desc: '',
      args: [used, total],
    );
  }

  /// `{days} days remaining`
  String remainingDays(int days) {
    return Intl.message(
      '$days days remaining',
      name: 'remainingDays',
      desc: '',
      args: [days],
    );
  }

  /// `Logged out successfully`
  String get logoutSuccess {
    return Intl.message(
      'Logged out successfully',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Excellent Teacher`
  String get excellentTeacher {
    return Intl.message(
      'Excellent Teacher',
      name: 'excellentTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Excellence Points`
  String get excellencePoints {
    return Intl.message(
      'Excellence Points',
      name: 'excellencePoints',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get pointsCount {
    return Intl.message('points', name: 'pointsCount', desc: '', args: []);
  }

  /// `Next rank after {teachers} teachers, {points} points to the next level`
  String nextLevelPointsText(int teachers, int points) {
    return Intl.message(
      'Next rank after $teachers teachers, $points points to the next level',
      name: 'nextLevelPointsText',
      desc: '',
      args: [teachers, points],
    );
  }

  /// `Students`
  String get students {
    return Intl.message('Students', name: 'students', desc: '', args: []);
  }

  /// `All students`
  String get allStudents {
    return Intl.message(
      'All students',
      name: 'allStudents',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get classes {
    return Intl.message('Classes', name: 'classes', desc: '', args: []);
  }

  /// `Upcoming Lessons`
  String get upcomingLessons {
    return Intl.message(
      'Upcoming Lessons',
      name: 'upcomingLessons',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Dues`
  String get dues {
    return Intl.message('Dues', name: 'dues', desc: '', args: []);
  }

  /// `Classes Management`
  String get classesManagement {
    return Intl.message(
      'Classes Management',
      name: 'classesManagement',
      desc: '',
      args: [],
    );
  }

  /// `Evaluations`
  String get evaluations {
    return Intl.message('Evaluations', name: 'evaluations', desc: '', args: []);
  }

  /// `Registration Requests`
  String get registrationRequests {
    return Intl.message(
      'Registration Requests',
      name: 'registrationRequests',
      desc: '',
      args: [],
    );
  }

  /// `There are no new registration requests`
  String get noNewRegistrationRequests {
    return Intl.message(
      'There are no new registration requests',
      name: 'noNewRegistrationRequests',
      desc: '',
      args: [],
    );
  }

  /// `The request was accepted and the classroom was created successfully`
  String get teacherRequestAcceptedSuccess {
    return Intl.message(
      'The request was accepted and the classroom was created successfully',
      name: 'teacherRequestAcceptedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `This request was accepted by another teacher`
  String get teacherRequestAlreadyAssigned {
    return Intl.message(
      'This request was accepted by another teacher',
      name: 'teacherRequestAlreadyAssigned',
      desc: '',
      args: [],
    );
  }

  /// `The request cannot be accepted because the subject or grade teaching details changed`
  String get teacherRequestNotEligible {
    return Intl.message(
      'The request cannot be accepted because the subject or grade teaching details changed',
      name: 'teacherRequestNotEligible',
      desc: '',
      args: [],
    );
  }

  /// `Performance`
  String get performance {
    return Intl.message('Performance', name: 'performance', desc: '', args: []);
  }

  /// `Weekly Plans`
  String get weeklyPlans {
    return Intl.message(
      'Weekly Plans',
      name: 'weeklyPlans',
      desc: '',
      args: [],
    );
  }

  /// `Quota report`
  String get quotaReport {
    return Intl.message(
      'Quota report',
      name: 'quotaReport',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active2 {
    return Intl.message('Active', name: 'active2', desc: '', args: []);
  }

  /// `Submitted`
  String get submitted {
    return Intl.message('Submitted', name: 'submitted', desc: '', args: []);
  }

  /// `Not submitted`
  String get notSubmitted {
    return Intl.message(
      'Not submitted',
      name: 'notSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message('Finished', name: 'finished', desc: '', args: []);
  }

  /// `Create New Assignment`
  String get createNewAssignment {
    return Intl.message(
      'Create New Assignment',
      name: 'createNewAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get assignmentTitle {
    return Intl.message('Title', name: 'assignmentTitle', desc: '', args: []);
  }

  /// `Description`
  String get assignmentDescription {
    return Intl.message(
      'Description',
      name: 'assignmentDescription',
      desc: '',
      args: [],
    );
  }

  /// `Classroom`
  String get classRoom {
    return Intl.message('Classroom', name: 'classRoom', desc: '', args: []);
  }

  /// `Choose classroom`
  String get chooseClassRoom {
    return Intl.message(
      'Choose classroom',
      name: 'chooseClassRoom',
      desc: '',
      args: [],
    );
  }

  /// `Choose subject`
  String get chooseSubject {
    return Intl.message(
      'Choose subject',
      name: 'chooseSubject',
      desc: '',
      args: [],
    );
  }

  /// `Delivery date`
  String get deliveryDate {
    return Intl.message(
      'Delivery date',
      name: 'deliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Attachment file`
  String get attachmentFile {
    return Intl.message(
      'Attachment file',
      name: 'attachmentFile',
      desc: '',
      args: [],
    );
  }

  /// `Choose file`
  String get chooseFile {
    return Intl.message('Choose file', name: 'chooseFile', desc: '', args: []);
  }

  /// `Create Assignment`
  String get createAssignment {
    return Intl.message(
      'Create Assignment',
      name: 'createAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Grade Assignment`
  String get correctAssignment {
    return Intl.message(
      'Grade Assignment',
      name: 'correctAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Grade Submission`
  String get submitAssignmentCorrection {
    return Intl.message(
      'Grade Submission',
      name: 'submitAssignmentCorrection',
      desc: '',
      args: [],
    );
  }

  /// `Graded`
  String get graded {
    return Intl.message('Graded', name: 'graded', desc: '', args: []);
  }

  /// `Waiting for Grading`
  String get waitingForCorrection {
    return Intl.message(
      'Waiting for Grading',
      name: 'waitingForCorrection',
      desc: '',
      args: [],
    );
  }

  /// `Submitted:`
  String get submissionDate {
    return Intl.message(
      'Submitted:',
      name: 'submissionDate',
      desc: '',
      args: [],
    );
  }

  /// `Edit Grade`
  String get editGrade {
    return Intl.message('Edit Grade', name: 'editGrade', desc: '', args: []);
  }

  /// `Grade & Assign Score`
  String get gradeAndAssignScore {
    return Intl.message(
      'Grade & Assign Score',
      name: 'gradeAndAssignScore',
      desc: '',
      args: [],
    );
  }

  /// `Assignment Not Submitted Yet`
  String get assignmentNotSubmittedYet {
    return Intl.message(
      'Assignment Not Submitted Yet',
      name: 'assignmentNotSubmittedYet',
      desc: '',
      args: [],
    );
  }

  /// `Degree`
  String get degree {
    return Intl.message('Degree', name: 'degree', desc: '', args: []);
  }

  /// `Submit Grade`
  String get sendCorrection {
    return Intl.message(
      'Submit Grade',
      name: 'sendCorrection',
      desc: '',
      args: [],
    );
  }

  /// `Score is required`
  String get scoreRequired {
    return Intl.message(
      'Score is required',
      name: 'scoreRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid integer score`
  String get validIntegerScore {
    return Intl.message(
      'Enter a valid integer score',
      name: 'validIntegerScore',
      desc: '',
      args: [],
    );
  }

  /// `Score must be between 0 and {totalPoints}`
  String scoreRange(Object totalPoints) {
    return Intl.message(
      'Score must be between 0 and $totalPoints',
      name: 'scoreRange',
      desc: '',
      args: [totalPoints],
    );
  }

  /// `Sections`
  String get sections {
    return Intl.message('Sections', name: 'sections', desc: '', args: []);
  }

  /// `Class`
  String get classR {
    return Intl.message('Class', name: 'classR', desc: '', args: []);
  }

  /// `Issue New Certificate`
  String get issueNewCertificate {
    return Intl.message(
      'Issue New Certificate',
      name: 'issueNewCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Sent`
  String get send {
    return Intl.message('Sent', name: 'send', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Subjects Grades`
  String get subjectsGrades {
    return Intl.message(
      'Subjects Grades',
      name: 'subjectsGrades',
      desc: '',
      args: [],
    );
  }

  /// `Select Student`
  String get selectStudent {
    return Intl.message(
      'Select Student',
      name: 'selectStudent',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Download PDF`
  String get downloadPdf {
    return Intl.message(
      'Download PDF',
      name: 'downloadPdf',
      desc: '',
      args: [],
    );
  }

  /// `Edit Certificate`
  String get editCertificate {
    return Intl.message(
      'Edit Certificate',
      name: 'editCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Accept Request`
  String get acceptRequest {
    return Intl.message(
      'Accept Request',
      name: 'acceptRequest',
      desc: '',
      args: [],
    );
  }

  /// `Accept Request`
  String get acceptStudentRequest {
    return Intl.message(
      'Accept Request',
      name: 'acceptStudentRequest',
      desc: '',
      args: [],
    );
  }

  /// `A study group will be created and the student will be transferred directly to you.`
  String get studentRequestAccepted {
    return Intl.message(
      'A study group will be created and the student will be transferred directly to you.',
      name: 'studentRequestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Groups`
  String get groups {
    return Intl.message('Groups', name: 'groups', desc: '', args: []);
  }

  /// `Submit Request`
  String get submitRequest {
    return Intl.message(
      'Submit Request',
      name: 'submitRequest',
      desc: '',
      args: [],
    );
  }

  /// `Apply as a Teacher at Banan Academy`
  String get teacherApplyTitle {
    return Intl.message(
      'Apply as a Teacher at Banan Academy',
      name: 'teacherApplyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your application will be reviewed and we will reply to you soon`
  String get teacherApplySubtitle {
    return Intl.message(
      'Your application will be reviewed and we will reply to you soon',
      name: 'teacherApplySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get teacherStepPersonalInfo {
    return Intl.message(
      'Personal Information',
      name: 'teacherStepPersonalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Academic Qualification`
  String get teacherStepQualification {
    return Intl.message(
      'Academic Qualification',
      name: 'teacherStepQualification',
      desc: '',
      args: [],
    );
  }

  /// `Work Experience`
  String get teacherStepExperience {
    return Intl.message(
      'Work Experience',
      name: 'teacherStepExperience',
      desc: '',
      args: [],
    );
  }

  /// `Teaching Details`
  String get teacherStepTeachingDetails {
    return Intl.message(
      'Teaching Details',
      name: 'teacherStepTeachingDetails',
      desc: '',
      args: [],
    );
  }

  /// `Technical Skills`
  String get teacherStepTechnicalSkills {
    return Intl.message(
      'Technical Skills',
      name: 'teacherStepTechnicalSkills',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation`
  String get teacherStepEvaluation {
    return Intl.message(
      'Evaluation',
      name: 'teacherStepEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Attachments and Declaration`
  String get teacherStepAttachments {
    return Intl.message(
      'Attachments and Declaration',
      name: 'teacherStepAttachments',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Nationality`
  String get nationality {
    return Intl.message('Nationality', name: 'nationality', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Qualification`
  String get qualification {
    return Intl.message(
      'Qualification',
      name: 'qualification',
      desc: '',
      args: [],
    );
  }

  /// `Specialization`
  String get specialization {
    return Intl.message(
      'Specialization',
      name: 'specialization',
      desc: '',
      args: [],
    );
  }

  /// `University / Institution Name`
  String get universityOrInstitutionName {
    return Intl.message(
      'University / Institution Name',
      name: 'universityOrInstitutionName',
      desc: '',
      args: [],
    );
  }

  /// `Graduation Year`
  String get graduationYear {
    return Intl.message(
      'Graduation Year',
      name: 'graduationYear',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get graduationGrade {
    return Intl.message('Grade', name: 'graduationGrade', desc: '', args: []);
  }

  /// `Application details - {name}`
  String teacherApplicationDetailsTitle(Object name) {
    return Intl.message(
      'Application details - $name',
      name: 'teacherApplicationDetailsTitle',
      desc: '',
      args: [name],
    );
  }

  /// `Birth date`
  String get birthDate {
    return Intl.message('Birth date', name: 'birthDate', desc: '', args: []);
  }

  /// `Major`
  String get major {
    return Intl.message('Major', name: 'major', desc: '', args: []);
  }

  /// `Grade level`
  String get gradeLevel {
    return Intl.message('Grade level', name: 'gradeLevel', desc: '', args: []);
  }

  /// `Platforms used`
  String get platformsUsed {
    return Intl.message(
      'Platforms used',
      name: 'platformsUsed',
      desc: '',
      args: [],
    );
  }

  /// `Taught subjects`
  String get taughtSubjects {
    return Intl.message(
      'Taught subjects',
      name: 'taughtSubjects',
      desc: '',
      args: [],
    );
  }

  /// `Weekly hours`
  String get weeklyHours {
    return Intl.message(
      'Weekly hours',
      name: 'weeklyHours',
      desc: '',
      args: [],
    );
  }

  /// `Desired subjects`
  String get desiredSubjects {
    return Intl.message(
      'Desired subjects',
      name: 'desiredSubjects',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Teachable grades`
  String get teachableGrades {
    return Intl.message(
      'Teachable grades',
      name: 'teachableGrades',
      desc: '',
      args: [],
    );
  }

  /// `Teaching in Bnan`
  String get teachingInBnan {
    return Intl.message(
      'Teaching in Bnan',
      name: 'teachingInBnan',
      desc: '',
      args: [],
    );
  }

  /// `Can provide demo lesson?`
  String get canDemo {
    return Intl.message(
      'Can provide demo lesson?',
      name: 'canDemo',
      desc: '',
      args: [],
    );
  }

  /// `Do you have teaching experience?`
  String get hasTeachingExperience {
    return Intl.message(
      'Do you have teaching experience?',
      name: 'hasTeachingExperience',
      desc: '',
      args: [],
    );
  }

  /// `Have you taught online before?`
  String get taughtOnlineBefore {
    return Intl.message(
      'Have you taught online before?',
      name: 'taughtOnlineBefore',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Please choose the curriculum you teach`
  String get pleaseChooseTeachingCurriculum {
    return Intl.message(
      'Please choose the curriculum you teach',
      name: 'pleaseChooseTeachingCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Kuwaiti Curriculum`
  String get kuwaitiCurriculum {
    return Intl.message(
      'Kuwaiti Curriculum',
      name: 'kuwaitiCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Emirati Curriculum`
  String get emiratiCurriculum {
    return Intl.message(
      'Emirati Curriculum',
      name: 'emiratiCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Please choose the grades for the {curriculum}`
  String pleaseChooseCurriculumGrades(Object curriculum) {
    return Intl.message(
      'Please choose the grades for the $curriculum',
      name: 'pleaseChooseCurriculumGrades',
      desc: '',
      args: [curriculum],
    );
  }

  /// `Please choose the Subjects for the {curriculum}`
  String pleaseChooseCurriculumSubjects(Object curriculum) {
    return Intl.message(
      'Please choose the Subjects for the $curriculum',
      name: 'pleaseChooseCurriculumSubjects',
      desc: '',
      args: [curriculum],
    );
  }

  /// `What is your level of using Computer?`
  String get technicalAppsLevel {
    return Intl.message(
      'What is your level of using Computer?',
      name: 'technicalAppsLevel',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get good {
    return Intl.message('Good', name: 'good', desc: '', args: []);
  }

  /// `Very Good`
  String get veryGood {
    return Intl.message('Very Good', name: 'veryGood', desc: '', args: []);
  }

  /// `Do you have a laptop or computer?`
  String get hasLaptopOrComputer {
    return Intl.message(
      'Do you have a laptop or computer?',
      name: 'hasLaptopOrComputer',
      desc: '',
      args: [],
    );
  }

  /// `Do you have a stable internet connection?`
  String get hasStableInternet {
    return Intl.message(
      'Do you have a stable internet connection?',
      name: 'hasStableInternet',
      desc: '',
      args: [],
    );
  }

  /// `Do you have a good camera?`
  String get hasGoodCamera {
    return Intl.message(
      'Do you have a good camera?',
      name: 'hasGoodCamera',
      desc: '',
      args: [],
    );
  }

  /// `Do you have a clear microphone?`
  String get hasClearMic {
    return Intl.message(
      'Do you have a clear microphone?',
      name: 'hasClearMic',
      desc: '',
      args: [],
    );
  }

  /// `Can you provide a trial lesson?`
  String get canProvideTrialLesson {
    return Intl.message(
      'Can you provide a trial lesson?',
      name: 'canProvideTrialLesson',
      desc: '',
      args: [],
    );
  }

  /// `Short video link (optional)`
  String get shortVideoLinkOptional {
    return Intl.message(
      'Short video link (optional)',
      name: 'shortVideoLinkOptional',
      desc: '',
      args: [],
    );
  }

  /// `Why do you want to join Banan Academy?`
  String get whyJoinBananAcademy {
    return Intl.message(
      'Why do you want to join Banan Academy?',
      name: 'whyJoinBananAcademy',
      desc: '',
      args: [],
    );
  }

  /// `How do you deal with a weak student?`
  String get howHandleWeakStudent {
    return Intl.message(
      'How do you deal with a weak student?',
      name: 'howHandleWeakStudent',
      desc: '',
      args: [],
    );
  }

  /// `Upload CV (pdf)`
  String get uploadCvFile {
    return Intl.message(
      'Upload CV (pdf)',
      name: 'uploadCvFile',
      desc: '',
      args: [],
    );
  }

  /// `Upload certificate or qualification image (image/pdf)`
  String get uploadCertificateFile {
    return Intl.message(
      'Upload certificate or qualification image (image/pdf)',
      name: 'uploadCertificateFile',
      desc: '',
      args: [],
    );
  }

  /// `Upload national ID / identity image (image/pdf)`
  String get uploadNationalIdFile {
    return Intl.message(
      'Upload national ID / identity image (image/pdf)',
      name: 'uploadNationalIdFile',
      desc: '',
      args: [],
    );
  }

  /// `I confirm that all the information mentioned above is correct, and I agree to follow Banan Academy rules and policies`
  String get teacherDeclarationAgreement {
    return Intl.message(
      'I confirm that all the information mentioned above is correct, and I agree to follow Banan Academy rules and policies',
      name: 'teacherDeclarationAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Please answer all questions`
  String get pleaseAnswerAllQuestions {
    return Intl.message(
      'Please answer all questions',
      name: 'pleaseAnswerAllQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Please choose at least one grade`
  String get pleaseChooseAtLeastOneGrade {
    return Intl.message(
      'Please choose at least one grade',
      name: 'pleaseChooseAtLeastOneGrade',
      desc: '',
      args: [],
    );
  }

  /// `Please choose at least one subject for each grade`
  String get pleaseChooseAtLeastOneSubjectForEachGrade {
    return Intl.message(
      'Please choose at least one subject for each grade',
      name: 'pleaseChooseAtLeastOneSubjectForEachGrade',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been submitted and is now under review.`
  String get requestSubmittedUnderReview {
    return Intl.message(
      'Your request has been submitted and is now under review.',
      name: 'requestSubmittedUnderReview',
      desc: '',
      args: [],
    );
  }

  /// `User created successfully`
  String get userCreatedSuccessfully {
    return Intl.message(
      'User created successfully',
      name: 'userCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `User updated successfully`
  String get userUpdatedSuccessfully {
    return Intl.message(
      'User updated successfully',
      name: 'userUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `User password updated successfully`
  String get userPasswordUpdatedSuccessfully {
    return Intl.message(
      'User password updated successfully',
      name: 'userPasswordUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `User status updated successfully`
  String get userStatusUpdatedSuccessfully {
    return Intl.message(
      'User status updated successfully',
      name: 'userStatusUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `User deleted successfully`
  String get userDeletedSuccessfully {
    return Intl.message(
      'User deleted successfully',
      name: 'userDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Current Month`
  String get currentMonth {
    return Intl.message(
      'Current Month',
      name: 'currentMonth',
      desc: '',
      args: [],
    );
  }

  /// `Current Earnings`
  String get currentProfits {
    return Intl.message(
      'Current Earnings',
      name: 'currentProfits',
      desc: '',
      args: [],
    );
  }

  /// `Expected`
  String get expected {
    return Intl.message('Expected', name: 'expected', desc: '', args: []);
  }

  /// `Completed Sessions`
  String get completedSessions {
    return Intl.message(
      'Completed Sessions',
      name: 'completedSessions',
      desc: '',
      args: [],
    );
  }

  /// `Remaining`
  String get remainingSessions {
    return Intl.message(
      'Remaining',
      name: 'remainingSessions',
      desc: '',
      args: [],
    );
  }

  /// `Session Price`
  String get packagePrice {
    return Intl.message(
      'Session Price',
      name: 'packagePrice',
      desc: '',
      args: [],
    );
  }

  /// `Sessions This Month`
  String get sessionsThisMonth {
    return Intl.message(
      'Sessions This Month',
      name: 'sessionsThisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Reward Points`
  String get rewardPoints {
    return Intl.message(
      'Reward Points',
      name: 'rewardPoints',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paymentCompleted {
    return Intl.message('Paid', name: 'paymentCompleted', desc: '', args: []);
  }

  /// `Under Processing`
  String get underProcessing {
    return Intl.message(
      'Under Processing',
      name: 'underProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pendingWaiting {
    return Intl.message('Pending', name: 'pendingWaiting', desc: '', args: []);
  }

  /// `Sessions`
  String get sessions {
    return Intl.message('Sessions', name: 'sessions', desc: '', args: []);
  }

  /// `Total Sessions`
  String get totalSessions {
    return Intl.message(
      'Total Sessions',
      name: 'totalSessions',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get rewards {
    return Intl.message('Rewards', name: 'rewards', desc: '', args: []);
  }

  /// `Deductions`
  String get discounts {
    return Intl.message('Deductions', name: 'discounts', desc: '', args: []);
  }

  /// `Net Amount`
  String get netAmount {
    return Intl.message('Net Amount', name: 'netAmount', desc: '', args: []);
  }

  /// `Paid On`
  String get paymentDoneOn {
    return Intl.message('Paid On', name: 'paymentDoneOn', desc: '', args: []);
  }

  /// `Salary Calculation Method`
  String get salaryCalculationMethod {
    return Intl.message(
      'Salary Calculation Method',
      name: 'salaryCalculationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Number of Sessions * Session Price`
  String get salaryCalculationFormula {
    return Intl.message(
      'Number of Sessions * Session Price',
      name: 'salaryCalculationFormula',
      desc: '',
      args: [],
    );
  }

  /// `Base salary is calculated`
  String get salaryCalculationFormulaDesc {
    return Intl.message(
      'Base salary is calculated',
      name: 'salaryCalculationFormulaDesc',
      desc: '',
      args: [],
    );
  }

  /// `Add Excellence Points`
  String get addRewardPointsTitle {
    return Intl.message(
      'Add Excellence Points',
      name: 'addRewardPointsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Rewards are calculated based on performance`
  String get addRewardPointsDesc {
    return Intl.message(
      'Rewards are calculated based on performance',
      name: 'addRewardPointsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Deduct Any Deductions`
  String get deductionsTitle {
    return Intl.message(
      'Deduct Any Deductions',
      name: 'deductionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Absence or lateness`
  String get deductionsDesc {
    return Intl.message(
      'Absence or lateness',
      name: 'deductionsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields.`
  String get fillAllRequiredFields {
    return Intl.message(
      'Please fill in all required fields.',
      name: 'fillAllRequiredFields',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `All grades`
  String get allGrades {
    return Intl.message('All grades', name: 'allGrades', desc: '', args: []);
  }

  /// `Delete assignment`
  String get deleteAssignment {
    return Intl.message(
      'Delete assignment',
      name: 'deleteAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this assignment?`
  String get deleteAssignmentConfirmation {
    return Intl.message(
      'Are you sure you want to delete this assignment?',
      name: 'deleteAssignmentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `My Performance`
  String get myPerformance {
    return Intl.message(
      'My Performance',
      name: 'myPerformance',
      desc: '',
      args: [],
    );
  }

  /// `Lessons`
  String get lessons {
    return Intl.message('Lessons', name: 'lessons', desc: '', args: []);
  }

  /// `Absence`
  String get absence {
    return Intl.message('Absence', name: 'absence', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Point`
  String get point {
    return Intl.message('Point', name: 'point', desc: '', args: []);
  }

  /// `Last 6 Months`
  String get lastSixMonths {
    return Intl.message(
      'Last 6 Months',
      name: 'lastSixMonths',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get classesCount {
    return Intl.message('Classes', name: 'classesCount', desc: '', args: []);
  }

  /// `Latest Earned Points`
  String get latestEarnedPoints {
    return Intl.message(
      'Latest Earned Points',
      name: 'latestEarnedPoints',
      desc: '',
      args: [],
    );
  }

  /// `Tip to Increase Points`
  String get tipToIncreasePoints {
    return Intl.message(
      'Tip to Increase Points',
      name: 'tipToIncreasePoints',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to submit weekly evaluations on time to earn 20 extra points weekly`
  String get pointsTipDescription {
    return Intl.message(
      'Make sure to submit weekly evaluations on time to earn 20 extra points weekly',
      name: 'pointsTipDescription',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Salary`
  String get salary {
    return Intl.message('Salary', name: 'salary', desc: '', args: []);
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `Ranking`
  String get ranking {
    return Intl.message('Ranking', name: 'ranking', desc: '', args: []);
  }

  /// `Weekly Ideal Student`
  String get weeklyIdealStudent {
    return Intl.message(
      'Weekly Ideal Student',
      name: 'weeklyIdealStudent',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Ideal Students Ranking`
  String get weeklyIdealStudentsRanking {
    return Intl.message(
      'Weekly Ideal Students Ranking',
      name: 'weeklyIdealStudentsRanking',
      desc: '',
      args: [],
    );
  }

  /// `Ideal Teacher`
  String get idealTeacher {
    return Intl.message(
      'Ideal Teacher',
      name: 'idealTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Select the ideal teacher`
  String get selectIdealTeacher {
    return Intl.message(
      'Select the ideal teacher',
      name: 'selectIdealTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Issue Certificate`
  String get issueCertificate {
    return Intl.message(
      'Issue Certificate',
      name: 'issueCertificate',
      desc: '',
      args: [],
    );
  }

  /// `No teachers are available`
  String get noTeachersAvailable {
    return Intl.message(
      'No teachers are available',
      name: 'noTeachersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Ideal teacher certificate issued successfully`
  String get idealTeacherIssuedSuccessfully {
    return Intl.message(
      'Ideal teacher certificate issued successfully',
      name: 'idealTeacherIssuedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Ideal Teacher Certificate`
  String get idealTeacherCertificate {
    return Intl.message(
      'Ideal Teacher Certificate',
      name: 'idealTeacherCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Student Certificates`
  String get studentCertificates {
    return Intl.message(
      'Student Certificates',
      name: 'studentCertificates',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Certificates`
  String get teacherCertificates {
    return Intl.message(
      'Teacher Certificates',
      name: 'teacherCertificates',
      desc: '',
      args: [],
    );
  }

  /// `Certificate of Appreciation`
  String get generalTeacherCertificate {
    return Intl.message(
      'Certificate of Appreciation',
      name: 'generalTeacherCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Teacher certificate issued successfully`
  String get teacherCertificateIssuedSuccessfully {
    return Intl.message(
      'Teacher certificate issued successfully',
      name: 'teacherCertificateIssuedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Ideal Supervisor`
  String get idealSupervisor {
    return Intl.message(
      'Ideal Supervisor',
      name: 'idealSupervisor',
      desc: '',
      args: [],
    );
  }

  /// `Select the ideal supervisor`
  String get selectIdealSupervisor {
    return Intl.message(
      'Select the ideal supervisor',
      name: 'selectIdealSupervisor',
      desc: '',
      args: [],
    );
  }

  /// `Ideal supervisor certificate issued successfully`
  String get idealSupervisorIssuedSuccessfully {
    return Intl.message(
      'Ideal supervisor certificate issued successfully',
      name: 'idealSupervisorIssuedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Ideal Supervisor Certificate`
  String get idealSupervisorCertificate {
    return Intl.message(
      'Ideal Supervisor Certificate',
      name: 'idealSupervisorCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one valid supervisor`
  String get invalidIdealSupervisorSelection {
    return Intl.message(
      'Select at least one valid supervisor',
      name: 'invalidIdealSupervisorSelection',
      desc: '',
      args: [],
    );
  }

  /// `The selected supervisor no longer exists`
  String get supervisorNotFound {
    return Intl.message(
      'The selected supervisor no longer exists',
      name: 'supervisorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `The selected account is not a supervisor`
  String get invalidCertificateRecipient {
    return Intl.message(
      'The selected account is not a supervisor',
      name: 'invalidCertificateRecipient',
      desc: '',
      args: [],
    );
  }

  /// `The selected supervisor is not active`
  String get supervisorNotActive {
    return Intl.message(
      'The selected supervisor is not active',
      name: 'supervisorNotActive',
      desc: '',
      args: [],
    );
  }

  /// `An ideal supervisor certificate was already issued this month`
  String get idealSupervisorCertificateAlreadyExists {
    return Intl.message(
      'An ideal supervisor certificate was already issued this month',
      name: 'idealSupervisorCertificateAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Evaluations`
  String get weeklyEvaluations {
    return Intl.message(
      'Weekly Evaluations',
      name: 'weeklyEvaluations',
      desc: '',
      args: [],
    );
  }

  /// `Add New Evaluation`
  String get addNewEvaluation {
    return Intl.message(
      'Add New Evaluation',
      name: 'addNewEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `New Weekly Evaluation`
  String get newWeeklyEvaluation {
    return Intl.message(
      'New Weekly Evaluation',
      name: 'newWeeklyEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Edit Evaluation`
  String get editEvaluation {
    return Intl.message(
      'Edit Evaluation',
      name: 'editEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Week Start`
  String get weekStart {
    return Intl.message('Week Start', name: 'weekStart', desc: '', args: []);
  }

  /// `Behavior`
  String get behavior {
    return Intl.message('Behavior', name: 'behavior', desc: '', args: []);
  }

  /// `Notes`
  String get notesText {
    return Intl.message('Notes', name: 'notesText', desc: '', args: []);
  }

  /// `Class Schedules Management`
  String get classSchedulesManagement {
    return Intl.message(
      'Class Schedules Management',
      name: 'classSchedulesManagement',
      desc: '',
      args: [],
    );
  }

  /// `Add New Schedule`
  String get addNewSchedule {
    return Intl.message(
      'Add New Schedule',
      name: 'addNewSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Upload Schedule`
  String get uploadSchedule {
    return Intl.message(
      'Upload Schedule',
      name: 'uploadSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Schedule added successfully`
  String get scheduleCreatedSuccessfully {
    return Intl.message(
      'Schedule added successfully',
      name: 'scheduleCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Choose schedule image`
  String get chooseScheduleImage {
    return Intl.message(
      'Choose schedule image',
      name: 'chooseScheduleImage',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a schedule image`
  String get scheduleImageRequired {
    return Intl.message(
      'Please choose a schedule image',
      name: 'scheduleImageRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please select a classroom`
  String get classroomRequired {
    return Intl.message(
      'Please select a classroom',
      name: 'classroomRequired',
      desc: '',
      args: [],
    );
  }

  /// `Delete schedule`
  String get deleteSchedule {
    return Intl.message(
      'Delete schedule',
      name: 'deleteSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this schedule?`
  String get deleteScheduleConfirmation {
    return Intl.message(
      'Are you sure you want to delete this schedule?',
      name: 'deleteScheduleConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Schedule deleted successfully`
  String get scheduleDeletedSuccessfully {
    return Intl.message(
      'Schedule deleted successfully',
      name: 'scheduleDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get parentHomeTitle {
    return Intl.message('Home', name: 'parentHomeTitle', desc: '', args: []);
  }

  /// `Welcome`
  String get parentWelcome {
    return Intl.message('Welcome', name: 'parentWelcome', desc: '', args: []);
  }

  /// `Parent`
  String get parentGuardian {
    return Intl.message('Parent', name: 'parentGuardian', desc: '', args: []);
  }

  /// `Children`
  String get parentChildren {
    return Intl.message('Children', name: 'parentChildren', desc: '', args: []);
  }

  /// `Your Children`
  String get parentYourChildren {
    return Intl.message(
      'Your Children',
      name: 'parentYourChildren',
      desc: '',
      args: [],
    );
  }

  /// `Evaluations`
  String get parentEvaluations {
    return Intl.message(
      'Evaluations',
      name: 'parentEvaluations',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get parentSchedule {
    return Intl.message('Schedule', name: 'parentSchedule', desc: '', args: []);
  }

  /// `Certificates`
  String get parentCertificates {
    return Intl.message(
      'Certificates',
      name: 'parentCertificates',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get parentNotifications {
    return Intl.message(
      'Notifications',
      name: 'parentNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get parentSubscription {
    return Intl.message(
      'Subscription',
      name: 'parentSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get parentSubscriptions {
    return Intl.message(
      'Subscriptions',
      name: 'parentSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Children subscriptions`
  String get childrenSubscriptions {
    return Intl.message(
      'Children subscriptions',
      name: 'childrenSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Packages and Subscription`
  String get parentPackagesAndSubscription {
    return Intl.message(
      'Packages and Subscription',
      name: 'parentPackagesAndSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get parentMessages {
    return Intl.message('Messages', name: 'parentMessages', desc: '', args: []);
  }

  /// `Daily Plans`
  String get parentDailyPlans {
    return Intl.message(
      'Daily Plans',
      name: 'parentDailyPlans',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get parentAccount {
    return Intl.message(
      'My Account',
      name: 'parentAccount',
      desc: '',
      args: [],
    );
  }

  /// `Renew`
  String get parentRenew {
    return Intl.message('Renew', name: 'parentRenew', desc: '', args: []);
  }

  /// `Show All`
  String get parentShowAll {
    return Intl.message('Show All', name: 'parentShowAll', desc: '', args: []);
  }

  /// `Laila's subscription will end in 5 days`
  String get parentSubscriptionEndsSoon {
    return Intl.message(
      'Laila\'s subscription will end in 5 days',
      name: 'parentSubscriptionEndsSoon',
      desc: '',
      args: [],
    );
  }

  /// `Renew it now to avoid suspension`
  String get parentSubscriptionRenewHint {
    return Intl.message(
      'Renew it now to avoid suspension',
      name: 'parentSubscriptionRenewHint',
      desc: '',
      args: [],
    );
  }

  /// `First Preparatory Grade`
  String get parentFirstPreparatoryGrade {
    return Intl.message(
      'First Preparatory Grade',
      name: 'parentFirstPreparatoryGrade',
      desc: '',
      args: [],
    );
  }

  /// `Second Preparatory Grade`
  String get parentSecondPreparatoryGrade {
    return Intl.message(
      'Second Preparatory Grade',
      name: 'parentSecondPreparatoryGrade',
      desc: '',
      args: [],
    );
  }

  /// `teacher`
  String get teacher {
    return Intl.message('teacher', name: 'teacher', desc: '', args: []);
  }

  /// `Admin`
  String get admin {
    return Intl.message('Admin', name: 'admin', desc: '', args: []);
  }

  /// `Monthly Revenue`
  String get monthlyRevenue {
    return Intl.message(
      'Monthly Revenue',
      name: 'monthlyRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Register Requests Pending`
  String get pendingRegisterRequests {
    return Intl.message(
      'Register Requests Pending',
      name: 'pendingRegisterRequests',
      desc: '',
      args: [],
    );
  }

  /// `Total Students`
  String get totalStudents {
    return Intl.message(
      'Total Students',
      name: 'totalStudents',
      desc: '',
      args: [],
    );
  }

  /// `Today's Classes`
  String get todayClasses {
    return Intl.message(
      'Today\'s Classes',
      name: 'todayClasses',
      desc: '',
      args: [],
    );
  }

  /// `Active Subscriptions`
  String get activeSubscriptions {
    return Intl.message(
      'Active Subscriptions',
      name: 'activeSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Teachers`
  String get teachers {
    return Intl.message('Teachers', name: 'teachers', desc: '', args: []);
  }

  /// `Daily Profits`
  String get dailyProfits {
    return Intl.message(
      'Daily Profits',
      name: 'dailyProfits',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Profits`
  String get monthlyProfits {
    return Intl.message(
      'Monthly Profits',
      name: 'monthlyProfits',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get egpShort {
    return Intl.message('EGP', name: 'egpShort', desc: '', args: []);
  }

  /// `Revenues`
  String get revenues {
    return Intl.message('Revenues', name: 'revenues', desc: '', args: []);
  }

  /// `Expenses`
  String get expenses {
    return Intl.message('Expenses', name: 'expenses', desc: '', args: []);
  }

  /// `Net`
  String get net {
    return Intl.message('Net', name: 'net', desc: '', args: []);
  }

  /// `Egyptian Pound`
  String get egyptianPound {
    return Intl.message(
      'Egyptian Pound',
      name: 'egyptianPound',
      desc: '',
      args: [],
    );
  }

  /// `Saudi Riyal`
  String get saudiRiyal {
    return Intl.message('Saudi Riyal', name: 'saudiRiyal', desc: '', args: []);
  }

  /// `Egyptian Department`
  String get egyptianDepartment {
    return Intl.message(
      'Egyptian Department',
      name: 'egyptianDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Saudi Department`
  String get saudiDepartment {
    return Intl.message(
      'Saudi Department',
      name: 'saudiDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Pending Payments`
  String get pendingPayments {
    return Intl.message(
      'Pending Payments',
      name: 'pendingPayments',
      desc: '',
      args: [],
    );
  }

  /// `Review paid requests`
  String get reviewPaidRequests {
    return Intl.message(
      'Review paid requests',
      name: 'reviewPaidRequests',
      desc: '',
      args: [],
    );
  }

  /// `Review new students`
  String get reviewNewStudents {
    return Intl.message(
      'Review new students',
      name: 'reviewNewStudents',
      desc: '',
      args: [],
    );
  }

  /// `Manage classes and students`
  String get manageStudentsAndClasses {
    return Intl.message(
      'Manage classes and students',
      name: 'manageStudentsAndClasses',
      desc: '',
      args: [],
    );
  }

  /// `Users Management`
  String get usersManagement {
    return Intl.message(
      'Users Management',
      name: 'usersManagement',
      desc: '',
      args: [],
    );
  }

  /// `Hire Teachers`
  String get hireTeachers {
    return Intl.message(
      'Hire Teachers',
      name: 'hireTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Applications`
  String get teacherApplications {
    return Intl.message(
      'Teacher Applications',
      name: 'teacherApplications',
      desc: '',
      args: [],
    );
  }

  /// `Materials Management`
  String get materialsManagement {
    return Intl.message(
      'Materials Management',
      name: 'materialsManagement',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Students By Department`
  String get studentsByDepartment {
    return Intl.message(
      'Students By Department',
      name: 'studentsByDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Pending Receipts`
  String get pendingReceipts {
    return Intl.message(
      'Pending Receipts',
      name: 'pendingReceipts',
      desc: '',
      args: [],
    );
  }

  /// `Expired Subscriptions`
  String get expiredSubscriptions {
    return Intl.message(
      'Expired Subscriptions',
      name: 'expiredSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get adminUsers {
    return Intl.message('Users', name: 'adminUsers', desc: '', args: []);
  }

  /// `Supervisors`
  String get adminSupervisors {
    return Intl.message(
      'Supervisors',
      name: 'adminSupervisors',
      desc: '',
      args: [],
    );
  }

  /// `{count} users`
  String usersCount(Object count) {
    return Intl.message(
      '$count users',
      name: 'usersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Add User`
  String get addUser {
    return Intl.message('Add User', name: 'addUser', desc: '', args: []);
  }

  /// `Search by name or phone`
  String get searchByNameOrPhone {
    return Intl.message(
      'Search by name or phone',
      name: 'searchByNameOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `User Details`
  String get userDetails {
    return Intl.message(
      'User Details',
      name: 'userDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add New User`
  String get addNewUser {
    return Intl.message('Add New User', name: 'addNewUser', desc: '', args: []);
  }

  /// `Edit Data`
  String get editData {
    return Intl.message('Edit Data', name: 'editData', desc: '', args: []);
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Final Delete User`
  String get finalDeleteUser {
    return Intl.message(
      'Final Delete User',
      name: 'finalDeleteUser',
      desc: '',
      args: [],
    );
  }

  /// `User Role`
  String get userRole {
    return Intl.message('User Role', name: 'userRole', desc: '', args: []);
  }

  /// `Registration Date`
  String get registrationDate {
    return Intl.message(
      'Registration Date',
      name: 'registrationDate',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get parent {
    return Intl.message('Parent', name: 'parent', desc: '', args: []);
  }

  /// `Relationships`
  String get relationships {
    return Intl.message(
      'Relationships',
      name: 'relationships',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message('Role', name: 'role', desc: '', args: []);
  }

  /// `Parent`
  String get parentRole {
    return Intl.message('Parent', name: 'parentRole', desc: '', args: []);
  }

  /// `Supervisor`
  String get supervisor {
    return Intl.message('Supervisor', name: 'supervisor', desc: '', args: []);
  }

  /// `Supervised classes`
  String get supervisedClasses {
    return Intl.message(
      'Supervised classes',
      name: 'supervisedClasses',
      desc: '',
      args: [],
    );
  }

  /// `The SuperVisor`
  String get theSupervisor {
    return Intl.message(
      'The SuperVisor',
      name: 'theSupervisor',
      desc: '',
      args: [],
    );
  }

  /// `At least 6 characters`
  String get atLeastSixChars {
    return Intl.message(
      'At least 6 characters',
      name: 'atLeastSixChars',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Disable`
  String get disable {
    return Intl.message('Disable', name: 'disable', desc: '', args: []);
  }

  /// `Disable account`
  String get disableAccount {
    return Intl.message(
      'Disable account',
      name: 'disableAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enable account`
  String get enableAccount {
    return Intl.message(
      'Enable account',
      name: 'enableAccount',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to disable this account?`
  String get disableAccountConfirmation {
    return Intl.message(
      'Do you want to disable this account?',
      name: 'disableAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to enable this account?`
  String get enableAccountConfirmation {
    return Intl.message(
      'Do you want to enable this account?',
      name: 'enableAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Final Delete`
  String get finalDelete {
    return Intl.message(
      'Final Delete',
      name: 'finalDelete',
      desc: '',
      args: [],
    );
  }

  /// `Permanently delete from system`
  String get permanentlyDeleteFromSystem {
    return Intl.message(
      'Permanently delete from system',
      name: 'permanentlyDeleteFromSystem',
      desc: '',
      args: [],
    );
  }

  /// `This account will be permanently deleted from the system, including its login account and related profile data. This action cannot be undone.`
  String get finalDeleteDescription {
    return Intl.message(
      'This account will be permanently deleted from the system, including its login account and related profile data. This action cannot be undone.',
      name: 'finalDeleteDescription',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to disable {name}'s account?`
  String disableUserQuestion(Object name) {
    return Intl.message(
      'Do you want to disable $name\'s account?',
      name: 'disableUserQuestion',
      desc: '',
      args: [name],
    );
  }

  /// `They will not be able to log in until you reactivate them.`
  String get disableUserDescription {
    return Intl.message(
      'They will not be able to log in until you reactivate them.',
      name: 'disableUserDescription',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get notAvailable {
    return Intl.message(
      'Not available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Assign to Subject`
  String get assignSubject {
    return Intl.message(
      'Assign to Subject',
      name: 'assignSubject',
      desc: '',
      args: [],
    );
  }

  /// `Assign {teacherName} to Subject`
  String assignTeacherInSubject(Object teacherName) {
    return Intl.message(
      'Assign $teacherName to Subject',
      name: 'assignTeacherInSubject',
      desc: '',
      args: [teacherName],
    );
  }

  /// `Teacher assigned successfully`
  String get teacherAssignedSuccessfully {
    return Intl.message(
      'Teacher assigned successfully',
      name: 'teacherAssignedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Rate (SAR)`
  String get hourlyRate {
    return Intl.message(
      'Hourly Rate (SAR)',
      name: 'hourlyRate',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Assignment`
  String get cancelAssignment {
    return Intl.message(
      'Cancel Assignment',
      name: 'cancelAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel assigning this teacher to {gradeName} - {subjectName}?`
  String cancelAssignmentMessage(Object gradeName, Object subjectName) {
    return Intl.message(
      'Do you want to cancel assigning this teacher to $gradeName - $subjectName?',
      name: 'cancelAssignmentMessage',
      desc: '',
      args: [gradeName, subjectName],
    );
  }

  /// `Do you want to remove this teacher from {classroomName}?`
  String cancelTeacherAssignmentQuestion(Object classroomName) {
    return Intl.message(
      'Do you want to remove this teacher from $classroomName?',
      name: 'cancelTeacherAssignmentQuestion',
      desc: '',
      args: [classroomName],
    );
  }

  /// `Teacher assignment removed successfully`
  String get teacherUnassignedSuccessfully {
    return Intl.message(
      'Teacher assignment removed successfully',
      name: 'teacherUnassignedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum is required`
  String get curriculumRequired {
    return Intl.message(
      'Curriculum is required',
      name: 'curriculumRequired',
      desc: '',
      args: [],
    );
  }

  /// `Subject is required`
  String get subjectRequired {
    return Intl.message(
      'Subject is required',
      name: 'subjectRequired',
      desc: '',
      args: [],
    );
  }

  /// `Hourly rate is required`
  String get hourlyRateRequired {
    return Intl.message(
      'Hourly rate is required',
      name: 'hourlyRateRequired',
      desc: '',
      args: [],
    );
  }

  /// `Hourly rate must be a number`
  String get hourlyRateMustBeNumber {
    return Intl.message(
      'Hourly rate must be a number',
      name: 'hourlyRateMustBeNumber',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor Assignment`
  String get supervisorAssignment {
    return Intl.message(
      'Supervisor Assignment',
      name: 'supervisorAssignment',
      desc: '',
      args: [],
    );
  }

  /// `Assign to classroom`
  String get assignToClassroom {
    return Intl.message(
      'Assign to classroom',
      name: 'assignToClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Assign {name} to a classroom`
  String assignSupervisorToClassroom(Object name) {
    return Intl.message(
      'Assign $name to a classroom',
      name: 'assignSupervisorToClassroom',
      desc: '',
      args: [name],
    );
  }

  /// `Classrooms`
  String get classrooms {
    return Intl.message('Classrooms', name: 'classrooms', desc: '', args: []);
  }

  /// `Choose a classroom`
  String get chooseClassroom {
    return Intl.message(
      'Choose a classroom',
      name: 'chooseClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to remove this supervisor from {classroomName}?`
  String cancelSupervisorAssignmentQuestion(Object classroomName) {
    return Intl.message(
      'Do you want to remove this supervisor from $classroomName?',
      name: 'cancelSupervisorAssignmentQuestion',
      desc: '',
      args: [classroomName],
    );
  }

  /// `No supervisors found`
  String get noSupervisorsFound {
    return Intl.message(
      'No supervisors found',
      name: 'noSupervisorsFound',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor assigned successfully`
  String get assignmentAddedSuccessfully {
    return Intl.message(
      'Supervisor assigned successfully',
      name: 'assignmentAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor assignment removed successfully`
  String get assignmentRemovedSuccessfully {
    return Intl.message(
      'Supervisor assignment removed successfully',
      name: 'assignmentRemovedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Sara Ahmed`
  String get supervisorSaraAhmed {
    return Intl.message(
      'Sara Ahmed',
      name: 'supervisorSaraAhmed',
      desc: '',
      args: [],
    );
  }

  /// `Somaya`
  String get supervisorSomaya {
    return Intl.message('Somaya', name: 'supervisorSomaya', desc: '', args: []);
  }

  /// `Abdelfattah`
  String get supervisorAbdelfattah {
    return Intl.message(
      'Abdelfattah',
      name: 'supervisorAbdelfattah',
      desc: '',
      args: [],
    );
  }

  /// `Fourth primary grade`
  String get fourthPrimaryClassroom {
    return Intl.message(
      'Fourth primary grade',
      name: 'fourthPrimaryClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Second secondary grade`
  String get secondSecondaryClassroom {
    return Intl.message(
      'Second secondary grade',
      name: 'secondSecondaryClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian`
  String get egyptian {
    return Intl.message('Egyptian', name: 'egyptian', desc: '', args: []);
  }

  /// `Saudi`
  String get saudi {
    return Intl.message('Saudi', name: 'saudi', desc: '', args: []);
  }

  /// `Add New Chapter`
  String get addNewChapter {
    return Intl.message(
      'Add New Chapter',
      name: 'addNewChapter',
      desc: '',
      args: [],
    );
  }

  /// `Edit Class`
  String get editClass {
    return Intl.message('Edit Class', name: 'editClass', desc: '', args: []);
  }

  /// `Class Details`
  String get classDetails {
    return Intl.message(
      'Class Details',
      name: 'classDetails',
      desc: '',
      args: [],
    );
  }

  /// `Class Name`
  String get className {
    return Intl.message('Class Name', name: 'className', desc: '', args: []);
  }

  /// `Class name is required`
  String get classNameRequired {
    return Intl.message(
      'Class name is required',
      name: 'classNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Grade is required`
  String get gradeRequired {
    return Intl.message(
      'Grade is required',
      name: 'gradeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor is required`
  String get supervisorRequired {
    return Intl.message(
      'Supervisor is required',
      name: 'supervisorRequired',
      desc: '',
      args: [],
    );
  }

  /// `Subjects Management`
  String get subjectsManagement {
    return Intl.message(
      'Subjects Management',
      name: 'subjectsManagement',
      desc: '',
      args: [],
    );
  }

  /// `Add Subject`
  String get addSubject {
    return Intl.message('Add Subject', name: 'addSubject', desc: '', args: []);
  }

  /// `Subject added successfully`
  String get subjectCreatedSuccessfully {
    return Intl.message(
      'Subject added successfully',
      name: 'subjectCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add Subject to Classroom`
  String get addSubjectToClassroom {
    return Intl.message(
      'Add Subject to Classroom',
      name: 'addSubjectToClassroom',
      desc: '',
      args: [],
    );
  }

  /// `All grade subjects have already been added to this classroom`
  String get allGradeSubjectsAddedToClassroom {
    return Intl.message(
      'All grade subjects have already been added to this classroom',
      name: 'allGradeSubjectsAddedToClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Add New Subject`
  String get addNewSubject {
    return Intl.message(
      'Add New Subject',
      name: 'addNewSubject',
      desc: '',
      args: [],
    );
  }

  /// `Edit Subject`
  String get editSubject {
    return Intl.message(
      'Edit Subject',
      name: 'editSubject',
      desc: '',
      args: [],
    );
  }

  /// `Subject Name`
  String get subjectName {
    return Intl.message(
      'Subject Name',
      name: 'subjectName',
      desc: '',
      args: [],
    );
  }

  /// `Attached File`
  String get attachedFile {
    return Intl.message(
      'Attached File',
      name: 'attachedFile',
      desc: '',
      args: [],
    );
  }

  /// `Select subject`
  String get selectSubject {
    return Intl.message(
      'Select subject',
      name: 'selectSubject',
      desc: '',
      args: [],
    );
  }

  /// `Select File`
  String get selectFile {
    return Intl.message('Select File', name: 'selectFile', desc: '', args: []);
  }

  /// `Pending Review`
  String get pendingReview {
    return Intl.message(
      'Pending Review',
      name: 'pendingReview',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `CV`
  String get cv {
    return Intl.message('CV', name: 'cv', desc: '', args: []);
  }

  /// `Experience`
  String get experience {
    return Intl.message('Experience', name: 'experience', desc: '', args: []);
  }

  /// `Years`
  String get years {
    return Intl.message('Years', name: 'years', desc: '', args: []);
  }

  /// `New Customer`
  String get newCustomer {
    return Intl.message(
      'New Customer',
      name: 'newCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Children`
  String get children {
    return Intl.message('Children', name: 'children', desc: '', args: []);
  }

  /// `Classes`
  String get classLabel {
    return Intl.message('Classes', name: 'classLabel', desc: '', args: []);
  }

  /// `Subject`
  String get subjectLabel {
    return Intl.message('Subject', name: 'subjectLabel', desc: '', args: []);
  }

  /// `Payment Status`
  String get paymentStatus {
    return Intl.message(
      'Payment Status',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Paid amount`
  String get paidAmount {
    return Intl.message('Paid amount', name: 'paidAmount', desc: '', args: []);
  }

  /// `Example: SAR 512`
  String get paidAmountHint {
    return Intl.message(
      'Example: SAR 512',
      name: 'paidAmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Payment methods`
  String get paymentMethods {
    return Intl.message(
      'Payment methods',
      name: 'paymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `InstaPay`
  String get instapay {
    return Intl.message('InstaPay', name: 'instapay', desc: '', args: []);
  }

  /// `Bank transfer`
  String get bankTransfer {
    return Intl.message(
      'Bank transfer',
      name: 'bankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Electronic wallet`
  String get wallet {
    return Intl.message(
      'Electronic wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Payment receipt`
  String get paymentReceipt {
    return Intl.message(
      'Payment receipt',
      name: 'paymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Upload receipt image`
  String get uploadPaymentReceipt {
    return Intl.message(
      'Upload receipt image',
      name: 'uploadPaymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Upload Receipt`
  String get uploadReceipt {
    return Intl.message(
      'Upload Receipt',
      name: 'uploadReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Payment confirmed successfully`
  String get paymentConfirmedSuccessfully {
    return Intl.message(
      'Payment confirmed successfully',
      name: 'paymentConfirmedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Account activated successfully`
  String get accountActivatedSuccessfully {
    return Intl.message(
      'Account activated successfully',
      name: 'accountActivatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Registration request rejected successfully`
  String get registrationRequestRejectedSuccessfully {
    return Intl.message(
      'Registration request rejected successfully',
      name: 'registrationRequestRejectedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open WhatsApp`
  String get unableToOpenWhatsApp {
    return Intl.message(
      'Unable to open WhatsApp',
      name: 'unableToOpenWhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for receipt review`
  String get waitingForReceiptReview {
    return Intl.message(
      'Waiting for receipt review',
      name: 'waitingForReceiptReview',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get activated {
    return Intl.message('Active', name: 'activated', desc: '', args: []);
  }

  /// `Inactive`
  String get notActivated {
    return Intl.message('Inactive', name: 'notActivated', desc: '', args: []);
  }

  /// `No active accounts found`
  String get noActiveAccountsFound {
    return Intl.message(
      'No active accounts found',
      name: 'noActiveAccountsFound',
      desc: '',
      args: [],
    );
  }

  /// `No inactive accounts found`
  String get noInactiveAccountsFound {
    return Intl.message(
      'No inactive accounts found',
      name: 'noInactiveAccountsFound',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open payment receipt`
  String get unableToOpenPaymentReceipt {
    return Intl.message(
      'Unable to open payment receipt',
      name: 'unableToOpenPaymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Lessons Management`
  String get lessonsManagement {
    return Intl.message(
      'Lessons Management',
      name: 'lessonsManagement',
      desc: '',
      args: [],
    );
  }

  /// `Add Lesson`
  String get addLesson {
    return Intl.message('Add Lesson', name: 'addLesson', desc: '', args: []);
  }

  /// `Edit Lesson`
  String get editLesson {
    return Intl.message('Edit Lesson', name: 'editLesson', desc: '', args: []);
  }

  /// `Lesson date`
  String get lessonDate {
    return Intl.message('Lesson date', name: 'lessonDate', desc: '', args: []);
  }

  /// `Start time`
  String get startTime {
    return Intl.message('Start time', name: 'startTime', desc: '', args: []);
  }

  /// `End time`
  String get endTime {
    return Intl.message('End time', name: 'endTime', desc: '', args: []);
  }

  /// `Lesson end time must be after start time`
  String get lessonEndTimeMustBeAfterStart {
    return Intl.message(
      'Lesson end time must be after start time',
      name: 'lessonEndTimeMustBeAfterStart',
      desc: '',
      args: [],
    );
  }

  /// `Week days`
  String get weekDays {
    return Intl.message('Week days', name: 'weekDays', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Thursday, 07 May 2026`
  String get selectedLessonDatePreview {
    return Intl.message(
      'Thursday, 07 May 2026',
      name: 'selectedLessonDatePreview',
      desc: '',
      args: [],
    );
  }

  /// `Empty lesson`
  String get emptyLesson {
    return Intl.message(
      'Empty lesson',
      name: 'emptyLesson',
      desc: '',
      args: [],
    );
  }

  /// `No lessons for the selected day`
  String get noLessonsForSelectedDay {
    return Intl.message(
      'No lessons for the selected day',
      name: 'noLessonsForSelectedDay',
      desc: '',
      args: [],
    );
  }

  /// `Schedule for {day}`
  String scheduleForDay(Object day) {
    return Intl.message(
      'Schedule for $day',
      name: 'scheduleForDay',
      desc: '',
      args: [day],
    );
  }

  /// `No schedule entries have been added for this classroom yet`
  String get noScheduleEntriesForClassroom {
    return Intl.message(
      'No schedule entries have been added for this classroom yet',
      name: 'noScheduleEntriesForClassroom',
      desc: '',
      args: [],
    );
  }

  /// `No lesson is scheduled for this day`
  String get noScheduledLessonForDay {
    return Intl.message(
      'No lesson is scheduled for this day',
      name: 'noScheduledLessonForDay',
      desc: '',
      args: [],
    );
  }

  /// `No Gulf classrooms are available`
  String get noGulfClassroomsAvailable {
    return Intl.message(
      'No Gulf classrooms are available',
      name: 'noGulfClassroomsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load the schedule`
  String get gulfScheduleLoadFailed {
    return Intl.message(
      'Failed to load the schedule',
      name: 'gulfScheduleLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Schedule entry added successfully`
  String get gulfScheduleEntryAdded {
    return Intl.message(
      'Schedule entry added successfully',
      name: 'gulfScheduleEntryAdded',
      desc: '',
      args: [],
    );
  }

  /// `Schedule entry updated successfully`
  String get gulfScheduleEntryUpdated {
    return Intl.message(
      'Schedule entry updated successfully',
      name: 'gulfScheduleEntryUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Schedule entry deleted successfully`
  String get gulfScheduleEntryDeleted {
    return Intl.message(
      'Schedule entry deleted successfully',
      name: 'gulfScheduleEntryDeleted',
      desc: '',
      args: [],
    );
  }

  /// `The classroom subject data needs to be reviewed by the administration.`
  String get gulfClassroomSubjectUnavailable {
    return Intl.message(
      'The classroom subject data needs to be reviewed by the administration.',
      name: 'gulfClassroomSubjectUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Start lesson`
  String get startSession {
    return Intl.message(
      'Start lesson',
      name: 'startSession',
      desc: '',
      args: [],
    );
  }

  /// `Join lesson`
  String get joinSession {
    return Intl.message('Join lesson', name: 'joinSession', desc: '', args: []);
  }

  /// `End lesson`
  String get endSession {
    return Intl.message('End lesson', name: 'endSession', desc: '', args: []);
  }

  /// `Ending lesson`
  String get sessionEnding {
    return Intl.message(
      'Ending lesson',
      name: 'sessionEnding',
      desc: '',
      args: [],
    );
  }

  /// `There is no live lesson now`
  String get noActiveSessionNow {
    return Intl.message(
      'There is no live lesson now',
      name: 'noActiveSessionNow',
      desc: '',
      args: [],
    );
  }

  /// `Starting lesson`
  String get sessionStarting {
    return Intl.message(
      'Starting lesson',
      name: 'sessionStarting',
      desc: '',
      args: [],
    );
  }

  /// `Lesson started`
  String get sessionStarted {
    return Intl.message(
      'Lesson started',
      name: 'sessionStarted',
      desc: '',
      args: [],
    );
  }

  /// `Open lesson link`
  String get openSessionLink {
    return Intl.message(
      'Open lesson link',
      name: 'openSessionLink',
      desc: '',
      args: [],
    );
  }

  /// `The lesson started, but its link could not be opened`
  String get sessionStartedLinkOpenFailed {
    return Intl.message(
      'The lesson started, but its link could not be opened',
      name: 'sessionStartedLinkOpenFailed',
      desc: '',
      args: [],
    );
  }

  /// `Subject data is unavailable`
  String get sessionSubjectUnavailable {
    return Intl.message(
      'Subject data is unavailable',
      name: 'sessionSubjectUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Zoom setup is incomplete for this classroom`
  String get classroomZoomNotConfigured {
    return Intl.message(
      'Zoom setup is incomplete for this classroom',
      name: 'classroomZoomNotConfigured',
      desc: '',
      args: [],
    );
  }

  /// `Another lesson is already active for this classroom`
  String get classroomSessionAlreadyActive {
    return Intl.message(
      'Another lesson is already active for this classroom',
      name: 'classroomSessionAlreadyActive',
      desc: '',
      args: [],
    );
  }

  /// `No teacher is assigned to this subject`
  String get teacherNotAssignedToSessionSubject {
    return Intl.message(
      'No teacher is assigned to this subject',
      name: 'teacherNotAssignedToSessionSubject',
      desc: '',
      args: [],
    );
  }

  /// `You are not authorized to start this lesson`
  String get sessionStartUnauthorized {
    return Intl.message(
      'You are not authorized to start this lesson',
      name: 'sessionStartUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Add schedule entry`
  String get addScheduleEntry {
    return Intl.message(
      'Add schedule entry',
      name: 'addScheduleEntry',
      desc: '',
      args: [],
    );
  }

  /// `Edit schedule entry`
  String get editScheduleEntry {
    return Intl.message(
      'Edit schedule entry',
      name: 'editScheduleEntry',
      desc: '',
      args: [],
    );
  }

  /// `Only one schedule entry can be added for the same day`
  String get duplicateScheduleDay {
    return Intl.message(
      'Only one schedule entry can be added for the same day',
      name: 'duplicateScheduleDay',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid amount of at least 0.01`
  String get invalidPaymentAmount {
    return Intl.message(
      'Enter a valid amount of at least 0.01',
      name: 'invalidPaymentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipt image is required`
  String get paymentReceiptRequired {
    return Intl.message(
      'Payment receipt image is required',
      name: 'paymentReceiptRequired',
      desc: '',
      args: [],
    );
  }

  /// `Pending manual receipt review`
  String get manualTransferReviewPending {
    return Intl.message(
      'Pending manual receipt review',
      name: 'manualTransferReviewPending',
      desc: '',
      args: [],
    );
  }

  /// `Confirm manual payment`
  String get manualPaymentConfirmation {
    return Intl.message(
      'Confirm manual payment',
      name: 'manualPaymentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Move to review`
  String get moveToReview {
    return Intl.message(
      'Move to review',
      name: 'moveToReview',
      desc: '',
      args: [],
    );
  }

  /// `Contact via WhatsApp`
  String get contactWhatsApp {
    return Intl.message(
      'Contact via WhatsApp',
      name: 'contactWhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Approve account activation`
  String get approveAccountActivation {
    return Intl.message(
      'Approve account activation',
      name: 'approveAccountActivation',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Curriculums`
  String get curriculums {
    return Intl.message('Curriculums', name: 'curriculums', desc: '', args: []);
  }

  /// `Add New Curriculum`
  String get addNewCurriculum {
    return Intl.message(
      'Add New Curriculum',
      name: 'addNewCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum Name`
  String get curriculumName {
    return Intl.message(
      'Curriculum Name',
      name: 'curriculumName',
      desc: '',
      args: [],
    );
  }

  /// `Edit Curriculum`
  String get editCurriculum {
    return Intl.message(
      'Edit Curriculum',
      name: 'editCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum Description`
  String get curriculumDescription {
    return Intl.message(
      'Curriculum Description',
      name: 'curriculumDescription',
      desc: '',
      args: [],
    );
  }

  /// `Registration Mode`
  String get registrationMode {
    return Intl.message(
      'Registration Mode',
      name: 'registrationMode',
      desc: '',
      args: [],
    );
  }

  /// `Gulf Curriculum`
  String get gulfCurriculum {
    return Intl.message(
      'Gulf Curriculum',
      name: 'gulfCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Choose curriculum icon`
  String get chooseCurriculumIcon {
    return Intl.message(
      'Choose curriculum icon',
      name: 'chooseCurriculumIcon',
      desc: '',
      args: [],
    );
  }

  /// `No curriculums found`
  String get noCurriculumsFound {
    return Intl.message(
      'No curriculums found',
      name: 'noCurriculumsFound',
      desc: '',
      args: [],
    );
  }

  /// `Add New Grade`
  String get addNewGrade {
    return Intl.message(
      'Add New Grade',
      name: 'addNewGrade',
      desc: '',
      args: [],
    );
  }

  /// `Grade Name`
  String get gradeName {
    return Intl.message('Grade Name', name: 'gradeName', desc: '', args: []);
  }

  /// `Add New Semester`
  String get addNewSemester {
    return Intl.message(
      'Add New Semester',
      name: 'addNewSemester',
      desc: '',
      args: [],
    );
  }

  /// `Semester Name`
  String get semesterName {
    return Intl.message(
      'Semester Name',
      name: 'semesterName',
      desc: '',
      args: [],
    );
  }

  /// `{count} Grades`
  String gradesCount(Object count) {
    return Intl.message(
      '$count Grades',
      name: 'gradesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Semester 1`
  String get semesterOne {
    return Intl.message('Semester 1', name: 'semesterOne', desc: '', args: []);
  }

  /// `Semester 2`
  String get semesterTwo {
    return Intl.message('Semester 2', name: 'semesterTwo', desc: '', args: []);
  }

  /// `Semester 3`
  String get semesterThree {
    return Intl.message(
      'Semester 3',
      name: 'semesterThree',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get confirmDelete {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Delete grade`
  String get deleteGrade {
    return Intl.message(
      'Delete grade',
      name: 'deleteGrade',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this grade?`
  String get deleteGradeConfirmation {
    return Intl.message(
      'Are you sure you want to delete this grade?',
      name: 'deleteGradeConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Third Preparatory Grade`
  String get parentThirdPreparatoryGrade {
    return Intl.message(
      'Third Preparatory Grade',
      name: 'parentThirdPreparatoryGrade',
      desc: '',
      args: [],
    );
  }

  /// `ClassRoom Management`
  String get classRoomManagement {
    return Intl.message(
      'ClassRoom Management',
      name: 'classRoomManagement',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get languageArabic {
    return Intl.message('العربية', name: 'languageArabic', desc: '', args: []);
  }

  /// `English`
  String get languageEnglish {
    return Intl.message('English', name: 'languageEnglish', desc: '', args: []);
  }

  /// `No information available now`
  String get noDataAvailable {
    return Intl.message(
      'No information available now',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Send notification to parent and student`
  String get sendNotificationToParentAndStudent {
    return Intl.message(
      'Send notification to parent and student',
      name: 'sendNotificationToParentAndStudent',
      desc: '',
      args: [],
    );
  }

  /// `Send All`
  String get sendAll {
    return Intl.message('Send All', name: 'sendAll', desc: '', args: []);
  }

  /// `Certificates sent successfully`
  String get certificatesSentSuccessfully {
    return Intl.message(
      'Certificates sent successfully',
      name: 'certificatesSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Sending...`
  String get sending {
    return Intl.message('Sending...', name: 'sending', desc: '', args: []);
  }

  /// `Certificate deleted successfully`
  String get certificateDeletedSuccessfully {
    return Intl.message(
      'Certificate deleted successfully',
      name: 'certificateDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the file`
  String get unableToOpenFile {
    return Intl.message(
      'Unable to open the file',
      name: 'unableToOpenFile',
      desc: '',
      args: [],
    );
  }

  /// `Certificates`
  String get certificatesWithoutArticle {
    return Intl.message(
      'Certificates',
      name: 'certificatesWithoutArticle',
      desc: '',
      args: [],
    );
  }

  /// `There are no students in this classroom`
  String get noStudentsInClass {
    return Intl.message(
      'There are no students in this classroom',
      name: 'noStudentsInClass',
      desc: '',
      args: [],
    );
  }

  /// `Certificate added successfully`
  String get certificateAddedSuccessfully {
    return Intl.message(
      'Certificate added successfully',
      name: 'certificateAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please select a student`
  String get pleaseSelectStudent {
    return Intl.message(
      'Please select a student',
      name: 'pleaseSelectStudent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the subjects grades`
  String get pleaseEnterSubjectsGrades {
    return Intl.message(
      'Please enter the subjects grades',
      name: 'pleaseEnterSubjectsGrades',
      desc: '',
      args: [],
    );
  }

  /// `Certificate updated successfully`
  String get certificateUpdatedSuccessfully {
    return Intl.message(
      'Certificate updated successfully',
      name: 'certificateUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Assign Student`
  String get assignStudent {
    return Intl.message(
      'Assign Student',
      name: 'assignStudent',
      desc: '',
      args: [],
    );
  }

  /// `Loading students`
  String get loadingStudents {
    return Intl.message(
      'Loading students',
      name: 'loadingStudents',
      desc: '',
      args: [],
    );
  }

  /// `No unassigned students`
  String get noUnassignedStudents {
    return Intl.message(
      'No unassigned students',
      name: 'noUnassignedStudents',
      desc: '',
      args: [],
    );
  }

  /// `Classroom`
  String get classroom {
    return Intl.message('Classroom', name: 'classroom', desc: '', args: []);
  }

  /// `Select student first`
  String get selectStudentFirst {
    return Intl.message(
      'Select student first',
      name: 'selectStudentFirst',
      desc: '',
      args: [],
    );
  }

  /// `Loading classrooms`
  String get loadingClassrooms {
    return Intl.message(
      'Loading classrooms',
      name: 'loadingClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `No available classrooms`
  String get noAvailableClassrooms {
    return Intl.message(
      'No available classrooms',
      name: 'noAvailableClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `Select classroom`
  String get selectClassroom {
    return Intl.message(
      'Select classroom',
      name: 'selectClassroom',
      desc: '',
      args: [],
    );
  }

  /// `File downloaded successfully`
  String get fileDownloadedSuccessfully {
    return Intl.message(
      'File downloaded successfully',
      name: 'fileDownloadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Unable to download file`
  String get unableToDownloadFile {
    return Intl.message(
      'Unable to download file',
      name: 'unableToDownloadFile',
      desc: '',
      args: [],
    );
  }

  /// `Select classroom first`
  String get selectClassroomFirst {
    return Intl.message(
      'Select classroom first',
      name: 'selectClassroomFirst',
      desc: '',
      args: [],
    );
  }

  /// `No classrooms available`
  String get noClassroomsAvailable {
    return Intl.message(
      'No classrooms available',
      name: 'noClassroomsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No grades are available for this curriculum`
  String get noGradesAvailableForCurriculum {
    return Intl.message(
      'No grades are available for this curriculum',
      name: 'noGradesAvailableForCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `No classrooms are available for this grade`
  String get noClassroomsAvailableForGrade {
    return Intl.message(
      'No classrooms are available for this grade',
      name: 'noClassroomsAvailableForGrade',
      desc: '',
      args: [],
    );
  }

  /// `No subjects are available for this classroom`
  String get noSubjectsAvailableForClassroom {
    return Intl.message(
      'No subjects are available for this classroom',
      name: 'noSubjectsAvailableForClassroom',
      desc: '',
      args: [],
    );
  }

  /// `No assigned subjects for this classroom`
  String get noAssignedSubjectsForClassroom {
    return Intl.message(
      'No assigned subjects for this classroom',
      name: 'noAssignedSubjectsForClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Student assigned successfully`
  String get studentAssignedSuccessfully {
    return Intl.message(
      'Student assigned successfully',
      name: 'studentAssignedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Package Management`
  String get packagesManagement {
    return Intl.message(
      'Package Management',
      name: 'packagesManagement',
      desc: '',
      args: [],
    );
  }

  /// `Add New Package`
  String get addNewPackage {
    return Intl.message(
      'Add New Package',
      name: 'addNewPackage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Package`
  String get editPackage {
    return Intl.message(
      'Edit Package',
      name: 'editPackage',
      desc: '',
      args: [],
    );
  }

  /// `Add New Package`
  String get addNewPackageTitle {
    return Intl.message(
      'Add New Package',
      name: 'addNewPackageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Package Type`
  String get packageType {
    return Intl.message(
      'Package Type',
      name: 'packageType',
      desc: '',
      args: [],
    );
  }

  /// `Package Scope`
  String get packageAccessScope {
    return Intl.message(
      'Package Scope',
      name: 'packageAccessScope',
      desc: '',
      args: [],
    );
  }

  /// `All Subjects`
  String get allSubjects {
    return Intl.message(
      'All Subjects',
      name: 'allSubjects',
      desc: '',
      args: [],
    );
  }

  /// `Single Subject`
  String get singleSubject {
    return Intl.message(
      'Single Subject',
      name: 'singleSubject',
      desc: '',
      args: [],
    );
  }

  /// `Number of Hours`
  String get numberOfHours {
    return Intl.message(
      'Number of Hours',
      name: 'numberOfHours',
      desc: '',
      args: [],
    );
  }

  /// `Example: 12 hours`
  String get numberOfHoursHint {
    return Intl.message(
      'Example: 12 hours',
      name: 'numberOfHoursHint',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Package`
  String get monthlyPackage {
    return Intl.message(
      'Monthly Package',
      name: 'monthlyPackage',
      desc: '',
      args: [],
    );
  }

  /// `Package Duration`
  String get packageDuration {
    return Intl.message(
      'Package Duration',
      name: 'packageDuration',
      desc: '',
      args: [],
    );
  }

  /// `Example: 4-Hour Package`
  String get packageDurationHint {
    return Intl.message(
      'Example: 4-Hour Package',
      name: 'packageDurationHint',
      desc: '',
      args: [],
    );
  }

  /// `New Price`
  String get newPrice {
    return Intl.message('New Price', name: 'newPrice', desc: '', args: []);
  }

  /// `Discount Title`
  String get discountTitle {
    return Intl.message(
      'Discount Title',
      name: 'discountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Example: Save 120 SAR`
  String get discountTitleHint {
    return Intl.message(
      'Example: Save 120 SAR',
      name: 'discountTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Visible to Customers`
  String get visibleToCustomers {
    return Intl.message(
      'Visible to Customers',
      name: 'visibleToCustomers',
      desc: '',
      args: [],
    );
  }

  /// `Delete Package`
  String get deletePackage {
    return Intl.message(
      'Delete Package',
      name: 'deletePackage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this package?`
  String get deletePackageConfirmation {
    return Intl.message(
      'Are you sure you want to delete this package?',
      name: 'deletePackageConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `All Curriculms`
  String get allCurriculms {
    return Intl.message(
      'All Curriculms',
      name: 'allCurriculms',
      desc: '',
      args: [],
    );
  }

  /// `Package Name`
  String get packageName {
    return Intl.message(
      'Package Name',
      name: 'packageName',
      desc: '',
      args: [],
    );
  }

  /// `Package Name`
  String get packageFormName {
    return Intl.message(
      'Package Name',
      name: 'packageFormName',
      desc: '',
      args: [],
    );
  }

  /// `Hours Package`
  String get packageHoursType {
    return Intl.message(
      'Hours Package',
      name: 'packageHoursType',
      desc: '',
      args: [],
    );
  }

  /// `Old Price`
  String get packageOldPrice {
    return Intl.message(
      'Old Price',
      name: 'packageOldPrice',
      desc: '',
      args: [],
    );
  }

  /// `Package deleted successfully`
  String get packageDeletedSuccessfully {
    return Intl.message(
      'Package deleted successfully',
      name: 'packageDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Package added successfully`
  String get packageCreatedSuccessfully {
    return Intl.message(
      'Package added successfully',
      name: 'packageCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Package updated successfully`
  String get packageUpdatedSuccessfully {
    return Intl.message(
      'Package updated successfully',
      name: 'packageUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please select a curriculum`
  String get selectCurriculumFirst {
    return Intl.message(
      'Please select a curriculum',
      name: 'selectCurriculumFirst',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the package name`
  String get packageNameRequired {
    return Intl.message(
      'Please enter the package name',
      name: 'packageNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid package duration`
  String get packageDurationInvalid {
    return Intl.message(
      'Please enter a valid package duration',
      name: 'packageDurationInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid old price`
  String get oldPriceInvalid {
    return Intl.message(
      'Please enter a valid old price',
      name: 'oldPriceInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid new price`
  String get newPriceInvalid {
    return Intl.message(
      'Please enter a valid new price',
      name: 'newPriceInvalid',
      desc: '',
      args: [],
    );
  }

  /// `The new price must be less than or equal to the old price`
  String get newPriceMustBeLessThanOldPrice {
    return Intl.message(
      'The new price must be less than or equal to the old price',
      name: 'newPriceMustBeLessThanOldPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please select a currency`
  String get currencyRequired {
    return Intl.message(
      'Please select a currency',
      name: 'currencyRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please check the entered data`
  String get invalidData {
    return Intl.message(
      'Please check the entered data',
      name: 'invalidData',
      desc: '',
      args: [],
    );
  }

  /// `Invalid package data`
  String get invalidPackage {
    return Intl.message(
      'Invalid package data',
      name: 'invalidPackage',
      desc: '',
      args: [],
    );
  }

  /// `Choose Curriculum Type`
  String get chooseCurriculumType {
    return Intl.message(
      'Choose Curriculum Type',
      name: 'chooseCurriculumType',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum Image`
  String get curriculumIcon {
    return Intl.message(
      'Curriculum Image',
      name: 'curriculumIcon',
      desc: '',
      args: [],
    );
  }

  /// `Select curriculum`
  String get selectCurriculum {
    return Intl.message(
      'Select curriculum',
      name: 'selectCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `No curricula available`
  String get noCurriculumsAvailable {
    return Intl.message(
      'No curricula available',
      name: 'noCurriculumsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Plans`
  String get plansTitle {
    return Intl.message('Plans', name: 'plansTitle', desc: '', args: []);
  }

  /// `Daily Plans`
  String get dailyPlansTitle {
    return Intl.message(
      'Daily Plans',
      name: 'dailyPlansTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add a daily plan for students`
  String get addDailyPlanForStudents {
    return Intl.message(
      'Add a daily plan for students',
      name: 'addDailyPlanForStudents',
      desc: '',
      args: [],
    );
  }

  /// `Daily plan added successfully`
  String get dailyPlanCreatedSuccessfully {
    return Intl.message(
      'Daily plan added successfully',
      name: 'dailyPlanCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The plan has already been uploaded for this day.`
  String get dailyPlanAlreadyUploaded {
    return Intl.message(
      'The plan has already been uploaded for this day.',
      name: 'dailyPlanAlreadyUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Term plan uploaded successfully`
  String get termPlanUploadedSuccessfully {
    return Intl.message(
      'Term plan uploaded successfully',
      name: 'termPlanUploadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Upload study plan`
  String get uploadStudyPlan {
    return Intl.message(
      'Upload study plan',
      name: 'uploadStudyPlan',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Select week`
  String get selectWeek {
    return Intl.message('Select week', name: 'selectWeek', desc: '', args: []);
  }

  /// `Select teacher`
  String get selectTeacher {
    return Intl.message(
      'Select teacher',
      name: 'selectTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Lesson`
  String get lessonLabel {
    return Intl.message('Lesson', name: 'lessonLabel', desc: '', args: []);
  }

  /// `Homework`
  String get homeworkLabel {
    return Intl.message('Homework', name: 'homeworkLabel', desc: '', args: []);
  }

  /// `Add`
  String get addAction {
    return Intl.message('Add', name: 'addAction', desc: '', args: []);
  }

  /// `Upload`
  String get uploadAction {
    return Intl.message('Upload', name: 'uploadAction', desc: '', args: []);
  }

  /// `Study plan for`
  String get studyPlanTitlePrefix {
    return Intl.message(
      'Study plan for',
      name: 'studyPlanTitlePrefix',
      desc: '',
      args: [],
    );
  }

  /// `No plans for this week`
  String get noPlansForWeek {
    return Intl.message(
      'No plans for this week',
      name: 'noPlansForWeek',
      desc: '',
      args: [],
    );
  }

  /// `No schedule for this week`
  String get noScheduleForWeek {
    return Intl.message(
      'No schedule for this week',
      name: 'noScheduleForWeek',
      desc: '',
      args: [],
    );
  }

  /// `No schedule`
  String get noSchedule {
    return Intl.message('No schedule', name: 'noSchedule', desc: '', args: []);
  }

  /// `No study weeks are available for this classroom`
  String get noStudyWeeksAvailable {
    return Intl.message(
      'No study weeks are available for this classroom',
      name: 'noStudyWeeksAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Plan file`
  String get planFile {
    return Intl.message('Plan file', name: 'planFile', desc: '', args: []);
  }

  /// `Plan file is required`
  String get planFileRequired {
    return Intl.message(
      'Plan file is required',
      name: 'planFileRequired',
      desc: '',
      args: [],
    );
  }

  /// `First primary grade`
  String get firstPrimaryClassroom {
    return Intl.message(
      'First primary grade',
      name: 'firstPrimaryClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Second primary grade`
  String get secondPrimaryClassroom {
    return Intl.message(
      'Second primary grade',
      name: 'secondPrimaryClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Week 1`
  String get weekOne {
    return Intl.message('Week 1', name: 'weekOne', desc: '', args: []);
  }

  /// `Week 2`
  String get weekTwo {
    return Intl.message('Week 2', name: 'weekTwo', desc: '', args: []);
  }

  /// `Quadratic equations`
  String get sampleQuadraticEquations {
    return Intl.message(
      'Quadratic equations',
      name: 'sampleQuadraticEquations',
      desc: '',
      args: [],
    );
  }

  /// `Grammar rules`
  String get sampleGrammarLesson {
    return Intl.message(
      'Grammar rules',
      name: 'sampleGrammarLesson',
      desc: '',
      args: [],
    );
  }

  /// `Solve exercise 45`
  String get sampleExercisesHomework {
    return Intl.message(
      'Solve exercise 45',
      name: 'sampleExercisesHomework',
      desc: '',
      args: [],
    );
  }

  /// `Sarah Abdullah`
  String get sampleTeacherOne {
    return Intl.message(
      'Sarah Abdullah',
      name: 'sampleTeacherOne',
      desc: '',
      args: [],
    );
  }

  /// `Mona Ahmed`
  String get sampleTeacherTwo {
    return Intl.message(
      'Mona Ahmed',
      name: 'sampleTeacherTwo',
      desc: '',
      args: [],
    );
  }

  /// `mm/dd/yy`
  String get dateFormatHint {
    return Intl.message('mm/dd/yy', name: 'dateFormatHint', desc: '', args: []);
  }

  /// `Future dates are not allowed`
  String get futurePlanDateNotAllowed {
    return Intl.message(
      'Future dates are not allowed',
      name: 'futurePlanDateNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `You were assigned as supervisor for third grade`
  String get supervisorAssignedNotification {
    return Intl.message(
      'You were assigned as supervisor for third grade',
      name: 'supervisorAssignedNotification',
      desc: '',
      args: [],
    );
  }

  /// `A weekly evaluation was added for class 4A`
  String get weeklyEvaluationAddedNotification {
    return Intl.message(
      'A weekly evaluation was added for class 4A',
      name: 'weeklyEvaluationAddedNotification',
      desc: '',
      args: [],
    );
  }

  /// `A new message from fourth grade`
  String get newClassMessageNotification {
    return Intl.message(
      'A new message from fourth grade',
      name: 'newClassMessageNotification',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get noNotifications {
    return Intl.message(
      'No notifications',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Term Plan`
  String get termPlan {
    return Intl.message('Term Plan', name: 'termPlan', desc: '', args: []);
  }

  /// `All Classrooms`
  String get allClassrooms {
    return Intl.message(
      'All Classrooms',
      name: 'allClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `No term plans available`
  String get noTermPlansAvailable {
    return Intl.message(
      'No term plans available',
      name: 'noTermPlansAvailable',
      desc: '',
      args: [],
    );
  }

  /// `View Term Plan`
  String get viewTermPlan {
    return Intl.message(
      'View Term Plan',
      name: 'viewTermPlan',
      desc: '',
      args: [],
    );
  }

  /// `Attachment`
  String get attachment {
    return Intl.message('Attachment', name: 'attachment', desc: '', args: []);
  }

  /// `Unable to load the attachment`
  String get unableToLoadAttachment {
    return Intl.message(
      'Unable to load the attachment',
      name: 'unableToLoadAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the attachment`
  String get unableToOpenAttachment {
    return Intl.message(
      'Unable to open the attachment',
      name: 'unableToOpenAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Close preview`
  String get closePreview {
    return Intl.message(
      'Close preview',
      name: 'closePreview',
      desc: '',
      args: [],
    );
  }

  /// `Child`
  String get child {
    return Intl.message('Child', name: 'child', desc: '', args: []);
  }

  /// `Select Child`
  String get selectChild {
    return Intl.message(
      'Select Child',
      name: 'selectChild',
      desc: '',
      args: [],
    );
  }

  /// `Study Plan`
  String get studyPlanFor {
    return Intl.message('Study Plan', name: 'studyPlanFor', desc: '', args: []);
  }

  /// `No children available`
  String get noChildrenAvailable {
    return Intl.message(
      'No children available',
      name: 'noChildrenAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No plans available`
  String get noPlansAvailable {
    return Intl.message(
      'No plans available',
      name: 'noPlansAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Student: {name}`
  String weeklyEvaluationStudentTitle(Object name) {
    return Intl.message(
      'Student: $name',
      name: 'weeklyEvaluationStudentTitle',
      desc: '',
      args: [name],
    );
  }

  /// `No evaluation weeks are available`
  String get noEvaluationWeeksAvailable {
    return Intl.message(
      'No evaluation weeks are available',
      name: 'noEvaluationWeeksAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No weekly evaluations`
  String get noWeeklyEvaluations {
    return Intl.message(
      'No weekly evaluations',
      name: 'noWeeklyEvaluations',
      desc: '',
      args: [],
    );
  }

  /// `No evaluation for this student`
  String get noEvaluationForStudent {
    return Intl.message(
      'No evaluation for this student',
      name: 'noEvaluationForStudent',
      desc: '',
      args: [],
    );
  }

  /// `No subjects are available for this student`
  String get noSubjectsForStudent {
    return Intl.message(
      'No subjects are available for this student',
      name: 'noSubjectsForStudent',
      desc: '',
      args: [],
    );
  }

  /// `Enter a positive whole week number`
  String get positiveWeekRequired {
    return Intl.message(
      'Enter a positive whole week number',
      name: 'positiveWeekRequired',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation saved successfully`
  String get evaluationSavedSuccessfully {
    return Intl.message(
      'Evaluation saved successfully',
      name: 'evaluationSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Present`
  String get evaluationPresent {
    return Intl.message(
      'Present',
      name: 'evaluationPresent',
      desc: '',
      args: [],
    );
  }

  /// `Absent`
  String get evaluationAbsent {
    return Intl.message('Absent', name: 'evaluationAbsent', desc: '', args: []);
  }

  /// `Late`
  String get evaluationLate {
    return Intl.message('Late', name: 'evaluationLate', desc: '', args: []);
  }

  /// `Excused`
  String get evaluationExcused {
    return Intl.message(
      'Excused',
      name: 'evaluationExcused',
      desc: '',
      args: [],
    );
  }

  /// `Acceptable`
  String get evaluationAcceptable {
    return Intl.message(
      'Acceptable',
      name: 'evaluationAcceptable',
      desc: '',
      args: [],
    );
  }

  /// `Weak`
  String get evaluationWeak {
    return Intl.message('Weak', name: 'evaluationWeak', desc: '', args: []);
  }

  /// `Evaluated`
  String get evaluationEvaluated {
    return Intl.message(
      'Evaluated',
      name: 'evaluationEvaluated',
      desc: '',
      args: [],
    );
  }

  /// `Not evaluated`
  String get evaluationNotEvaluated {
    return Intl.message(
      'Not evaluated',
      name: 'evaluationNotEvaluated',
      desc: '',
      args: [],
    );
  }

  /// `No subjects are available to you for this student`
  String get noSubjectsAvailableForTeacherStudent {
    return Intl.message(
      'No subjects are available to you for this student',
      name: 'noSubjectsAvailableForTeacherStudent',
      desc: '',
      args: [],
    );
  }

  /// `No children are linked to this account`
  String get noChildrenLinked {
    return Intl.message(
      'No children are linked to this account',
      name: 'noChildrenLinked',
      desc: '',
      args: [],
    );
  }

  /// `Attendance Registration`
  String get attendanceRegistration {
    return Intl.message(
      'Attendance Registration',
      name: 'attendanceRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Edit Attendance`
  String get editAttendance {
    return Intl.message(
      'Edit Attendance',
      name: 'editAttendance',
      desc: '',
      args: [],
    );
  }

  /// `Select lesson`
  String get selectLesson {
    return Intl.message(
      'Select lesson',
      name: 'selectLesson',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Attendance registered successfully`
  String get attendanceRegisteredSuccessfully {
    return Intl.message(
      'Attendance registered successfully',
      name: 'attendanceRegisteredSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Attendance updated successfully`
  String get attendanceUpdatedSuccessfully {
    return Intl.message(
      'Attendance updated successfully',
      name: 'attendanceUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Select a grade to view attendance data`
  String get selectGradeToViewAttendance {
    return Intl.message(
      'Select a grade to view attendance data',
      name: 'selectGradeToViewAttendance',
      desc: '',
      args: [],
    );
  }

  /// `No lessons available`
  String get noLessonsAvailable {
    return Intl.message(
      'No lessons available',
      name: 'noLessonsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `There are no students in this classroom`
  String get noStudentsInClassroom {
    return Intl.message(
      'There are no students in this classroom',
      name: 'noStudentsInClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load attendance data`
  String get failedToLoadAttendance {
    return Intl.message(
      'Failed to load attendance data',
      name: 'failedToLoadAttendance',
      desc: '',
      args: [],
    );
  }

  /// `Attendance for {grade}`
  String attendanceStudentsTitle(Object grade) {
    return Intl.message(
      'Attendance for $grade',
      name: 'attendanceStudentsTitle',
      desc: '',
      args: [grade],
    );
  }

  /// `Copied successfully`
  String get copiedSuccessfully {
    return Intl.message(
      'Copied successfully',
      name: 'copiedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `CV link is not available`
  String get cvUnavailable {
    return Intl.message(
      'CV link is not available',
      name: 'cvUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `The CV link is invalid`
  String get invalidCvUrl {
    return Intl.message(
      'The CV link is invalid',
      name: 'invalidCvUrl',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the CV`
  String get failedToOpenCv {
    return Intl.message(
      'Unable to open the CV',
      name: 'failedToOpenCv',
      desc: '',
      args: [],
    );
  }

  /// `Unable to copy`
  String get failedToCopy {
    return Intl.message(
      'Unable to copy',
      name: 'failedToCopy',
      desc: '',
      args: [],
    );
  }

  /// `You are not authorized to view this student's data`
  String get weeklyEvaluationsStudentAccessDenied {
    return Intl.message(
      'You are not authorized to view this student\'s data',
      name: 'weeklyEvaluationsStudentAccessDenied',
      desc: '',
      args: [],
    );
  }

  /// `There is a problem with the classroom subject setup. Please contact administration`
  String get weeklyEvaluationsGulfClassroomConflict {
    return Intl.message(
      'There is a problem with the classroom subject setup. Please contact administration',
      name: 'weeklyEvaluationsGulfClassroomConflict',
      desc: '',
      args: [],
    );
  }

  /// `Week {number}`
  String weekNumber(Object number) {
    return Intl.message(
      'Week $number',
      name: 'weekNumber',
      desc: '',
      args: [number],
    );
  }

  /// `No evaluation was recorded for this week`
  String get noEvaluationRecordedThisWeek {
    return Intl.message(
      'No evaluation was recorded for this week',
      name: 'noEvaluationRecordedThisWeek',
      desc: '',
      args: [],
    );
  }

  /// `No evaluation was recorded for this subject this week`
  String get noSubjectEvaluationRecordedThisWeek {
    return Intl.message(
      'No evaluation was recorded for this subject this week',
      name: 'noSubjectEvaluationRecordedThisWeek',
      desc: '',
      args: [],
    );
  }

  /// `No valid subject is linked to this classroom`
  String get noValidSubjectForClassroom {
    return Intl.message(
      'No valid subject is linked to this classroom',
      name: 'noValidSubjectForClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation status is unavailable`
  String get evaluationStatusUnavailable {
    return Intl.message(
      'Evaluation status is unavailable',
      name: 'evaluationStatusUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `No subjects are available`
  String get noSubjectsAvailableReadOnly {
    return Intl.message(
      'No subjects are available',
      name: 'noSubjectsAvailableReadOnly',
      desc: '',
      args: [],
    );
  }

  /// `All Documents`
  String get allDocuments {
    return Intl.message(
      'All Documents',
      name: 'allDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Recordings`
  String get recordings {
    return Intl.message('Recordings', name: 'recordings', desc: '', args: []);
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Session Recording`
  String get sessionRecording {
    return Intl.message(
      'Session Recording',
      name: 'sessionRecording',
      desc: '',
      args: [],
    );
  }

  /// `Session Summary`
  String get sessionSummary {
    return Intl.message(
      'Session Summary',
      name: 'sessionSummary',
      desc: '',
      args: [],
    );
  }

  /// `Next Steps`
  String get nextSteps {
    return Intl.message('Next Steps', name: 'nextSteps', desc: '', args: []);
  }

  /// `Open Recording`
  String get openRecording {
    return Intl.message(
      'Open Recording',
      name: 'openRecording',
      desc: '',
      args: [],
    );
  }

  /// `Open Document`
  String get openDocument {
    return Intl.message(
      'Open Document',
      name: 'openDocument',
      desc: '',
      args: [],
    );
  }

  /// `No recordings are available yet`
  String get noRecordingsAvailable {
    return Intl.message(
      'No recordings are available yet',
      name: 'noRecordingsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No reports are available yet`
  String get noReportsAvailable {
    return Intl.message(
      'No reports are available yet',
      name: 'noReportsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No summary content is available`
  String get noSummaryContent {
    return Intl.message(
      'No summary content is available',
      name: 'noSummaryContent',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open link`
  String get unableToOpenLink {
    return Intl.message(
      'Unable to open link',
      name: 'unableToOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Message Documents`
  String get messageDocuments {
    return Intl.message(
      'Message Documents',
      name: 'messageDocuments',
      desc: '',
      args: [],
    );
  }

  /// `No message documents are available yet`
  String get noMessageDocumentsAvailable {
    return Intl.message(
      'No message documents are available yet',
      name: 'noMessageDocumentsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Open File`
  String get openFile {
    return Intl.message('Open File', name: 'openFile', desc: '', args: []);
  }

  /// `Open Link`
  String get openLink {
    return Intl.message('Open Link', name: 'openLink', desc: '', args: []);
  }

  /// `Unable to open the document`
  String get unableToOpenDocument {
    return Intl.message(
      'Unable to open the document',
      name: 'unableToOpenDocument',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the session recording`
  String get unableToOpenSessionRecording {
    return Intl.message(
      'Unable to open the session recording',
      name: 'unableToOpenSessionRecording',
      desc: '',
      args: [],
    );
  }

  /// `Invalid link`
  String get invalidLink {
    return Intl.message(
      'Invalid link',
      name: 'invalidLink',
      desc: '',
      args: [],
    );
  }

  /// `Discount Codes`
  String get discountCodes {
    return Intl.message(
      'Discount Codes',
      name: 'discountCodes',
      desc: '',
      args: [],
    );
  }

  /// `Add Discount Code`
  String get addDiscountCode {
    return Intl.message(
      'Add Discount Code',
      name: 'addDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Edit Discount Code`
  String get editDiscountCode {
    return Intl.message(
      'Edit Discount Code',
      name: 'editDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Discount code`
  String get discountCode {
    return Intl.message(
      'Discount code',
      name: 'discountCode',
      desc: '',
      args: [],
    );
  }

  /// `Discount code (optional)`
  String get optionalDiscountCode {
    return Intl.message(
      'Discount code (optional)',
      name: 'optionalDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter discount code`
  String get enterDiscountCode {
    return Intl.message(
      'Enter discount code',
      name: 'enterDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Percentage`
  String get discountPercentage {
    return Intl.message(
      'Percentage',
      name: 'discountPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get discountType {
    return Intl.message('Type', name: 'discountType', desc: '', args: []);
  }

  /// `Date range`
  String get dateRangeDiscount {
    return Intl.message(
      'Date range',
      name: 'dateRangeDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Number of children`
  String get childrenDiscount {
    return Intl.message(
      'Number of children',
      name: 'childrenDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Start date`
  String get startDate {
    return Intl.message('Start date', name: 'startDate', desc: '', args: []);
  }

  /// `End date`
  String get endDate {
    return Intl.message('End date', name: 'endDate', desc: '', args: []);
  }

  /// `Children count`
  String get childrenCount {
    return Intl.message(
      'Children count',
      name: 'childrenCount',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get isActive {
    return Intl.message('Active', name: 'isActive', desc: '', args: []);
  }

  /// `No discount codes are available`
  String get noDiscountCodes {
    return Intl.message(
      'No discount codes are available',
      name: 'noDiscountCodes',
      desc: '',
      args: [],
    );
  }

  /// `Delete discount code`
  String get deleteDiscountCode {
    return Intl.message(
      'Delete discount code',
      name: 'deleteDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this discount code?`
  String get deleteDiscountCodeConfirmation {
    return Intl.message(
      'Are you sure you want to delete this discount code?',
      name: 'deleteDiscountCodeConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Discount code created successfully`
  String get discountCodeCreated {
    return Intl.message(
      'Discount code created successfully',
      name: 'discountCodeCreated',
      desc: '',
      args: [],
    );
  }

  /// `Discount code updated successfully`
  String get discountCodeUpdated {
    return Intl.message(
      'Discount code updated successfully',
      name: 'discountCodeUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Discount code deleted successfully`
  String get discountCodeDeleted {
    return Intl.message(
      'Discount code deleted successfully',
      name: 'discountCodeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Discount code is required`
  String get discountCodeRequired {
    return Intl.message(
      'Discount code is required',
      name: 'discountCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid percentage`
  String get invalidDiscountPercentage {
    return Intl.message(
      'Enter a valid percentage',
      name: 'invalidDiscountPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Start and end dates are required`
  String get discountDatesRequired {
    return Intl.message(
      'Start and end dates are required',
      name: 'discountDatesRequired',
      desc: '',
      args: [],
    );
  }

  /// `End date cannot be before start date`
  String get discountEndBeforeStart {
    return Intl.message(
      'End date cannot be before start date',
      name: 'discountEndBeforeStart',
      desc: '',
      args: [],
    );
  }

  /// `Enter a positive children count`
  String get invalidChildrenCount {
    return Intl.message(
      'Enter a positive children count',
      name: 'invalidChildrenCount',
      desc: '',
      args: [],
    );
  }

  /// `Original price`
  String get originalAmount {
    return Intl.message(
      'Original price',
      name: 'originalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discountAmount {
    return Intl.message('Discount', name: 'discountAmount', desc: '', args: []);
  }

  /// `Total`
  String get finalAmount {
    return Intl.message('Total', name: 'finalAmount', desc: '', args: []);
  }

  /// `Bonus Points`
  String get bonusPoints {
    return Intl.message(
      'Bonus Points',
      name: 'bonusPoints',
      desc: '',
      args: [],
    );
  }

  /// `Bonus points must be from 0 to 5`
  String get invalidEvaluationBonus {
    return Intl.message(
      'Bonus points must be from 0 to 5',
      name: 'invalidEvaluationBonus',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Teacher Payrolls`
  String get teacherPayrolls {
    return Intl.message(
      'Teacher Payrolls',
      name: 'teacherPayrolls',
      desc: '',
      args: [],
    );
  }

  /// `Unprepared`
  String get payrollUnprepared {
    return Intl.message(
      'Unprepared',
      name: 'payrollUnprepared',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get payrollDraft {
    return Intl.message('Draft', name: 'payrollDraft', desc: '', args: []);
  }

  /// `Paid`
  String get payrollPaid {
    return Intl.message('Paid', name: 'payrollPaid', desc: '', args: []);
  }

  /// `Cancelled`
  String get payrollCancelled {
    return Intl.message(
      'Cancelled',
      name: 'payrollCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Payroll filters`
  String get payrollFilters {
    return Intl.message(
      'Payroll filters',
      name: 'payrollFilters',
      desc: '',
      args: [],
    );
  }

  /// `From date`
  String get payrollFromDate {
    return Intl.message(
      'From date',
      name: 'payrollFromDate',
      desc: '',
      args: [],
    );
  }

  /// `To date`
  String get payrollToDate {
    return Intl.message('To date', name: 'payrollToDate', desc: '', args: []);
  }

  /// `Status`
  String get payrollStatus {
    return Intl.message('Status', name: 'payrollStatus', desc: '', args: []);
  }

  /// `All statuses`
  String get payrollAllStatuses {
    return Intl.message(
      'All statuses',
      name: 'payrollAllStatuses',
      desc: '',
      args: [],
    );
  }

  /// `All teachers`
  String get payrollAllTeachers {
    return Intl.message(
      'All teachers',
      name: 'payrollAllTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Apply filters`
  String get payrollApplyFilters {
    return Intl.message(
      'Apply filters',
      name: 'payrollApplyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Reset filters`
  String get payrollResetFilters {
    return Intl.message(
      'Reset filters',
      name: 'payrollResetFilters',
      desc: '',
      args: [],
    );
  }

  /// `No teachers match the selected period or filters`
  String get payrollNoMatchingTeachers {
    return Intl.message(
      'No teachers match the selected period or filters',
      name: 'payrollNoMatchingTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Gulf`
  String get payrollGulfWork {
    return Intl.message('Gulf', name: 'payrollGulfWork', desc: '', args: []);
  }

  /// `Egyptian`
  String get payrollEgyptianWork {
    return Intl.message(
      'Egyptian',
      name: 'payrollEgyptianWork',
      desc: '',
      args: [],
    );
  }

  /// `Curriculums`
  String get payrollCurriculumsCount {
    return Intl.message(
      'Curriculums',
      name: 'payrollCurriculumsCount',
      desc: '',
      args: [],
    );
  }

  /// `{count} session(s) were excluded because their duration data is incomplete`
  String payrollExcludedSessions(Object count) {
    return Intl.message(
      '$count session(s) were excluded because their duration data is incomplete',
      name: 'payrollExcludedSessions',
      desc: '',
      args: [count],
    );
  }

  /// `Create payroll`
  String get payrollCreate {
    return Intl.message(
      'Create payroll',
      name: 'payrollCreate',
      desc: '',
      args: [],
    );
  }

  /// `Continue draft`
  String get payrollContinueDraft {
    return Intl.message(
      'Continue draft',
      name: 'payrollContinueDraft',
      desc: '',
      args: [],
    );
  }

  /// `View details`
  String get payrollViewDetails {
    return Intl.message(
      'View details',
      name: 'payrollViewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Teacher and period`
  String get payrollTeacherDetails {
    return Intl.message(
      'Teacher and period',
      name: 'payrollTeacherDetails',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get payrollPeriod {
    return Intl.message('Period', name: 'payrollPeriod', desc: '', args: []);
  }

  /// `System`
  String get payrollSystem {
    return Intl.message('System', name: 'payrollSystem', desc: '', args: []);
  }

  /// `Gulf`
  String get payrollGulf {
    return Intl.message('Gulf', name: 'payrollGulf', desc: '', args: []);
  }

  /// `Egyptian`
  String get payrollEgyptian {
    return Intl.message(
      'Egyptian',
      name: 'payrollEgyptian',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get payrollDuration {
    return Intl.message(
      'Duration',
      name: 'payrollDuration',
      desc: '',
      args: [],
    );
  }

  /// `Duration in minutes`
  String get payrollDurationMinutes {
    return Intl.message(
      'Duration in minutes',
      name: 'payrollDurationMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Sessions`
  String get payrollSessionsCount {
    return Intl.message(
      'Sessions',
      name: 'payrollSessionsCount',
      desc: '',
      args: [],
    );
  }

  /// `Hourly rate`
  String get payrollHourlyRate {
    return Intl.message(
      'Hourly rate',
      name: 'payrollHourlyRate',
      desc: '',
      args: [],
    );
  }

  /// `Session rate`
  String get payrollSessionRate {
    return Intl.message(
      'Session rate',
      name: 'payrollSessionRate',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get payrollAmount {
    return Intl.message('Amount', name: 'payrollAmount', desc: '', args: []);
  }

  /// `Review sessions`
  String get payrollReviewSessions {
    return Intl.message(
      'Review sessions',
      name: 'payrollReviewSessions',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid non-negative amount`
  String get payrollInvalidAmount {
    return Intl.message(
      'Enter a valid non-negative amount',
      name: 'payrollInvalidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Bonus and deductions`
  String get payrollAdjustments {
    return Intl.message(
      'Bonus and deductions',
      name: 'payrollAdjustments',
      desc: '',
      args: [],
    );
  }

  /// `Bonus`
  String get payrollBonus {
    return Intl.message('Bonus', name: 'payrollBonus', desc: '', args: []);
  }

  /// `Deduction`
  String get payrollDeduction {
    return Intl.message(
      'Deduction',
      name: 'payrollDeduction',
      desc: '',
      args: [],
    );
  }

  /// `Adjustment reason`
  String get payrollAdjustmentNote {
    return Intl.message(
      'Adjustment reason',
      name: 'payrollAdjustmentNote',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get payrollTotal {
    return Intl.message('Total', name: 'payrollTotal', desc: '', args: []);
  }

  /// `Net total`
  String get payrollNetTotal {
    return Intl.message(
      'Net total',
      name: 'payrollNetTotal',
      desc: '',
      args: [],
    );
  }

  /// `Payroll total cannot be negative`
  String get payrollNegativeTotal {
    return Intl.message(
      'Payroll total cannot be negative',
      name: 'payrollNegativeTotal',
      desc: '',
      args: [],
    );
  }

  /// `No eligible work exists for this teacher in the selected period`
  String get payrollNoWork {
    return Intl.message(
      'No eligible work exists for this teacher in the selected period',
      name: 'payrollNoWork',
      desc: '',
      args: [],
    );
  }

  /// `Save as draft`
  String get payrollSaveDraft {
    return Intl.message(
      'Save as draft',
      name: 'payrollSaveDraft',
      desc: '',
      args: [],
    );
  }

  /// `Payout details`
  String get payrollPayoutDetails {
    return Intl.message(
      'Payout details',
      name: 'payrollPayoutDetails',
      desc: '',
      args: [],
    );
  }

  /// `No payout details. Add them before recording payment.`
  String get payrollNoPayoutProfile {
    return Intl.message(
      'No payout details. Add them before recording payment.',
      name: 'payrollNoPayoutProfile',
      desc: '',
      args: [],
    );
  }

  /// `Add payout details`
  String get payrollAddPayoutProfile {
    return Intl.message(
      'Add payout details',
      name: 'payrollAddPayoutProfile',
      desc: '',
      args: [],
    );
  }

  /// `Edit payout details`
  String get payrollEditPayoutProfile {
    return Intl.message(
      'Edit payout details',
      name: 'payrollEditPayoutProfile',
      desc: '',
      args: [],
    );
  }

  /// `Payout method`
  String get payrollPayoutMethod {
    return Intl.message(
      'Payout method',
      name: 'payrollPayoutMethod',
      desc: '',
      args: [],
    );
  }

  /// `InstaPay`
  String get payrollInstapay {
    return Intl.message(
      'InstaPay',
      name: 'payrollInstapay',
      desc: '',
      args: [],
    );
  }

  /// `Electronic wallet`
  String get payrollWallet {
    return Intl.message(
      'Electronic wallet',
      name: 'payrollWallet',
      desc: '',
      args: [],
    );
  }

  /// `Bank account`
  String get payrollBankAccount {
    return Intl.message(
      'Bank account',
      name: 'payrollBankAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account holder`
  String get payrollAccountHolder {
    return Intl.message(
      'Account holder',
      name: 'payrollAccountHolder',
      desc: '',
      args: [],
    );
  }

  /// `InstaPay address`
  String get payrollInstapayAddress {
    return Intl.message(
      'InstaPay address',
      name: 'payrollInstapayAddress',
      desc: '',
      args: [],
    );
  }

  /// `Wallet provider`
  String get payrollWalletProvider {
    return Intl.message(
      'Wallet provider',
      name: 'payrollWalletProvider',
      desc: '',
      args: [],
    );
  }

  /// `Wallet phone`
  String get payrollWalletPhone {
    return Intl.message(
      'Wallet phone',
      name: 'payrollWalletPhone',
      desc: '',
      args: [],
    );
  }

  /// `Bank name`
  String get payrollBankName {
    return Intl.message(
      'Bank name',
      name: 'payrollBankName',
      desc: '',
      args: [],
    );
  }

  /// `Account number`
  String get payrollAccountNumber {
    return Intl.message(
      'Account number',
      name: 'payrollAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `IBAN`
  String get payrollIban {
    return Intl.message('IBAN', name: 'payrollIban', desc: '', args: []);
  }

  /// `Enter an account number or IBAN`
  String get payrollBankDestinationRequired {
    return Intl.message(
      'Enter an account number or IBAN',
      name: 'payrollBankDestinationRequired',
      desc: '',
      args: [],
    );
  }

  /// `Confirm payment`
  String get payrollConfirmPayment {
    return Intl.message(
      'Confirm payment',
      name: 'payrollConfirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment date`
  String get payrollPaidAt {
    return Intl.message(
      'Payment date',
      name: 'payrollPaidAt',
      desc: '',
      args: [],
    );
  }

  /// `Transaction reference`
  String get payrollTransactionReference {
    return Intl.message(
      'Transaction reference',
      name: 'payrollTransactionReference',
      desc: '',
      args: [],
    );
  }

  /// `Transfer receipt`
  String get payrollTransferReceipt {
    return Intl.message(
      'Transfer receipt',
      name: 'payrollTransferReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Choose receipt image`
  String get payrollChooseReceipt {
    return Intl.message(
      'Choose receipt image',
      name: 'payrollChooseReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Remove receipt`
  String get payrollRemoveReceipt {
    return Intl.message(
      'Remove receipt',
      name: 'payrollRemoveReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Transfer receipt is required`
  String get payrollReceiptRequired {
    return Intl.message(
      'Transfer receipt is required',
      name: 'payrollReceiptRequired',
      desc: '',
      args: [],
    );
  }

  /// `The receipt must not exceed 5 MB`
  String get payrollReceiptTooLarge {
    return Intl.message(
      'The receipt must not exceed 5 MB',
      name: 'payrollReceiptTooLarge',
      desc: '',
      args: [],
    );
  }

  /// `Use a PNG, JPG, JPEG, or WebP image`
  String get payrollReceiptInvalidType {
    return Intl.message(
      'Use a PNG, JPG, JPEG, or WebP image',
      name: 'payrollReceiptInvalidType',
      desc: '',
      args: [],
    );
  }

  /// `The selected file is unavailable`
  String get payrollReceiptMissing {
    return Intl.message(
      'The selected file is unavailable',
      name: 'payrollReceiptMissing',
      desc: '',
      args: [],
    );
  }

  /// `Confirm payroll payment?`
  String get payrollPaymentConfirmationTitle {
    return Intl.message(
      'Confirm payroll payment?',
      name: 'payrollPaymentConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `{total} {currency} will be recorded as paid. The payroll cannot be edited afterward.`
  String payrollPaymentConfirmationBody(Object total, Object currency) {
    return Intl.message(
      '$total $currency will be recorded as paid. The payroll cannot be edited afterward.',
      name: 'payrollPaymentConfirmationBody',
      desc: '',
      args: [total, currency],
    );
  }

  /// `Payment details`
  String get payrollPaymentDetails {
    return Intl.message(
      'Payment details',
      name: 'payrollPaymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Session details`
  String get payrollSessionDetails {
    return Intl.message(
      'Session details',
      name: 'payrollSessionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Work summary`
  String get payrollWorkSummary {
    return Intl.message(
      'Work summary',
      name: 'payrollWorkSummary',
      desc: '',
      args: [],
    );
  }

  /// `Included`
  String get payrollIncluded {
    return Intl.message(
      'Included',
      name: 'payrollIncluded',
      desc: '',
      args: [],
    );
  }

  /// `Current period`
  String get payrollCurrentPeriod {
    return Intl.message(
      'Current period',
      name: 'payrollCurrentPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Filter payrolls`
  String get payrollFilterAction {
    return Intl.message(
      'Filter payrolls',
      name: 'payrollFilterAction',
      desc: '',
      args: [],
    );
  }

  /// `Add child`
  String get parentAddChild {
    return Intl.message(
      'Add child',
      name: 'parentAddChild',
      desc: '',
      args: [],
    );
  }

  /// `Add a new child`
  String get parentAddChildTitle {
    return Intl.message(
      'Add a new child',
      name: 'parentAddChildTitle',
      desc: '',
      args: [],
    );
  }

  /// `Child details`
  String get parentChildAccountStep {
    return Intl.message(
      'Child details',
      name: 'parentChildAccountStep',
      desc: '',
      args: [],
    );
  }

  /// `Choose package`
  String get parentPackageStep {
    return Intl.message(
      'Choose package',
      name: 'parentPackageStep',
      desc: '',
      args: [],
    );
  }

  /// `Choose subjects`
  String get parentSubjectsStep {
    return Intl.message(
      'Choose subjects',
      name: 'parentSubjectsStep',
      desc: '',
      args: [],
    );
  }

  /// `Price and discount review`
  String get parentReviewStep {
    return Intl.message(
      'Price and discount review',
      name: 'parentReviewStep',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get parentPaymentStep {
    return Intl.message(
      'Payment',
      name: 'parentPaymentStep',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get parentChoosePackage {
    return Intl.message(
      'Choose',
      name: 'parentChoosePackage',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get parentPackageSelected {
    return Intl.message(
      'Selected',
      name: 'parentPackageSelected',
      desc: '',
      args: [],
    );
  }

  /// `Exactly one subject is required for this package`
  String get parentSingleSubjectRequired {
    return Intl.message(
      'Exactly one subject is required for this package',
      name: 'parentSingleSubjectRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please complete the payment address`
  String get parentPaymentAddressRequired {
    return Intl.message(
      'Please complete the payment address',
      name: 'parentPaymentAddressRequired',
      desc: '',
      args: [],
    );
  }

  /// `Payment address`
  String get parentPaymentAddress {
    return Intl.message(
      'Payment address',
      name: 'parentPaymentAddress',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get parentRegion {
    return Intl.message('Region', name: 'parentRegion', desc: '', args: []);
  }

  /// `Address`
  String get parentAddressLine1 {
    return Intl.message(
      'Address',
      name: 'parentAddressLine1',
      desc: '',
      args: [],
    );
  }

  /// `Additional address details`
  String get parentAddressLine2 {
    return Intl.message(
      'Additional address details',
      name: 'parentAddressLine2',
      desc: '',
      args: [],
    );
  }

  /// `Payment method (optional)`
  String get parentPaymentMethodOptional {
    return Intl.message(
      'Payment method (optional)',
      name: 'parentPaymentMethodOptional',
      desc: '',
      args: [],
    );
  }

  /// `Reference number (optional)`
  String get parentReferenceNumberOptional {
    return Intl.message(
      'Reference number (optional)',
      name: 'parentReferenceNumberOptional',
      desc: '',
      args: [],
    );
  }

  /// `Receipt selected`
  String get parentReceiptSelected {
    return Intl.message(
      'Receipt selected',
      name: 'parentReceiptSelected',
      desc: '',
      args: [],
    );
  }

  /// `Submit payment`
  String get parentSubmitPayment {
    return Intl.message(
      'Submit payment',
      name: 'parentSubmitPayment',
      desc: '',
      args: [],
    );
  }

  /// `The receipt was submitted and is pending review.`
  String get parentReceiptPendingMessage {
    return Intl.message(
      'The receipt was submitted and is pending review.',
      name: 'parentReceiptPendingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Child added successfully`
  String get parentChildAddedSuccessfully {
    return Intl.message(
      'Child added successfully',
      name: 'parentChildAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Checking payment status...`
  String get parentPaymentProcessing {
    return Intl.message(
      'Checking payment status...',
      name: 'parentPaymentProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Payment was not completed. You can try again.`
  String get parentPaymentFailed {
    return Intl.message(
      'Payment was not completed. You can try again.',
      name: 'parentPaymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Retry payment`
  String get parentRetryPayment {
    return Intl.message(
      'Retry payment',
      name: 'parentRetryPayment',
      desc: '',
      args: [],
    );
  }

  /// `This email is already in use`
  String get parentChildEmailUsed {
    return Intl.message(
      'This email is already in use',
      name: 'parentChildEmailUsed',
      desc: '',
      args: [],
    );
  }

  /// `The receipt could not be submitted. Check the file and try again.`
  String get parentReceiptError {
    return Intl.message(
      'The receipt could not be submitted. Check the file and try again.',
      name: 'parentReceiptError',
      desc: '',
      args: [],
    );
  }

  /// `The child could not be added. Please try again.`
  String get parentAddChildFailed {
    return Intl.message(
      'The child could not be added. Please try again.',
      name: 'parentAddChildFailed',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the payment link`
  String get parentUnableToOpenCheckout {
    return Intl.message(
      'Unable to open the payment link',
      name: 'parentUnableToOpenCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Back to children`
  String get parentBackToChildren {
    return Intl.message(
      'Back to children',
      name: 'parentBackToChildren',
      desc: '',
      args: [],
    );
  }

  /// `Renew subscription`
  String get renewSubscription {
    return Intl.message(
      'Renew subscription',
      name: 'renewSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Purchased hours`
  String get renewalPurchasedHours {
    return Intl.message(
      'Purchased hours',
      name: 'renewalPurchasedHours',
      desc: '',
      args: [],
    );
  }

  /// `Used hours`
  String get renewalUsedHours {
    return Intl.message(
      'Used hours',
      name: 'renewalUsedHours',
      desc: '',
      args: [],
    );
  }

  /// `Remaining hours`
  String get renewalRemainingHours {
    return Intl.message(
      'Remaining hours',
      name: 'renewalRemainingHours',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date`
  String get renewalExpiry {
    return Intl.message(
      'Expiry date',
      name: 'renewalExpiry',
      desc: '',
      args: [],
    );
  }

  /// `Current subscription`
  String get renewalCurrentSubscription {
    return Intl.message(
      'Current subscription',
      name: 'renewalCurrentSubscription',
      desc: '',
      args: [],
    );
  }

  /// `This package includes all subjects; no subject selection is required.`
  String get renewalAllSubjectsNoSelection {
    return Intl.message(
      'This package includes all subjects; no subject selection is required.',
      name: 'renewalAllSubjectsNoSelection',
      desc: '',
      args: [],
    );
  }

  /// `This subscription is still active and cannot be renewed yet.`
  String get renewalSubscriptionStillActive {
    return Intl.message(
      'This subscription is still active and cannot be renewed yet.',
      name: 'renewalSubscriptionStillActive',
      desc: '',
      args: [],
    );
  }

  /// `This subject is not assigned to the student.`
  String get renewalSubjectNotAssigned {
    return Intl.message(
      'This subject is not assigned to the student.',
      name: 'renewalSubjectNotAssigned',
      desc: '',
      args: [],
    );
  }

  /// `You are not allowed to renew this student's subscription.`
  String get renewalStudentAccessDenied {
    return Intl.message(
      'You are not allowed to renew this student\'s subscription.',
      name: 'renewalStudentAccessDenied',
      desc: '',
      args: [],
    );
  }

  /// `The renewal request and receipt were submitted for review.`
  String get renewalReceiptPending {
    return Intl.message(
      'The renewal request and receipt were submitted for review.',
      name: 'renewalReceiptPending',
      desc: '',
      args: [],
    );
  }

  /// `The renewal request was submitted and is pending review.`
  String get renewalRequestPending {
    return Intl.message(
      'The renewal request was submitted and is pending review.',
      name: 'renewalRequestPending',
      desc: '',
      args: [],
    );
  }

  /// `The renewal request was submitted successfully and is now pending administration review.`
  String get egyptianRenewalRequestSubmitted {
    return Intl.message(
      'The renewal request was submitted successfully and is now pending administration review.',
      name: 'egyptianRenewalRequestSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Submit renewal request`
  String get renewalSubmitRequest {
    return Intl.message(
      'Submit renewal request',
      name: 'renewalSubmitRequest',
      desc: '',
      args: [],
    );
  }

  /// `The subscription was renewed successfully.`
  String get renewalCompleted {
    return Intl.message(
      'The subscription was renewed successfully.',
      name: 'renewalCompleted',
      desc: '',
      args: [],
    );
  }

  /// `The subscription could not be renewed. Please try again.`
  String get renewalFailed {
    return Intl.message(
      'The subscription could not be renewed. Please try again.',
      name: 'renewalFailed',
      desc: '',
      args: [],
    );
  }

  /// `A new payment attempt is required. Please try again.`
  String get renewalIdempotencyRequired {
    return Intl.message(
      'A new payment attempt is required. Please try again.',
      name: 'renewalIdempotencyRequired',
      desc: '',
      args: [],
    );
  }

  /// `We could not confirm the payment status yet.`
  String get parentPaymentStatusTimeout {
    return Intl.message(
      'We could not confirm the payment status yet.',
      name: 'parentPaymentStatusTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Check payment status`
  String get parentCheckPaymentStatus {
    return Intl.message(
      'Check payment status',
      name: 'parentCheckPaymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Open payment page`
  String get parentOpenPaymentPage {
    return Intl.message(
      'Open payment page',
      name: 'parentOpenPaymentPage',
      desc: '',
      args: [],
    );
  }

  /// `Payment is confirmed and awaiting final approval.`
  String get parentPaymentConfirmedWaiting {
    return Intl.message(
      'Payment is confirmed and awaiting final approval.',
      name: 'parentPaymentConfirmedWaiting',
      desc: '',
      args: [],
    );
  }

  /// `This curriculum registration mode is not supported.`
  String get parentUnsupportedRegistrationMode {
    return Intl.message(
      'This curriculum registration mode is not supported.',
      name: 'parentUnsupportedRegistrationMode',
      desc: '',
      args: [],
    );
  }

  /// `My Earnings`
  String get teacherMyEarnings {
    return Intl.message(
      'My Earnings',
      name: 'teacherMyEarnings',
      desc: '',
      args: [],
    );
  }

  /// `Under Review`
  String get teacherPayrollUnderReview {
    return Intl.message(
      'Under Review',
      name: 'teacherPayrollUnderReview',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get teacherPayrollAll {
    return Intl.message('All', name: 'teacherPayrollAll', desc: '', args: []);
  }

  /// `This amount is under review and may change before payment.`
  String get teacherPayrollDraftNote {
    return Intl.message(
      'This amount is under review and may change before payment.',
      name: 'teacherPayrollDraftNote',
      desc: '',
      args: [],
    );
  }

  /// `View Report`
  String get teacherPayrollViewReport {
    return Intl.message(
      'View Report',
      name: 'teacherPayrollViewReport',
      desc: '',
      args: [],
    );
  }

  /// `View Report & Receipt`
  String get teacherPayrollViewReportReceipt {
    return Intl.message(
      'View Report & Receipt',
      name: 'teacherPayrollViewReportReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Payroll Report`
  String get teacherPayrollReport {
    return Intl.message(
      'Payroll Report',
      name: 'teacherPayrollReport',
      desc: '',
      args: [],
    );
  }

  /// `Report Summary`
  String get teacherPayrollReportSummary {
    return Intl.message(
      'Report Summary',
      name: 'teacherPayrollReportSummary',
      desc: '',
      args: [],
    );
  }

  /// `Payment Details`
  String get teacherPayrollPaymentDetails {
    return Intl.message(
      'Payment Details',
      name: 'teacherPayrollPaymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Payment has not been transferred yet`
  String get teacherPayrollNotTransferred {
    return Intl.message(
      'Payment has not been transferred yet',
      name: 'teacherPayrollNotTransferred',
      desc: '',
      args: [],
    );
  }

  /// `The transfer receipt will appear here after payment.`
  String get teacherPayrollReceiptLater {
    return Intl.message(
      'The transfer receipt will appear here after payment.',
      name: 'teacherPayrollReceiptLater',
      desc: '',
      args: [],
    );
  }

  /// `Payout Details`
  String get teacherPayrollPayoutDetails {
    return Intl.message(
      'Payout Details',
      name: 'teacherPayrollPayoutDetails',
      desc: '',
      args: [],
    );
  }

  /// `Contact administration to update these details.`
  String get teacherPayrollContactAdmin {
    return Intl.message(
      'Contact administration to update these details.',
      name: 'teacherPayrollContactAdmin',
      desc: '',
      args: [],
    );
  }

  /// `No payout details are registered`
  String get teacherPayrollNoPayout {
    return Intl.message(
      'No payout details are registered',
      name: 'teacherPayrollNoPayout',
      desc: '',
      args: [],
    );
  }

  /// `Contact administration to add payout details.`
  String get teacherPayrollAddPayoutContact {
    return Intl.message(
      'Contact administration to add payout details.',
      name: 'teacherPayrollAddPayoutContact',
      desc: '',
      args: [],
    );
  }

  /// `No payroll earnings or reports yet`
  String get teacherPayrollEmpty {
    return Intl.message(
      'No payroll earnings or reports yet',
      name: 'teacherPayrollEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Payroll report is unavailable`
  String get teacherPayrollUnavailable {
    return Intl.message(
      'Payroll report is unavailable',
      name: 'teacherPayrollUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Paid on`
  String get teacherPayrollPaidOn {
    return Intl.message(
      'Paid on',
      name: 'teacherPayrollPaidOn',
      desc: '',
      args: [],
    );
  }

  /// `Transferred to`
  String get teacherPayrollTransferredTo {
    return Intl.message(
      'Transferred to',
      name: 'teacherPayrollTransferredTo',
      desc: '',
      args: [],
    );
  }

  /// `View payment receipt`
  String get teacherPayrollReceipt {
    return Intl.message(
      'View payment receipt',
      name: 'teacherPayrollReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Method`
  String get teacherPayrollMethod {
    return Intl.message(
      'Method',
      name: 'teacherPayrollMethod',
      desc: '',
      args: [],
    );
  }

  /// `Account name`
  String get teacherPayrollAccountName {
    return Intl.message(
      'Account name',
      name: 'teacherPayrollAccountName',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get teacherPayrollAccountAddress {
    return Intl.message(
      'Address',
      name: 'teacherPayrollAccountAddress',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get teacherPayrollPreparingAmount {
    return Intl.message(
      'Preparing',
      name: 'teacherPayrollPreparingAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get teacherPayrollPaidAmount {
    return Intl.message(
      'Paid',
      name: 'teacherPayrollPaidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payroll {month} {year}`
  String teacherPayrollReportTitle(Object month, Object year) {
    return Intl.message(
      'Payroll $month $year',
      name: 'teacherPayrollReportTitle',
      desc: '',
      args: [month, year],
    );
  }

  /// `Choose subject`
  String get subjectRequestChooseSubject {
    return Intl.message(
      'Choose subject',
      name: 'subjectRequestChooseSubject',
      desc: '',
      args: [],
    );
  }

  /// `Choose package`
  String get subjectRequestChoosePackage {
    return Intl.message(
      'Choose package',
      name: 'subjectRequestChoosePackage',
      desc: '',
      args: [],
    );
  }

  /// `No packages are currently available for a subject request`
  String get subjectRequestNoPackages {
    return Intl.message(
      'No packages are currently available for a subject request',
      name: 'subjectRequestNoPackages',
      desc: '',
      args: [],
    );
  }

  /// `{count} / 2000`
  String subjectRequestNotesCounter(Object count) {
    return Intl.message(
      '$count / 2000',
      name: 'subjectRequestNotesCounter',
      desc: '',
      args: [count],
    );
  }

  /// `Awaiting admin review`
  String get subjectRequestAdminReview {
    return Intl.message(
      'Awaiting admin review',
      name: 'subjectRequestAdminReview',
      desc: '',
      args: [],
    );
  }

  /// `Searching for a teacher`
  String get subjectRequestSearchingTeacher {
    return Intl.message(
      'Searching for a teacher',
      name: 'subjectRequestSearchingTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Teacher assigned`
  String get subjectRequestAssigned {
    return Intl.message(
      'Teacher assigned',
      name: 'subjectRequestAssigned',
      desc: '',
      args: [],
    );
  }

  /// `Request rejected`
  String get subjectRequestRejected {
    return Intl.message(
      'Request rejected',
      name: 'subjectRequestRejected',
      desc: '',
      args: [],
    );
  }

  /// `The request was sent to admin for review`
  String get subjectRequestSubmitted {
    return Intl.message(
      'The request was sent to admin for review',
      name: 'subjectRequestSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Payment completed; searching for a teacher`
  String get subjectRequestPaymentCompleted {
    return Intl.message(
      'Payment completed; searching for a teacher',
      name: 'subjectRequestPaymentCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Verify payment status`
  String get subjectRequestVerifyPayment {
    return Intl.message(
      'Verify payment status',
      name: 'subjectRequestVerifyPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment could not be confirmed automatically. Verify it manually.`
  String get subjectRequestPaymentTimeout {
    return Intl.message(
      'Payment could not be confirmed automatically. Verify it manually.',
      name: 'subjectRequestPaymentTimeout',
      desc: '',
      args: [],
    );
  }

  /// `My current requests`
  String get subjectRequestMyRequests {
    return Intl.message(
      'My current requests',
      name: 'subjectRequestMyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Registration requests`
  String get adminRegistrationRequestsSection {
    return Intl.message(
      'Registration requests',
      name: 'adminRegistrationRequestsSection',
      desc: '',
      args: [],
    );
  }

  /// `Subject/lesson requests`
  String get adminSubjectRequestsSection {
    return Intl.message(
      'Subject/lesson requests',
      name: 'adminSubjectRequestsSection',
      desc: '',
      args: [],
    );
  }

  /// `No subject requests with this status`
  String get adminSubjectRequestsEmpty {
    return Intl.message(
      'No subject requests with this status',
      name: 'adminSubjectRequestsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get adminSubjectRequestApprove {
    return Intl.message(
      'Approve',
      name: 'adminSubjectRequestApprove',
      desc: '',
      args: [],
    );
  }

  /// `Subject request approved`
  String get adminSubjectRequestApproved {
    return Intl.message(
      'Subject request approved',
      name: 'adminSubjectRequestApproved',
      desc: '',
      args: [],
    );
  }

  /// `Subject request rejected`
  String get adminSubjectRequestRejectedSuccess {
    return Intl.message(
      'Subject request rejected',
      name: 'adminSubjectRequestRejectedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Requested at`
  String get adminSubjectRequestRequestedAt {
    return Intl.message(
      'Requested at',
      name: 'adminSubjectRequestRequestedAt',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get adminSubjectRequestPrice {
    return Intl.message(
      'Price',
      name: 'adminSubjectRequestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Reference number (optional)`
  String get adminSubjectRequestReferenceNumber {
    return Intl.message(
      'Reference number (optional)',
      name: 'adminSubjectRequestReferenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Payment notes (optional)`
  String get adminSubjectRequestPaymentNotes {
    return Intl.message(
      'Payment notes (optional)',
      name: 'adminSubjectRequestPaymentNotes',
      desc: '',
      args: [],
    );
  }

  /// `Amount (optional)`
  String get adminSubjectRequestAmountOptional {
    return Intl.message(
      'Amount (optional)',
      name: 'adminSubjectRequestAmountOptional',
      desc: '',
      args: [],
    );
  }

  /// `Payment method (optional)`
  String get adminSubjectRequestMethodOptional {
    return Intl.message(
      'Payment method (optional)',
      name: 'adminSubjectRequestMethodOptional',
      desc: '',
      args: [],
    );
  }

  /// `File saved successfully`
  String get fileSavedSuccessfully {
    return Intl.message(
      'File saved successfully',
      name: 'fileSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Certificate saved successfully`
  String get certificateSavedSuccessfully {
    return Intl.message(
      'Certificate saved successfully',
      name: 'certificateSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Saving file...`
  String get savingFile {
    return Intl.message(
      'Saving file...',
      name: 'savingFile',
      desc: '',
      args: [],
    );
  }

  /// `Saving certificate...`
  String get savingCertificate {
    return Intl.message(
      'Saving certificate...',
      name: 'savingCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message('Try again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Saved in: {location}`
  String savedInLocation(Object location) {
    return Intl.message(
      'Saved in: $location',
      name: 'savedInLocation',
      desc: '',
      args: [location],
    );
  }

  /// `Open`
  String get openAction {
    return Intl.message('Open', name: 'openAction', desc: '', args: []);
  }

  /// `Notification settings`
  String get notificationSettings {
    return Intl.message(
      'Notification settings',
      name: 'notificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markAllNotificationsRead {
    return Intl.message(
      'Mark all as read',
      name: 'markAllNotificationsRead',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotificationsYet {
    return Intl.message(
      'No notifications yet',
      name: 'noNotificationsYet',
      desc: '',
      args: [],
    );
  }

  /// `We will let you know when there is an update`
  String get notificationsEmptySubtitle {
    return Intl.message(
      'We will let you know when there is an update',
      name: 'notificationsEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get notificationNow {
    return Intl.message('Now', name: 'notificationNow', desc: '', args: []);
  }

  /// `{count} minutes ago`
  String notificationMinutesAgo(int count) {
    return Intl.message(
      '$count minutes ago',
      name: 'notificationMinutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `An hour ago`
  String get notificationHourAgo {
    return Intl.message(
      'An hour ago',
      name: 'notificationHourAgo',
      desc: '',
      args: [],
    );
  }

  /// `{count} hours ago`
  String notificationHoursAgo(int count) {
    return Intl.message(
      '$count hours ago',
      name: 'notificationHoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Notification categories`
  String get notificationCategories {
    return Intl.message(
      'Notification categories',
      name: 'notificationCategories',
      desc: '',
      args: [],
    );
  }

  /// `Notification channels`
  String get notificationChannels {
    return Intl.message(
      'Notification channels',
      name: 'notificationChannels',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get notificationChat {
    return Intl.message('Chats', name: 'notificationChat', desc: '', args: []);
  }

  /// `Academic`
  String get notificationAcademic {
    return Intl.message(
      'Academic',
      name: 'notificationAcademic',
      desc: '',
      args: [],
    );
  }

  /// `Payments and subscriptions`
  String get notificationFinance {
    return Intl.message(
      'Payments and subscriptions',
      name: 'notificationFinance',
      desc: '',
      args: [],
    );
  }

  /// `Announcements`
  String get notificationAnnouncements {
    return Intl.message(
      'Announcements',
      name: 'notificationAnnouncements',
      desc: '',
      args: [],
    );
  }

  /// `Administration`
  String get notificationAdmin {
    return Intl.message(
      'Administration',
      name: 'notificationAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Supervision`
  String get notificationSupervisor {
    return Intl.message(
      'Supervision',
      name: 'notificationSupervisor',
      desc: '',
      args: [],
    );
  }

  /// `Device notifications`
  String get notificationPush {
    return Intl.message(
      'Device notifications',
      name: 'notificationPush',
      desc: '',
      args: [],
    );
  }

  /// `In-app notifications`
  String get notificationInApp {
    return Intl.message(
      'In-app notifications',
      name: 'notificationInApp',
      desc: '',
      args: [],
    );
  }

  /// `Conversation`
  String get chatTitleFallback {
    return Intl.message(
      'Conversation',
      name: 'chatTitleFallback',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactUs {
    return Intl.message('Contact us', name: 'contactUs', desc: '', args: []);
  }

  /// `Search conversations`
  String get searchConversations {
    return Intl.message(
      'Search conversations',
      name: 'searchConversations',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get supportBadge {
    return Intl.message('Support', name: 'supportBadge', desc: '', args: []);
  }

  /// `selected`
  String get selectedMessagesLabel {
    return Intl.message(
      'selected',
      name: 'selectedMessagesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this message?`
  String get deleteMessageQuestion {
    return Intl.message(
      'Do you want to delete this message?',
      name: 'deleteMessageQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete the selected messages?`
  String get deleteSelectedMessagesQuestion {
    return Intl.message(
      'Do you want to delete the selected messages?',
      name: 'deleteSelectedMessagesQuestion',
      desc: '',
      args: [],
    );
  }

  /// `This message was deleted`
  String get deletedMessage {
    return Intl.message(
      'This message was deleted',
      name: 'deletedMessage',
      desc: '',
      args: [],
    );
  }

  /// `New messages`
  String get newMessages {
    return Intl.message(
      'New messages',
      name: 'newMessages',
      desc: '',
      args: [],
    );
  }

  /// `Review request`
  String get reviewRequest {
    return Intl.message(
      'Review request',
      name: 'reviewRequest',
      desc: '',
      args: [],
    );
  }

  /// `Submit registration request`
  String get submitRegistrationRequest {
    return Intl.message(
      'Submit registration request',
      name: 'submitRegistrationRequest',
      desc: '',
      args: [],
    );
  }

  /// `Your registration request was sent successfully. It is pending review and the account will be activated after administration approval.`
  String get registrationRequestSuccessMessage {
    return Intl.message(
      'Your registration request was sent successfully. It is pending review and the account will be activated after administration approval.',
      name: 'registrationRequestSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your registration request was sent successfully and will be reviewed by the administration. You can log in after the request is approved.`
  String get egyptianStudentRegistrationSuccessMessage {
    return Intl.message(
      'Your registration request was sent successfully and will be reviewed by the administration. You can log in after the request is approved.',
      name: 'egyptianStudentRegistrationSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Study has not started yet`
  String get studyNotStarted {
    return Intl.message(
      'Study has not started yet',
      name: 'studyNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `A lesson cannot be added in a previous week`
  String get cannotAddLessonInPreviousWeek {
    return Intl.message(
      'A lesson cannot be added in a previous week',
      name: 'cannotAddLessonInPreviousWeek',
      desc: '',
      args: [],
    );
  }

  /// `A lesson cannot be added on a past date`
  String get scheduleDateInPast {
    return Intl.message(
      'A lesson cannot be added on a past date',
      name: 'scheduleDateInPast',
      desc: '',
      args: [],
    );
  }

  /// `A lesson cannot be added at a past time`
  String get scheduleTimeInPast {
    return Intl.message(
      'A lesson cannot be added at a past time',
      name: 'scheduleTimeInPast',
      desc: '',
      args: [],
    );
  }

  /// `No subjects have been added to this classroom.`
  String get noSubjectsInClassroom {
    return Intl.message(
      'No subjects have been added to this classroom.',
      name: 'noSubjectsInClassroom',
      desc: '',
      args: [],
    );
  }

  /// `Call student`
  String get callStudentAlert {
    return Intl.message(
      'Call student',
      name: 'callStudentAlert',
      desc: '',
      args: [],
    );
  }

  /// `The student alert was sent successfully`
  String get studentCallAlertSent {
    return Intl.message(
      'The student alert was sent successfully',
      name: 'studentCallAlertSent',
      desc: '',
      args: [],
    );
  }

  /// `The alert was already sent. Try again shortly`
  String get studentCallAlertCooldown {
    return Intl.message(
      'The alert was already sent. Try again shortly',
      name: 'studentCallAlertCooldown',
      desc: '',
      args: [],
    );
  }

  /// `Your supervisor is calling you`
  String get studentCallAlertTitle {
    return Intl.message(
      'Your supervisor is calling you',
      name: 'studentCallAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open Bnan to respond to your supervisor`
  String get studentCallAlertBody {
    return Intl.message(
      'Open Bnan to respond to your supervisor',
      name: 'studentCallAlertBody',
      desc: '',
      args: [],
    );
  }

  /// `Saved accounts`
  String get savedAccounts {
    return Intl.message(
      'Saved accounts',
      name: 'savedAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Choose an account to continue`
  String get chooseSavedAccount {
    return Intl.message(
      'Choose an account to continue',
      name: 'chooseSavedAccount',
      desc: '',
      args: [],
    );
  }

  /// `No saved accounts on this device`
  String get noSavedAccounts {
    return Intl.message(
      'No saved accounts on this device',
      name: 'noSavedAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Log in with another account`
  String get loginWithAnotherAccount {
    return Intl.message(
      'Log in with another account',
      name: 'loginWithAnotherAccount',
      desc: '',
      args: [],
    );
  }

  /// `Remove account from this device`
  String get removeAccountFromDevice {
    return Intl.message(
      'Remove account from this device',
      name: 'removeAccountFromDevice',
      desc: '',
      args: [],
    );
  }

  /// `Request teacher change / discontinuation`
  String get requestTeacherChangeOrCancellation {
    return Intl.message(
      'Request teacher change / discontinuation',
      name: 'requestTeacherChangeOrCancellation',
      desc: '',
      args: [],
    );
  }

  /// `Request withdrawal from teaching`
  String get requestTeacherWithdrawal {
    return Intl.message(
      'Request withdrawal from teaching',
      name: 'requestTeacherWithdrawal',
      desc: '',
      args: [],
    );
  }

  /// `Request reason`
  String get requestReason {
    return Intl.message(
      'Request reason',
      name: 'requestReason',
      desc: '',
      args: [],
    );
  }

  /// `Your request was submitted successfully`
  String get changeRequestSubmitted {
    return Intl.message(
      'Your request was submitted successfully',
      name: 'changeRequestSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation requests`
  String get cancellationRequests {
    return Intl.message(
      'Cancellation requests',
      name: 'cancellationRequests',
      desc: '',
      args: [],
    );
  }

  /// `No cancellation or teacher-change requests`
  String get changeRequestsEmpty {
    return Intl.message(
      'No cancellation or teacher-change requests',
      name: 'changeRequestsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Requester`
  String get requester {
    return Intl.message('Requester', name: 'requester', desc: '', args: []);
  }

  /// `Requester type`
  String get requesterType {
    return Intl.message(
      'Requester type',
      name: 'requesterType',
      desc: '',
      args: [],
    );
  }

  /// `Request type`
  String get requestType {
    return Intl.message(
      'Request type',
      name: 'requestType',
      desc: '',
      args: [],
    );
  }

  /// `Change teacher`
  String get changeTeacherRequestType {
    return Intl.message(
      'Change teacher',
      name: 'changeTeacherRequestType',
      desc: '',
      args: [],
    );
  }

  /// `Cancel subject`
  String get cancelSubjectRequestType {
    return Intl.message(
      'Cancel subject',
      name: 'cancelSubjectRequestType',
      desc: '',
      args: [],
    );
  }

  /// `Teacher withdrawal`
  String get teacherWithdrawalRequestType {
    return Intl.message(
      'Teacher withdrawal',
      name: 'teacherWithdrawalRequestType',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get changeRequestPending {
    return Intl.message(
      'Pending',
      name: 'changeRequestPending',
      desc: '',
      args: [],
    );
  }

  /// `Approved`
  String get changeRequestApproved {
    return Intl.message(
      'Approved',
      name: 'changeRequestApproved',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get changeRequestRejected {
    return Intl.message(
      'Rejected',
      name: 'changeRequestRejected',
      desc: '',
      args: [],
    );
  }

  /// `Approve request`
  String get approveRequest {
    return Intl.message(
      'Approve request',
      name: 'approveRequest',
      desc: '',
      args: [],
    );
  }

  /// `Reject request`
  String get rejectRequest {
    return Intl.message(
      'Reject request',
      name: 'rejectRequest',
      desc: '',
      args: [],
    );
  }

  /// `Admin notes (optional)`
  String get adminNotes {
    return Intl.message(
      'Admin notes (optional)',
      name: 'adminNotes',
      desc: '',
      args: [],
    );
  }

  /// `Rejection reason`
  String get rejectionReason {
    return Intl.message(
      'Rejection reason',
      name: 'rejectionReason',
      desc: '',
      args: [],
    );
  }

  /// `Request approved successfully`
  String get changeRequestApprovedSuccess {
    return Intl.message(
      'Request approved successfully',
      name: 'changeRequestApprovedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Request rejected successfully`
  String get changeRequestRejectedSuccess {
    return Intl.message(
      'Request rejected successfully',
      name: 'changeRequestRejectedSuccess',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
