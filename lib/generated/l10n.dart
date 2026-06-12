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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
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
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Login',
      name: 'loginNow',
      desc: '',
      args: [],
    );
  }

  /// `Curricula`
  String get curricula {
    return Intl.message(
      'Curricula',
      name: 'curricula',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Choose the suitable curriculum for your children and start the learning journey with us`
  String get chooseCurriculum {
    return Intl.message(
      'Choose the suitable curriculum for your children and start the learning journey with us',
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
    return Intl.message(
      'Packages',
      name: 'packages',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Packages',
      name: 'Packages',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Currency:',
      name: 'currency',
      desc: '',
      args: [],
    );
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

  /// `Parent name`
  String get parentName {
    return Intl.message(
      'Parent name',
      name: 'parentName',
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
    return Intl.message(
      'Curriculum',
      name: 'curriculum',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Grade',
      name: 'grade',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Subjects',
      name: 'subjects',
      desc: '',
      args: [],
    );
  }

  /// `Math`
  String get math {
    return Intl.message(
      'Math',
      name: 'math',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get science {
    return Intl.message(
      'Science',
      name: 'science',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Physics',
      name: 'physics',
      desc: '',
      args: [],
    );
  }

  /// `Chemistry`
  String get chemistry {
    return Intl.message(
      'Chemistry',
      name: 'chemistry',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Quran',
      name: 'quran',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Apple Pay',
      name: 'applePay',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card`
  String get creditCard {
    return Intl.message(
      'Credit Card',
      name: 'creditCard',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Card number',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Expiry date',
      name: 'expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get cvv {
    return Intl.message(
      'CVV',
      name: 'cvv',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'SAR',
      name: 'sarShort',
      desc: '',
      args: [],
    );
  }

  /// `student`
  String get student {
    return Intl.message(
      'student',
      name: 'student',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Resend code?`
  String get resendCode {
    return Intl.message(
      'Resend code?',
      name: 'resendCode',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Start now',
      name: 'startNow',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Assignments`
  String get assignments {
    return Intl.message(
      'Assignments',
      name: 'assignments',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get myAccount {
    return Intl.message(
      'My Account',
      name: 'myAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcomeYou {
    return Intl.message(
      'Welcome',
      name: 'welcomeYou',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get dashboard {
    return Intl.message(
      'Home',
      name: 'dashboard',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'My Groups',
      name: 'myGroups',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Interaction',
      name: 'interaction',
      desc: '',
      args: [],
    );
  }

  /// `Attendance`
  String get attendance {
    return Intl.message(
      'Attendance',
      name: 'attendance',
      desc: '',
      args: [],
    );
  }

  /// `95%`
  String get attendancePercent {
    return Intl.message(
      '95%',
      name: 'attendancePercent',
      desc: '',
      args: [],
    );
  }

  /// `4.8`
  String get interactionRate {
    return Intl.message(
      '4.8',
      name: 'interactionRate',
      desc: '',
      args: [],
    );
  }

  /// `12`
  String get certificatesCount {
    return Intl.message(
      '12',
      name: 'certificatesCount',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'View all',
      name: 'viewAll',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
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

  /// `New`
  String get newBadge {
    return Intl.message(
      'New',
      name: 'newBadge',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Due Friday',
      name: 'dueFriday',
      desc: '',
      args: [],
    );
  }

  /// `Due Sunday`
  String get dueSunday {
    return Intl.message(
      'Due Sunday',
      name: 'dueSunday',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Mark as read',
      name: 'markAsRead',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `2 days ago`
  String get twoDaysAgo {
    return Intl.message(
      '2 days ago',
      name: 'twoDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `3 days ago`
  String get threeDaysAgo {
    return Intl.message(
      '3 days ago',
      name: 'threeDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `4 days ago`
  String get fourDaysAgo {
    return Intl.message(
      '4 days ago',
      name: 'fourDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get pending {
    return Intl.message(
      'In Progress',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Submitted',
      name: 'noSubmission',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'April 2026',
      name: 'april2026',
      desc: '',
      args: [],
    );
  }

  /// `March 2026`
  String get march2026 {
    return Intl.message(
      'March 2026',
      name: 'march2026',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Math`
  String get mathShort {
    return Intl.message(
      'Math',
      name: 'mathShort',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Excellent',
      name: 'excellent',
      desc: '',
      args: [],
    );
  }

  /// `Absent`
  String get absent {
    return Intl.message(
      'Absent',
      name: 'absent',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Online now`
  String get onlineNow {
    return Intl.message(
      'Online now',
      name: 'onlineNow',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Congrats!',
      name: 'congrats',
      desc: '',
      args: [],
    );
  }

  /// `Choose grade`
  String get chooseGrade {
    return Intl.message(
      'Choose grade',
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
    return Intl.message(
      'Biology',
      name: 'biology',
      desc: '',
      args: [],
    );
  }

  /// `My requests`
  String get myRequests {
    return Intl.message(
      'My requests',
      name: 'myRequests',
      desc: '',
      args: [],
    );
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

  /// `معلومات الاتصال`
  String get contactInfo {
    return Intl.message(
      'معلومات الاتصال',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `اسم المستخدم`
  String get userName {
    return Intl.message(
      'اسم المستخدم',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `الخصوصية`
  String get privacy {
    return Intl.message(
      'الخصوصية',
      name: 'privacy',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'InActive',
      name: 'inactive',
      desc: '',
      args: [],
    );
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
