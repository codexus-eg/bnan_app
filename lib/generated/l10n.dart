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
    return Intl.message(
      'points',
      name: 'pointsCount',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Students',
      name: 'students',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get classes {
    return Intl.message(
      'Classes',
      name: 'classes',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Dues`
  String get dues {
    return Intl.message(
      'Dues',
      name: 'dues',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Evaluations',
      name: 'evaluations',
      desc: '',
      args: [],
    );
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

  /// `Performance`
  String get performance {
    return Intl.message(
      'Performance',
      name: 'performance',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Active',
      name: 'active2',
      desc: '',
      args: [],
    );
  }

  /// `Submitted`
  String get submitted {
    return Intl.message(
      'Submitted',
      name: 'submitted',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Title',
      name: 'assignmentTitle',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Classroom',
      name: 'classRoom',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Choose file',
      name: 'chooseFile',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Graded',
      name: 'graded',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Edit Grade',
      name: 'editGrade',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Degree',
      name: 'degree',
      desc: '',
      args: [],
    );
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

  /// `Sections`
  String get sections {
    return Intl.message(
      'Sections',
      name: 'sections',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get classR {
    return Intl.message(
      'Class',
      name: 'classR',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Sent`
  String get send {
    return Intl.message(
      'Sent',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Groups`
  String get groups {
    return Intl.message(
      'Groups',
      name: 'groups',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get nationality {
    return Intl.message(
      'Nationality',
      name: 'nationality',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Grade',
      name: 'graduationGrade',
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
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Good',
      name: 'good',
      desc: '',
      args: [],
    );
  }

  /// `Very Good`
  String get veryGood {
    return Intl.message(
      'Very Good',
      name: 'veryGood',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Expected',
      name: 'expected',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Paid',
      name: 'paymentCompleted',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Pending',
      name: 'pendingWaiting',
      desc: '',
      args: [],
    );
  }

  /// `Sessions`
  String get sessions {
    return Intl.message(
      'Sessions',
      name: 'sessions',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Rewards',
      name: 'rewards',
      desc: '',
      args: [],
    );
  }

  /// `Deductions`
  String get discounts {
    return Intl.message(
      'Deductions',
      name: 'discounts',
      desc: '',
      args: [],
    );
  }

  /// `Net Amount`
  String get netAmount {
    return Intl.message(
      'Net Amount',
      name: 'netAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid On`
  String get paymentDoneOn {
    return Intl.message(
      'Paid On',
      name: 'paymentDoneOn',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Lessons',
      name: 'lessons',
      desc: '',
      args: [],
    );
  }

  /// `Absence`
  String get absence {
    return Intl.message(
      'Absence',
      name: 'absence',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Point`
  String get point {
    return Intl.message(
      'Point',
      name: 'point',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Classes',
      name: 'classesCount',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Salary`
  String get salary {
    return Intl.message(
      'Salary',
      name: 'salary',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Ranking`
  String get ranking {
    return Intl.message(
      'Ranking',
      name: 'ranking',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Week Start',
      name: 'weekStart',
      desc: '',
      args: [],
    );
  }

  /// `Behavior`
  String get behavior {
    return Intl.message(
      'Behavior',
      name: 'behavior',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notesText {
    return Intl.message(
      'Notes',
      name: 'notesText',
      desc: '',
      args: [],
    );
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

  /// `Home`
  String get parentHomeTitle {
    return Intl.message(
      'Home',
      name: 'parentHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get parentWelcome {
    return Intl.message(
      'Welcome',
      name: 'parentWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get parentGuardian {
    return Intl.message(
      'Parent',
      name: 'parentGuardian',
      desc: '',
      args: [],
    );
  }

  /// `Children`
  String get parentChildren {
    return Intl.message(
      'Children',
      name: 'parentChildren',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Schedule',
      name: 'parentSchedule',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Messages',
      name: 'parentMessages',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Renew',
      name: 'parentRenew',
      desc: '',
      args: [],
    );
  }

  /// `Show All`
  String get parentShowAll {
    return Intl.message(
      'Show All',
      name: 'parentShowAll',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Teachers',
      name: 'teachers',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'EGP',
      name: 'egpShort',
      desc: '',
      args: [],
    );
  }

  /// `Revenues`
  String get revenues {
    return Intl.message(
      'Revenues',
      name: 'revenues',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Net`
  String get net {
    return Intl.message(
      'Net',
      name: 'net',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Saudi Riyal',
      name: 'saudiRiyal',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Messages',
      name: 'messages',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Users',
      name: 'adminUsers',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Add User',
      name: 'addUser',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Add New User',
      name: 'addNewUser',
      desc: '',
      args: [],
    );
  }

  /// `Edit Data`
  String get editData {
    return Intl.message(
      'Edit Data',
      name: 'editData',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'User Role',
      name: 'userRole',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Parent',
      name: 'parent',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get parentRole {
    return Intl.message(
      'Parent',
      name: 'parentRole',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor`
  String get supervisor {
    return Intl.message(
      'Supervisor',
      name: 'supervisor',
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
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get disable {
    return Intl.message(
      'Disable',
      name: 'disable',
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

  /// `Add New Chapter`
  String get addNewChapter {
    return Intl.message(
      'Add New Chapter',
      name: 'addNewChapter',
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
