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

  /// `Forgot Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and we will send you a reset link`
  String get forgotPasswordSubtitle {
    return Intl.message(
      'Enter your email and we will send you a reset link',
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

  /// `Send reset link`
  String get sendResetLink {
    return Intl.message(
      'Send reset link',
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

  /// `Student username`
  String get studentUsername {
    return Intl.message(
      'Student username',
      name: 'studentUsername',
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

  /// `4-hour package`
  String get package4Hours {
    return Intl.message(
      '4-hour package',
      name: 'package4Hours',
      desc: '',
      args: [],
    );
  }

  /// `{price} SAR`
  String packagePrice(Object price) {
    return Intl.message(
      '$price SAR',
      name: 'packagePrice',
      desc: '',
      args: [price],
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

  /// `Pay with Tamara`
  String get tabbyTamara {
    return Intl.message(
      'Pay with Tamara',
      name: 'tabbyTamara',
      desc: '',
      args: [],
    );
  }

  /// `Go to payment`
  String get goToPayment {
    return Intl.message(
      'Go to payment',
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
