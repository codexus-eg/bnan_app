// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(price) => "SAR ${price}";

  static String m1(statusCode) => "Unknown status code: ${statusCode}";

  static String m2(hours) => "${hours} Hours";

  static String m3(price) => "SAR ${price}";

  static String m4(price, studentsCount, total) =>
      "${price} SAR × ${studentsCount} student = ${total} SAR";

  static String m5(hours) => "${hours} hours remaining";

  static String m6(email) =>
      "Check your email ${email} and follow the instructions to reset your password.";

  static String m7(amount) => "Save SAR ${amount}";

  static String m8(hours) => "${hours} training hours";

  static String m9(used, total) => "${used} of ${total} used";

  static String m10(count) => "${count} weekly lessons";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Packages": MessageLookupByLibrary.simpleMessage("Packages"),
        "PackagesandSubscriptions":
            MessageLookupByLibrary.simpleMessage("Packages and Subscriptions"),
        "active": MessageLookupByLibrary.simpleMessage("Active"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account? "),
        "applePay": MessageLookupByLibrary.simpleMessage("Apple Pay"),
        "applyAsTeacher":
            MessageLookupByLibrary.simpleMessage("Apply as Teacher"),
        "applyAsTeacherSubtitle": MessageLookupByLibrary.simpleMessage(
            "Share your expertise and join our teaching team"),
        "arabicLanguage":
            MessageLookupByLibrary.simpleMessage("Arabic Language"),
        "assignments": MessageLookupByLibrary.simpleMessage("Assignments"),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "availableDay": MessageLookupByLibrary.simpleMessage("Available day"),
        "backToLogin": MessageLookupByLibrary.simpleMessage("Back to login"),
        "browseSection": MessageLookupByLibrary.simpleMessage("Browse section"),
        "canChangeCurrency": MessageLookupByLibrary.simpleMessage(
            "You can change the currency from the list"),
        "cardHolderName":
            MessageLookupByLibrary.simpleMessage("Cardholder name"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("Card number"),
        "certificates": MessageLookupByLibrary.simpleMessage("Certificates"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "checkYourEmailPrefix":
            MessageLookupByLibrary.simpleMessage("Check your email "),
        "chemistry": MessageLookupByLibrary.simpleMessage("Chemistry"),
        "chooseAccountType": MessageLookupByLibrary.simpleMessage(
            "Choose account type to continue"),
        "chooseCurriculum": MessageLookupByLibrary.simpleMessage(
            "Choose the suitable curriculum for your children and start the learning journey with us"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmNewPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "confirmPasswordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Confirm password cannot be empty."),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
        "createNewAccount":
            MessageLookupByLibrary.simpleMessage("Create New Account"),
        "creditCard": MessageLookupByLibrary.simpleMessage("Credit Card"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency:"),
        "currentPrice": m0,
        "curricula": MessageLookupByLibrary.simpleMessage("Curricula"),
        "curriculum": MessageLookupByLibrary.simpleMessage("Curriculum"),
        "curriculumSelection":
            MessageLookupByLibrary.simpleMessage("Curriculum Selection"),
        "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Home"),
        "doNotHaveAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account? "),
        "egpCurrency":
            MessageLookupByLibrary.simpleMessage("Egyptian Pound (EGP)"),
        "egyptianCurriculum":
            MessageLookupByLibrary.simpleMessage("Egyptian Curriculum"),
        "egyptianCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "Integrated education for primary, preparatory, and secondary grades according to the modern Egyptian curriculum."),
        "eightHoursPlan":
            MessageLookupByLibrary.simpleMessage("8-hour package"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Email cannot be empty."),
        "errorBadCertificate":
            MessageLookupByLibrary.simpleMessage("Untrusted SSL certificate."),
        "errorBadRequest": MessageLookupByLibrary.simpleMessage("Bad request."),
        "errorCancel":
            MessageLookupByLibrary.simpleMessage("Request was cancelled."),
        "errorConnectionTimeout":
            MessageLookupByLibrary.simpleMessage("Connection timed out."),
        "errorForbidden":
            MessageLookupByLibrary.simpleMessage("Access denied."),
        "errorInternalServer":
            MessageLookupByLibrary.simpleMessage("Internal server error."),
        "errorNoInternet":
            MessageLookupByLibrary.simpleMessage("No internet connection."),
        "errorNotFound":
            MessageLookupByLibrary.simpleMessage("Item not found."),
        "errorReceiveTimeout":
            MessageLookupByLibrary.simpleMessage("Receive timeout occurred."),
        "errorSendTimeout":
            MessageLookupByLibrary.simpleMessage("Send timeout occurred."),
        "errorUnauthorized":
            MessageLookupByLibrary.simpleMessage("Session expired."),
        "errorUnknown": MessageLookupByLibrary.simpleMessage(
            "An unexpected error occurred."),
        "errorUnknownStatusCode": m1,
        "expiryDate": MessageLookupByLibrary.simpleMessage("Expiry date"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "forgotPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "Enter your email and we will send you a reset code"),
        "forgotPasswordTitle":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "fourHoursPlan": MessageLookupByLibrary.simpleMessage("4-hour package"),
        "from": MessageLookupByLibrary.simpleMessage("From"),
        "goToPayment":
            MessageLookupByLibrary.simpleMessage("Proceed to Payment"),
        "grade": MessageLookupByLibrary.simpleMessage("Grade"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "hoursPackage": m2,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginNow": MessageLookupByLibrary.simpleMessage("Login"),
        "loginWelcomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "Log in to access your dashboard"),
        "loginWelcomeTitle": MessageLookupByLibrary.simpleMessage("Welcome"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "math": MessageLookupByLibrary.simpleMessage("Math"),
        "mostPopular": MessageLookupByLibrary.simpleMessage("Most popular"),
        "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
        "myGroups": MessageLookupByLibrary.simpleMessage("My Groups"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Name cannot be empty."),
        "nameMinLength": MessageLookupByLibrary.simpleMessage(
            "Name must be at least 3 characters."),
        "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "notes":
            MessageLookupByLibrary.simpleMessage("Additional notes or details"),
        "notesHint": MessageLookupByLibrary.simpleMessage(
            "Example: every Monday and Wednesday at 5 PM"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "oldPrice": m3,
        "onboardingSubtitle1": MessageLookupByLibrary.simpleMessage(
            "An educational platform that helps you develop your skills"),
        "onboardingSubtitle2": MessageLookupByLibrary.simpleMessage(
            "Enjoy a flexible learning experience that fits your day and style"),
        "onboardingSubtitle3": MessageLookupByLibrary.simpleMessage(
            "Interactive content that helps you learn in a more enjoyable way"),
        "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
            "Start your learning journey easily"),
        "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
            "Interactive lessons and engaging content"),
        "onboardingTitle3":
            MessageLookupByLibrary.simpleMessage("Success starts here"),
        "optional": MessageLookupByLibrary.simpleMessage("Optional"),
        "package4Hours": MessageLookupByLibrary.simpleMessage("4-hour package"),
        "packageCalculation": m4,
        "packageDetails":
            MessageLookupByLibrary.simpleMessage("Package Details"),
        "packageExpiryText": MessageLookupByLibrary.simpleMessage(
            "Expires in 18 days. Auto renewal"),
        "packages": MessageLookupByLibrary.simpleMessage("Packages"),
        "parentInfo":
            MessageLookupByLibrary.simpleMessage("Parent Information"),
        "parentName": MessageLookupByLibrary.simpleMessage("Parent name"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty."),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("At least 6 characters"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters."),
        "passwordMustHaveNumber": MessageLookupByLibrary.simpleMessage(
            "Password must contain at least one number."),
        "passwordMustHaveUpperCase": MessageLookupByLibrary.simpleMessage(
            "Password must contain at least one uppercase letter."),
        "passwordWillBeUsed": MessageLookupByLibrary.simpleMessage(
            "You will use it to log in with your email after completing payment."),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match."),
        "paymentInfo":
            MessageLookupByLibrary.simpleMessage("Payment Information"),
        "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone number"),
        "physics": MessageLookupByLibrary.simpleMessage("Physics"),
        "pleaseFillRequiredInfo": MessageLookupByLibrary.simpleMessage(
            "Please fill in all required fields"),
        "preferredDays":
            MessageLookupByLibrary.simpleMessage("Preferred student schedule"),
        "preferredDaysHint": MessageLookupByLibrary.simpleMessage(
            "Select preferred days and times"),
        "previous": MessageLookupByLibrary.simpleMessage("Previous"),
        "primaryGradeFive":
            MessageLookupByLibrary.simpleMessage("Grade 5 Primary"),
        "qarCurrency":
            MessageLookupByLibrary.simpleMessage("Qatari Riyal (QAR)"),
        "qatariCurriculum":
            MessageLookupByLibrary.simpleMessage("Qatari Curriculum"),
        "qatariCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "A curriculum approved by the Ministry of Education in Qatar, covering basic stages up to secondary school."),
        "quran": MessageLookupByLibrary.simpleMessage("Quran"),
        "registerAsParent":
            MessageLookupByLibrary.simpleMessage("Register as Parent"),
        "registerAsParentSubtitle": MessageLookupByLibrary.simpleMessage(
            "Track your children’s progress and contact teachers"),
        "registerAsStudent":
            MessageLookupByLibrary.simpleMessage("Register as Student"),
        "registerAsStudentSubtitle": MessageLookupByLibrary.simpleMessage(
            "Join classes and start your learning journey"),
        "remainingHours": m5,
        "requestNewLesson":
            MessageLookupByLibrary.simpleMessage("Request New Lesson"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend code?"),
        "resetCodeSubtitle": MessageLookupByLibrary.simpleMessage(
            "Check your email and enter the code sent to you"),
        "resetPasswordInstructions": MessageLookupByLibrary.simpleMessage(
            " and follow the instructions to reset your password."),
        "resetPasswordSuccessSubtitle": m6,
        "resetPasswordSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Sent successfully"),
        "reviews": MessageLookupByLibrary.simpleMessage("Reviews"),
        "sarCurrency":
            MessageLookupByLibrary.simpleMessage("Saudi Riyal (SAR)"),
        "sarShort": MessageLookupByLibrary.simpleMessage("SAR"),
        "saudiCurriculum":
            MessageLookupByLibrary.simpleMessage("Saudi Curriculum"),
        "saudiCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "We provide all subjects for primary, middle, and secondary stages according to the approved curriculum."),
        "saveAmount": m7,
        "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
        "science": MessageLookupByLibrary.simpleMessage("Science"),
        "selectGrade": MessageLookupByLibrary.simpleMessage("Select grade"),
        "selectedPackage":
            MessageLookupByLibrary.simpleMessage("Selected Package"),
        "sendResetCode":
            MessageLookupByLibrary.simpleMessage("Send reset code"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("Send reset Code"),
        "services": MessageLookupByLibrary.simpleMessage("Services"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "socialStudies": MessageLookupByLibrary.simpleMessage("Social Studies"),
        "startLessonViaZoom":
            MessageLookupByLibrary.simpleMessage("Start lesson via Zoom"),
        "startNow": MessageLookupByLibrary.simpleMessage("Start now"),
        "student": MessageLookupByLibrary.simpleMessage("student"),
        "studentInfo":
            MessageLookupByLibrary.simpleMessage("Student Information"),
        "studentName": MessageLookupByLibrary.simpleMessage("Student name"),
        "studentNotesAndSchedule": MessageLookupByLibrary.simpleMessage(
            "Student notes and schedule preferences"),
        "studentNotesAndScheduleHint": MessageLookupByLibrary.simpleMessage(
            "Notes about lessons that need explanation, goals, or any other comments"),
        "studentNotesExample": MessageLookupByLibrary.simpleMessage(
            "Example: Needs explanation for fractions and long division ..."),
        "studentPassword":
            MessageLookupByLibrary.simpleMessage("Student platform password"),
        "studentPasswordField":
            MessageLookupByLibrary.simpleMessage("Student password"),
        "studentRegistrationForm":
            MessageLookupByLibrary.simpleMessage("Student Registration Form"),
        "studentUsername":
            MessageLookupByLibrary.simpleMessage("Student username"),
        "studentUsesItForDashboard": MessageLookupByLibrary.simpleMessage(
            "The student will use it to log in to the dashboard"),
        "studyCurriculaTitle":
            MessageLookupByLibrary.simpleMessage("Study Curricula "),
        "studyMaterials":
            MessageLookupByLibrary.simpleMessage("Study Materials"),
        "subjects": MessageLookupByLibrary.simpleMessage("Subjects"),
        "subscribeNow": MessageLookupByLibrary.simpleMessage("Subscribe now"),
        "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
        "subscriptions": MessageLookupByLibrary.simpleMessage("Subscriptions"),
        "tabbyTamara":
            MessageLookupByLibrary.simpleMessage("Split your bill with Tamara"),
        "to": MessageLookupByLibrary.simpleMessage("To"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "trainingHours": m8,
        "twelveHoursPlan":
            MessageLookupByLibrary.simpleMessage("12-hour package"),
        "twentyHoursPlan":
            MessageLookupByLibrary.simpleMessage("20-hour package"),
        "upcomingLesson":
            MessageLookupByLibrary.simpleMessage("Upcoming Lesson"),
        "upgradePackage":
            MessageLookupByLibrary.simpleMessage("Upgrade Package"),
        "usedHours": m9,
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "weeklyLessons": m10,
        "welcomeYou": MessageLookupByLibrary.simpleMessage("Welcome"),
        "whatsappNumber":
            MessageLookupByLibrary.simpleMessage("WhatsApp number"),
        "withTeacher":
            MessageLookupByLibrary.simpleMessage("With Ms. Sarah Abdullah")
      };
}
