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

  static String m0(name) => "Assign ${name} to a classroom";

  static String m1(teacherName) => "Assign ${teacherName} to Subject";

  static String m2(grade) => "Attendance for ${grade}";

  static String m3(percent) => "Average ${percent}%";

  static String m4(gradeName, subjectName) =>
      "Do you want to cancel assigning this teacher to ${gradeName} - ${subjectName}?";

  static String m5(classroomName) =>
      "Do you want to remove this supervisor from ${classroomName}?";

  static String m6(classroomName) =>
      "Do you want to remove this teacher from ${classroomName}?";

  static String m7(price) => "SAR ${price}";

  static String m8(days) => "${days} Days Package";

  static String m9(name) => "Do you want to disable ${name}\'s account?";

  static String m10(statusCode) => "Unknown status code: ${statusCode}";

  static String m11(fieldName) => "Please enter ${fieldName}";

  static String m12(grade) => "Grade: ${grade}";

  static String m13(count) => "${count} Grades";

  static String m14(hours) => "${hours} Hours";

  static String m15(month) => "${month} Certificate";

  static String m16(teachers, points) =>
      "Next rank after ${teachers} teachers, ${points} points to the next level";

  static String m17(count) => "${count} hours ago";

  static String m18(count) => "${count} minutes ago";

  static String m19(price) => "SAR ${price}";

  static String m20(price, studentsCount, total) =>
      "${price} SAR × ${studentsCount} student = ${total} SAR";

  static String m21(count) =>
      "${count} session(s) were excluded because their duration data is incomplete";

  static String m22(total, currency) =>
      "${total} ${currency} will be recorded as paid. The payroll cannot be edited afterward.";

  static String m23(curriculum) =>
      "Please choose the grades for the ${curriculum}";

  static String m24(curriculum) =>
      "Please choose the Subjects for the ${curriculum}";

  static String m25(days) => "${days} days remaining";

  static String m26(hours) => "${hours} hours remaining";

  static String m27(email) =>
      "Check your email ${email} and follow the instructions to reset your password.";

  static String m28(amount) => "Save SAR ${amount}";

  static String m29(location) => "Saved in: ${location}";

  static String m30(day) => "Schedule for ${day}";

  static String m31(totalPoints) =>
      "Score must be between 0 and ${totalPoints}";

  static String m32(count) => "${count} / 2000";

  static String m33(name) => "Application details - ${name}";

  static String m34(month, year) => "Payroll ${month} ${year}";

  static String m35(time) => "Today, ${time}";

  static String m36(hours) => "${hours} training hours";

  static String m37(used, total) => "Used ${used} of ${total} days";

  static String m38(used, total) => "${used} of ${total} used";

  static String m39(count) => "${count} users";

  static String m40(number) => "Week ${number}";

  static String m41(name) => "Student: ${name}";

  static String m42(count) => "${count} weekly lessons";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Packages": MessageLookupByLibrary.simpleMessage("Packages"),
    "PackagesandSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Packages and Subscriptions",
    ),
    "absence": MessageLookupByLibrary.simpleMessage("Absence"),
    "absent": MessageLookupByLibrary.simpleMessage("Absent"),
    "academicPerformanceMessage": MessageLookupByLibrary.simpleMessage(
      "For excellence in academic performance",
    ),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "acceptRequest": MessageLookupByLibrary.simpleMessage("Accept Request"),
    "acceptStudentRequest": MessageLookupByLibrary.simpleMessage(
      "Accept Request",
    ),
    "accountActivatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Account activated successfully",
    ),
    "activated": MessageLookupByLibrary.simpleMessage("Active"),
    "active": MessageLookupByLibrary.simpleMessage("Active"),
    "active2": MessageLookupByLibrary.simpleMessage("Active"),
    "activeGroups": MessageLookupByLibrary.simpleMessage("Active Groups"),
    "activeSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Active Subscriptions",
    ),
    "addAction": MessageLookupByLibrary.simpleMessage("Add"),
    "addDailyPlanForStudents": MessageLookupByLibrary.simpleMessage(
      "Add a daily plan for students",
    ),
    "addDiscountCode": MessageLookupByLibrary.simpleMessage(
      "Add Discount Code",
    ),
    "addLesson": MessageLookupByLibrary.simpleMessage("Add Lesson"),
    "addNewChapter": MessageLookupByLibrary.simpleMessage("Add New Chapter"),
    "addNewCurriculum": MessageLookupByLibrary.simpleMessage(
      "Add New Curriculum",
    ),
    "addNewEvaluation": MessageLookupByLibrary.simpleMessage(
      "Add New Evaluation",
    ),
    "addNewGrade": MessageLookupByLibrary.simpleMessage("Add New Grade"),
    "addNewPackage": MessageLookupByLibrary.simpleMessage("Add New Package"),
    "addNewPackageTitle": MessageLookupByLibrary.simpleMessage(
      "Add New Package",
    ),
    "addNewSchedule": MessageLookupByLibrary.simpleMessage("Add New Schedule"),
    "addNewSemester": MessageLookupByLibrary.simpleMessage("Add New Semester"),
    "addNewSubject": MessageLookupByLibrary.simpleMessage("Add New Subject"),
    "addNewUser": MessageLookupByLibrary.simpleMessage("Add New User"),
    "addRewardPointsDesc": MessageLookupByLibrary.simpleMessage(
      "Rewards are calculated based on performance",
    ),
    "addRewardPointsTitle": MessageLookupByLibrary.simpleMessage(
      "Add Excellence Points",
    ),
    "addScheduleEntry": MessageLookupByLibrary.simpleMessage(
      "Add schedule entry",
    ),
    "addSubject": MessageLookupByLibrary.simpleMessage("Add Subject"),
    "addUser": MessageLookupByLibrary.simpleMessage("Add User"),
    "admin": MessageLookupByLibrary.simpleMessage("Admin"),
    "adminRegistrationRequestsSection": MessageLookupByLibrary.simpleMessage(
      "Registration requests",
    ),
    "adminSubjectRequestAmountOptional": MessageLookupByLibrary.simpleMessage(
      "Amount (optional)",
    ),
    "adminSubjectRequestApprove": MessageLookupByLibrary.simpleMessage(
      "Approve",
    ),
    "adminSubjectRequestApproved": MessageLookupByLibrary.simpleMessage(
      "Subject request approved",
    ),
    "adminSubjectRequestMethodOptional": MessageLookupByLibrary.simpleMessage(
      "Payment method (optional)",
    ),
    "adminSubjectRequestPaymentNotes": MessageLookupByLibrary.simpleMessage(
      "Payment notes (optional)",
    ),
    "adminSubjectRequestPrice": MessageLookupByLibrary.simpleMessage("Price"),
    "adminSubjectRequestReferenceNumber": MessageLookupByLibrary.simpleMessage(
      "Reference number (optional)",
    ),
    "adminSubjectRequestRejectedSuccess": MessageLookupByLibrary.simpleMessage(
      "Subject request rejected",
    ),
    "adminSubjectRequestRequestedAt": MessageLookupByLibrary.simpleMessage(
      "Requested at",
    ),
    "adminSubjectRequestsEmpty": MessageLookupByLibrary.simpleMessage(
      "No subject requests with this status",
    ),
    "adminSubjectRequestsSection": MessageLookupByLibrary.simpleMessage(
      "Subject/lesson requests",
    ),
    "adminSupervisors": MessageLookupByLibrary.simpleMessage("Supervisors"),
    "adminUsers": MessageLookupByLibrary.simpleMessage("Users"),
    "algebraCourseCertificate": MessageLookupByLibrary.simpleMessage(
      "Algebra Course Completion Certificate",
    ),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "allClassrooms": MessageLookupByLibrary.simpleMessage("All Classrooms"),
    "allCurriculms": MessageLookupByLibrary.simpleMessage("All Curriculms"),
    "allDocuments": MessageLookupByLibrary.simpleMessage("All Documents"),
    "allGrades": MessageLookupByLibrary.simpleMessage("All grades"),
    "allStudents": MessageLookupByLibrary.simpleMessage("All students"),
    "allSubjects": MessageLookupByLibrary.simpleMessage("All Subjects"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "applePay": MessageLookupByLibrary.simpleMessage("Apple Pay"),
    "applyAsTeacher": MessageLookupByLibrary.simpleMessage("Apply as Teacher"),
    "applyAsTeacherSubtitle": MessageLookupByLibrary.simpleMessage(
      "Share your expertise and join our teaching team",
    ),
    "approveAccountActivation": MessageLookupByLibrary.simpleMessage(
      "Approve account activation",
    ),
    "april2026": MessageLookupByLibrary.simpleMessage("April 2026"),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "arabicLanguage": MessageLookupByLibrary.simpleMessage("Arabic Language"),
    "assignStudent": MessageLookupByLibrary.simpleMessage("Assign Student"),
    "assignSubject": MessageLookupByLibrary.simpleMessage("Assign to Subject"),
    "assignSupervisorToClassroom": m0,
    "assignTeacherInSubject": m1,
    "assignToClassroom": MessageLookupByLibrary.simpleMessage(
      "Assign to classroom",
    ),
    "assignmentAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Supervisor assigned successfully",
    ),
    "assignmentDescription": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "assignmentNotSubmittedYet": MessageLookupByLibrary.simpleMessage(
      "Assignment Not Submitted Yet",
    ),
    "assignmentRemovedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Supervisor assignment removed successfully",
    ),
    "assignmentSubmittedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Assignment submitted successfully",
    ),
    "assignmentTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "assignments": MessageLookupByLibrary.simpleMessage("Assignments"),
    "assignmentsEvaluation": MessageLookupByLibrary.simpleMessage(
      "Assignments Evaluation",
    ),
    "atLeastSixChars": MessageLookupByLibrary.simpleMessage(
      "At least 6 characters",
    ),
    "attachedFile": MessageLookupByLibrary.simpleMessage("Attached File"),
    "attachment": MessageLookupByLibrary.simpleMessage("Attachment"),
    "attachmentFile": MessageLookupByLibrary.simpleMessage("Attachment file"),
    "attendance": MessageLookupByLibrary.simpleMessage("Attendance"),
    "attendanceRate": MessageLookupByLibrary.simpleMessage("Attendance Rate"),
    "attendanceRegisteredSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Attendance registered successfully",
    ),
    "attendanceRegistration": MessageLookupByLibrary.simpleMessage(
      "Attendance Registration",
    ),
    "attendanceStudentsTitle": m2,
    "attendanceUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Attendance updated successfully",
    ),
    "availability": MessageLookupByLibrary.simpleMessage("Availability"),
    "available": MessageLookupByLibrary.simpleMessage("Available"),
    "availableDay": MessageLookupByLibrary.simpleMessage("Available day"),
    "averagePercent": m3,
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to login"),
    "bankTransfer": MessageLookupByLibrary.simpleMessage("Bank transfer"),
    "behavior": MessageLookupByLibrary.simpleMessage("Behavior"),
    "biology": MessageLookupByLibrary.simpleMessage("Biology"),
    "birthDate": MessageLookupByLibrary.simpleMessage("Birth date"),
    "bonusPoints": MessageLookupByLibrary.simpleMessage("Bonus Points"),
    "browseSection": MessageLookupByLibrary.simpleMessage("Browse section"),
    "canChangeCurrency": MessageLookupByLibrary.simpleMessage(
      "You can change the currency from the list",
    ),
    "canDemo": MessageLookupByLibrary.simpleMessage("Can provide demo lesson?"),
    "canProvideTrialLesson": MessageLookupByLibrary.simpleMessage(
      "Can you provide a trial lesson?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelAssignment": MessageLookupByLibrary.simpleMessage(
      "Cancel Assignment",
    ),
    "cancelAssignmentMessage": m4,
    "cancelSupervisorAssignmentQuestion": m5,
    "cancelTeacherAssignmentQuestion": m6,
    "cannotDisplayStudentCertificates": MessageLookupByLibrary.simpleMessage(
      "This student\'s certificates cannot be displayed",
    ),
    "cardHolderName": MessageLookupByLibrary.simpleMessage("Cardholder name"),
    "cardNumber": MessageLookupByLibrary.simpleMessage("Card number"),
    "cash": MessageLookupByLibrary.simpleMessage("Cash"),
    "certificateAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Certificate added successfully",
    ),
    "certificateDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Certificate deleted successfully",
    ),
    "certificateFileUnavailable": MessageLookupByLibrary.simpleMessage(
      "Certificate file is unavailable",
    ),
    "certificateReceived": MessageLookupByLibrary.simpleMessage(
      "You received May certificate",
    ),
    "certificateSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Certificate saved successfully",
    ),
    "savingCertificate": MessageLookupByLibrary.simpleMessage(
      "Saving certificate...",
    ),
    "certificateUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Certificate updated successfully",
    ),
    "certificates": MessageLookupByLibrary.simpleMessage("Certificates"),
    "certificatesSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Certificates sent successfully",
    ),
    "certificatesWithoutArticle": MessageLookupByLibrary.simpleMessage(
      "Certificates",
    ),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "changePasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Change Password",
    ),
    "changePhoneTitle": MessageLookupByLibrary.simpleMessage(
      "Edit Phone Number",
    ),
    "changeUsernameTitle": MessageLookupByLibrary.simpleMessage(
      "Edit Username",
    ),
    "chatMsg1": MessageLookupByLibrary.simpleMessage(
      "Hi Ahmed, how is the new assignment going?",
    ),
    "chatMsg2": MessageLookupByLibrary.simpleMessage(
      "Great, Ms. Sarah. Thanks for the explanation.",
    ),
    "chatMsg3": MessageLookupByLibrary.simpleMessage(
      "Excellent. Don’t forget to review chapter three before the lesson.",
    ),
    "chatMsg4": MessageLookupByLibrary.simpleMessage("Okay, I’ll start now"),
    "chatTitleFallback": MessageLookupByLibrary.simpleMessage("Conversation"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "registrationRequestSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "The registration request was sent successfully. Administration will contact you via WhatsApp to complete the subscription and activation.",
    ),
    "reviewRequest": MessageLookupByLibrary.simpleMessage("Review request"),
    "submitRegistrationRequest": MessageLookupByLibrary.simpleMessage(
      "Submit registration request",
    ),
    "checkYourEmailPrefix": MessageLookupByLibrary.simpleMessage(
      "Check your email ",
    ),
    "chemistry": MessageLookupByLibrary.simpleMessage("Chemistry"),
    "child": MessageLookupByLibrary.simpleMessage("Child"),
    "children": MessageLookupByLibrary.simpleMessage("Children"),
    "childrenCount": MessageLookupByLibrary.simpleMessage("Children count"),
    "childrenDiscount": MessageLookupByLibrary.simpleMessage(
      "Number of children",
    ),
    "childrenSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Children subscriptions",
    ),
    "chooseAccountType": MessageLookupByLibrary.simpleMessage(
      "Choose account type to continue",
    ),
    "chooseClassRoom": MessageLookupByLibrary.simpleMessage("Choose classroom"),
    "chooseClassroom": MessageLookupByLibrary.simpleMessage(
      "Choose a classroom",
    ),
    "chooseCurriculum": MessageLookupByLibrary.simpleMessage(
      "Choose the suitable curriculum for your children and start the learning journey with us",
    ),
    "chooseCurriculumIcon": MessageLookupByLibrary.simpleMessage(
      "Choose curriculum icon",
    ),
    "chooseCurriculumType": MessageLookupByLibrary.simpleMessage(
      "Choose Curriculum Type",
    ),
    "chooseFile": MessageLookupByLibrary.simpleMessage("Choose file"),
    "chooseGrade": MessageLookupByLibrary.simpleMessage("Choose a grade"),
    "chooseNewCurriculum": MessageLookupByLibrary.simpleMessage(
      "Choose curriculum",
    ),
    "chooseScheduleImage": MessageLookupByLibrary.simpleMessage(
      "Choose schedule image",
    ),
    "chooseSubject": MessageLookupByLibrary.simpleMessage("Choose subject"),
    "city": MessageLookupByLibrary.simpleMessage("City"),
    "classDetails": MessageLookupByLibrary.simpleMessage("Class Details"),
    "classLabel": MessageLookupByLibrary.simpleMessage("Classes"),
    "className": MessageLookupByLibrary.simpleMessage("Class Name"),
    "classNameRequired": MessageLookupByLibrary.simpleMessage(
      "Class name is required",
    ),
    "classR": MessageLookupByLibrary.simpleMessage("Class"),
    "classRoom": MessageLookupByLibrary.simpleMessage("Classroom"),
    "classRoomManagement": MessageLookupByLibrary.simpleMessage(
      "ClassRoom Management",
    ),
    "classSchedulesManagement": MessageLookupByLibrary.simpleMessage(
      "Class Schedules Management",
    ),
    "classes": MessageLookupByLibrary.simpleMessage("Classes"),
    "classesCount": MessageLookupByLibrary.simpleMessage("Classes"),
    "classesManagement": MessageLookupByLibrary.simpleMessage(
      "Classes Management",
    ),
    "classroom": MessageLookupByLibrary.simpleMessage("Classroom"),
    "classroomRequired": MessageLookupByLibrary.simpleMessage(
      "Please select a classroom",
    ),
    "classroomSessionAlreadyActive": MessageLookupByLibrary.simpleMessage(
      "Another lesson is already active for this classroom",
    ),
    "classroomZoomNotConfigured": MessageLookupByLibrary.simpleMessage(
      "Zoom setup is incomplete for this classroom",
    ),
    "classrooms": MessageLookupByLibrary.simpleMessage("Classrooms"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "closePreview": MessageLookupByLibrary.simpleMessage("Close preview"),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "completedSessions": MessageLookupByLibrary.simpleMessage(
      "Completed Sessions",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete?",
    ),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "confirmPasswordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Confirm password cannot be empty.",
    ),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "confirmRequest": MessageLookupByLibrary.simpleMessage("Confirm Request"),
    "congrats": MessageLookupByLibrary.simpleMessage("Congrats!"),
    "congratsThisMonth": MessageLookupByLibrary.simpleMessage(
      "This Month Achievement",
    ),
    "contactInfo": MessageLookupByLibrary.simpleMessage("معلومات الاتصال"),
    "contactWhatsApp": MessageLookupByLibrary.simpleMessage(
      "Contact via WhatsApp",
    ),
    "copiedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Copied successfully",
    ),
    "correctAssignment": MessageLookupByLibrary.simpleMessage(
      "Grade Assignment",
    ),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
    "createAssignment": MessageLookupByLibrary.simpleMessage(
      "Create Assignment",
    ),
    "createNewAccount": MessageLookupByLibrary.simpleMessage(
      "Create New Account",
    ),
    "createNewAssignment": MessageLookupByLibrary.simpleMessage(
      "Create New Assignment",
    ),
    "creditCard": MessageLookupByLibrary.simpleMessage("Credit Card"),
    "currency": MessageLookupByLibrary.simpleMessage("Currency:"),
    "currencyRequired": MessageLookupByLibrary.simpleMessage(
      "Please select a currency",
    ),
    "currentMonth": MessageLookupByLibrary.simpleMessage("Current Month"),
    "currentPrice": m7,
    "currentProfits": MessageLookupByLibrary.simpleMessage("Current Earnings"),
    "curricula": MessageLookupByLibrary.simpleMessage("Curricula"),
    "curriculum": MessageLookupByLibrary.simpleMessage("Curriculum"),
    "curriculumDescription": MessageLookupByLibrary.simpleMessage(
      "Curriculum Description",
    ),
    "curriculumIcon": MessageLookupByLibrary.simpleMessage("Curriculum Image"),
    "curriculumName": MessageLookupByLibrary.simpleMessage("Curriculum Name"),
    "curriculumRequired": MessageLookupByLibrary.simpleMessage(
      "Curriculum is required",
    ),
    "curriculumSelection": MessageLookupByLibrary.simpleMessage(
      "Curriculum Selection",
    ),
    "curriculums": MessageLookupByLibrary.simpleMessage("Curriculums"),
    "cv": MessageLookupByLibrary.simpleMessage("CV"),
    "cvUnavailable": MessageLookupByLibrary.simpleMessage(
      "CV link is not available",
    ),
    "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
    "dailyPlanAlreadyUploaded": MessageLookupByLibrary.simpleMessage(
      "The plan has already been uploaded for this day.",
    ),
    "dailyPlanCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Daily plan added successfully",
    ),
    "dailyPlansTitle": MessageLookupByLibrary.simpleMessage("Daily Plans"),
    "dailyProfits": MessageLookupByLibrary.simpleMessage("Daily Profits"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Home"),
    "dashboardPassword": MessageLookupByLibrary.simpleMessage(
      "Dashboard Password",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "dateFormatHint": MessageLookupByLibrary.simpleMessage("mm/dd/yy"),
    "dateRangeDiscount": MessageLookupByLibrary.simpleMessage("Date range"),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "daysPackage": m8,
    "deductionsDesc": MessageLookupByLibrary.simpleMessage(
      "Absence or lateness",
    ),
    "deductionsTitle": MessageLookupByLibrary.simpleMessage(
      "Deduct Any Deductions",
    ),
    "degree": MessageLookupByLibrary.simpleMessage("Degree"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAssignment": MessageLookupByLibrary.simpleMessage(
      "Delete assignment",
    ),
    "deleteAssignmentConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this assignment?",
    ),
    "deleteDiscountCode": MessageLookupByLibrary.simpleMessage(
      "Delete discount code",
    ),
    "deleteDiscountCodeConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this discount code?",
    ),
    "deleteGrade": MessageLookupByLibrary.simpleMessage("Delete grade"),
    "deleteGradeConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this grade?",
    ),
    "deletePackage": MessageLookupByLibrary.simpleMessage("Delete Package"),
    "deletePackageConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this package?",
    ),
    "deleteSchedule": MessageLookupByLibrary.simpleMessage("Delete schedule"),
    "deleteScheduleConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this schedule?",
    ),
    "deliveryDate": MessageLookupByLibrary.simpleMessage("Delivery date"),
    "desiredSubjects": MessageLookupByLibrary.simpleMessage("Desired subjects"),
    "details": MessageLookupByLibrary.simpleMessage("Details"),
    "disable": MessageLookupByLibrary.simpleMessage("Disable"),
    "disableAccount": MessageLookupByLibrary.simpleMessage("Disable account"),
    "disableAccountConfirmation": MessageLookupByLibrary.simpleMessage(
      "Do you want to disable this account?",
    ),
    "disableUserDescription": MessageLookupByLibrary.simpleMessage(
      "They will not be able to log in until you reactivate them.",
    ),
    "disableUserQuestion": m9,
    "discountAmount": MessageLookupByLibrary.simpleMessage("Discount"),
    "discountCode": MessageLookupByLibrary.simpleMessage("Discount code"),
    "discountCodeCreated": MessageLookupByLibrary.simpleMessage(
      "Discount code created successfully",
    ),
    "discountCodeDeleted": MessageLookupByLibrary.simpleMessage(
      "Discount code deleted successfully",
    ),
    "discountCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Discount code is required",
    ),
    "discountCodeUpdated": MessageLookupByLibrary.simpleMessage(
      "Discount code updated successfully",
    ),
    "discountCodes": MessageLookupByLibrary.simpleMessage("Discount Codes"),
    "discountDatesRequired": MessageLookupByLibrary.simpleMessage(
      "Start and end dates are required",
    ),
    "discountEndBeforeStart": MessageLookupByLibrary.simpleMessage(
      "End date cannot be before start date",
    ),
    "discountPercentage": MessageLookupByLibrary.simpleMessage("Percentage"),
    "discountTitle": MessageLookupByLibrary.simpleMessage("Discount Title"),
    "discountTitleHint": MessageLookupByLibrary.simpleMessage(
      "Example: Save 120 SAR",
    ),
    "discountType": MessageLookupByLibrary.simpleMessage("Type"),
    "discounts": MessageLookupByLibrary.simpleMessage("Deductions"),
    "doNotHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "downloadPdf": MessageLookupByLibrary.simpleMessage("Download PDF"),
    "dueFriday": MessageLookupByLibrary.simpleMessage("Due Friday"),
    "dueSunday": MessageLookupByLibrary.simpleMessage("Due Sunday"),
    "dues": MessageLookupByLibrary.simpleMessage("Dues"),
    "duplicateScheduleDay": MessageLookupByLibrary.simpleMessage(
      "Only one schedule entry can be added for the same day",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editAttendance": MessageLookupByLibrary.simpleMessage("Edit Attendance"),
    "editCertificate": MessageLookupByLibrary.simpleMessage("Edit Certificate"),
    "editClass": MessageLookupByLibrary.simpleMessage("Edit Class"),
    "editCurriculum": MessageLookupByLibrary.simpleMessage("Edit Curriculum"),
    "editData": MessageLookupByLibrary.simpleMessage("Edit Data"),
    "editDiscountCode": MessageLookupByLibrary.simpleMessage(
      "Edit Discount Code",
    ),
    "editEvaluation": MessageLookupByLibrary.simpleMessage("Edit Evaluation"),
    "editGrade": MessageLookupByLibrary.simpleMessage("Edit Grade"),
    "editLesson": MessageLookupByLibrary.simpleMessage("Edit Lesson"),
    "editPackage": MessageLookupByLibrary.simpleMessage("Edit Package"),
    "editScheduleEntry": MessageLookupByLibrary.simpleMessage(
      "Edit schedule entry",
    ),
    "editSubject": MessageLookupByLibrary.simpleMessage("Edit Subject"),
    "egpCurrency": MessageLookupByLibrary.simpleMessage("Egyptian Pound (EGP)"),
    "egpShort": MessageLookupByLibrary.simpleMessage("EGP"),
    "egyptian": MessageLookupByLibrary.simpleMessage("Egyptian"),
    "egyptianCurriculum": MessageLookupByLibrary.simpleMessage(
      "Egyptian Curriculum",
    ),
    "egyptianCurriculumDesc": MessageLookupByLibrary.simpleMessage(
      "Integrated education for primary, preparatory, and secondary grades according to the modern Egyptian curriculum.",
    ),
    "egyptianDepartment": MessageLookupByLibrary.simpleMessage(
      "Egyptian Department",
    ),
    "egyptianPound": MessageLookupByLibrary.simpleMessage("Egyptian Pound"),
    "eightHoursPlan": MessageLookupByLibrary.simpleMessage("8-hour package"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
    "emailCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Email cannot be empty.",
    ),
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "emiratiCurriculum": MessageLookupByLibrary.simpleMessage(
      "Emirati Curriculum",
    ),
    "emptyLesson": MessageLookupByLibrary.simpleMessage("Empty lesson"),
    "enableAccount": MessageLookupByLibrary.simpleMessage("Enable account"),
    "enableAccountConfirmation": MessageLookupByLibrary.simpleMessage(
      "Do you want to enable this account?",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("End date"),
    "endTime": MessageLookupByLibrary.simpleMessage("End time"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterDiscountCode": MessageLookupByLibrary.simpleMessage(
      "Enter discount code",
    ),
    "errorBadCertificate": MessageLookupByLibrary.simpleMessage(
      "Untrusted SSL certificate.",
    ),
    "errorBadRequest": MessageLookupByLibrary.simpleMessage("Bad request."),
    "errorCancel": MessageLookupByLibrary.simpleMessage(
      "Request was cancelled.",
    ),
    "errorConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Connection timed out.",
    ),
    "errorForbidden": MessageLookupByLibrary.simpleMessage("Access denied."),
    "errorInternalServer": MessageLookupByLibrary.simpleMessage(
      "Internal server error.",
    ),
    "errorNoInternet": MessageLookupByLibrary.simpleMessage(
      "No internet connection.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("Item not found."),
    "errorReceiveTimeout": MessageLookupByLibrary.simpleMessage(
      "Receive timeout occurred.",
    ),
    "errorSendTimeout": MessageLookupByLibrary.simpleMessage(
      "Send timeout occurred.",
    ),
    "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Session expired.",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.",
    ),
    "errorUnknownStatusCode": m10,
    "errorValidation": MessageLookupByLibrary.simpleMessage(
      "Please check the entered data and try again.",
    ),
    "evaluationAbsent": MessageLookupByLibrary.simpleMessage("Absent"),
    "evaluationAcceptable": MessageLookupByLibrary.simpleMessage("Acceptable"),
    "evaluationEvaluated": MessageLookupByLibrary.simpleMessage("Evaluated"),
    "evaluationExcused": MessageLookupByLibrary.simpleMessage("Excused"),
    "evaluationLate": MessageLookupByLibrary.simpleMessage("Late"),
    "evaluationNotEvaluated": MessageLookupByLibrary.simpleMessage(
      "Not evaluated",
    ),
    "evaluationPresent": MessageLookupByLibrary.simpleMessage("Present"),
    "evaluationSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Evaluation saved successfully",
    ),
    "evaluationStatusUnavailable": MessageLookupByLibrary.simpleMessage(
      "Evaluation status is unavailable",
    ),
    "evaluationWeak": MessageLookupByLibrary.simpleMessage("Weak"),
    "evaluations": MessageLookupByLibrary.simpleMessage("Evaluations"),
    "excellencePoints": MessageLookupByLibrary.simpleMessage(
      "Excellence Points",
    ),
    "excellent": MessageLookupByLibrary.simpleMessage("Excellent"),
    "excellentTeacher": MessageLookupByLibrary.simpleMessage(
      "Excellent Teacher",
    ),
    "expected": MessageLookupByLibrary.simpleMessage("Expected"),
    "expenses": MessageLookupByLibrary.simpleMessage("Expenses"),
    "experience": MessageLookupByLibrary.simpleMessage("Experience"),
    "expiredSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Expired Subscriptions",
    ),
    "expiryDate": MessageLookupByLibrary.simpleMessage("Expiry date"),
    "failedToCopy": MessageLookupByLibrary.simpleMessage("Unable to copy"),
    "failedToLoadAttendance": MessageLookupByLibrary.simpleMessage(
      "Failed to load attendance data",
    ),
    "failedToOpenCv": MessageLookupByLibrary.simpleMessage(
      "Unable to open the CV",
    ),
    "fieldIsRequired": m11,
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "fileDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "Assignment file opened",
    ),
    "fileDownloadedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "File downloaded successfully",
    ),
    "fileSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "File saved successfully",
    ),
    "savingFile": MessageLookupByLibrary.simpleMessage("Saving file..."),
    "fillAllRequiredFields": MessageLookupByLibrary.simpleMessage(
      "Please fill in all required fields.",
    ),
    "finalAmount": MessageLookupByLibrary.simpleMessage("Total"),
    "finalDelete": MessageLookupByLibrary.simpleMessage("Final Delete"),
    "finalDeleteDescription": MessageLookupByLibrary.simpleMessage(
      "This account will be permanently deleted from the system, including its login account and related profile data. This action cannot be undone.",
    ),
    "finalDeleteUser": MessageLookupByLibrary.simpleMessage(
      "Final Delete User",
    ),
    "finished": MessageLookupByLibrary.simpleMessage("Finished"),
    "firstPrimaryClassroom": MessageLookupByLibrary.simpleMessage(
      "First primary grade",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "forgotPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter your email and we will send you a reset code",
    ),
    "forgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Forgot Password",
    ),
    "fourDaysAgo": MessageLookupByLibrary.simpleMessage("4 days ago"),
    "fourHoursPlan": MessageLookupByLibrary.simpleMessage("4-hour package"),
    "fourthPrimaryClassroom": MessageLookupByLibrary.simpleMessage(
      "Fourth primary grade",
    ),
    "friday": MessageLookupByLibrary.simpleMessage("Friday"),
    "from": MessageLookupByLibrary.simpleMessage("From"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "futurePlanDateNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Future dates are not allowed",
    ),
    "goToPayment": MessageLookupByLibrary.simpleMessage("Proceed to Payment"),
    "good": MessageLookupByLibrary.simpleMessage("Good"),
    "grade": MessageLookupByLibrary.simpleMessage("Grade"),
    "gradeAndAssignScore": MessageLookupByLibrary.simpleMessage(
      "Grade & Assign Score",
    ),
    "gradeLabel": m12,
    "gradeLevel": MessageLookupByLibrary.simpleMessage("Grade level"),
    "gradeName": MessageLookupByLibrary.simpleMessage("Grade Name"),
    "gradeRequired": MessageLookupByLibrary.simpleMessage("Grade is required"),
    "graded": MessageLookupByLibrary.simpleMessage("Graded"),
    "gradesCount": m13,
    "graduationGrade": MessageLookupByLibrary.simpleMessage("Grade"),
    "graduationYear": MessageLookupByLibrary.simpleMessage("Graduation Year"),
    "groupCreatedByYou": MessageLookupByLibrary.simpleMessage(
      "Group created, start now",
    ),
    "groups": MessageLookupByLibrary.simpleMessage("Groups"),
    "gulfClassroomSubjectUnavailable": MessageLookupByLibrary.simpleMessage(
      "The classroom subject data needs to be reviewed by the administration.",
    ),
    "gulfCurriculum": MessageLookupByLibrary.simpleMessage("Gulf Curriculum"),
    "gulfScheduleEntryAdded": MessageLookupByLibrary.simpleMessage(
      "Schedule entry added successfully",
    ),
    "gulfScheduleEntryDeleted": MessageLookupByLibrary.simpleMessage(
      "Schedule entry deleted successfully",
    ),
    "gulfScheduleEntryUpdated": MessageLookupByLibrary.simpleMessage(
      "Schedule entry updated successfully",
    ),
    "gulfScheduleLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to load the schedule",
    ),
    "hasClearMic": MessageLookupByLibrary.simpleMessage(
      "Do you have a clear microphone?",
    ),
    "hasGoodCamera": MessageLookupByLibrary.simpleMessage(
      "Do you have a good camera?",
    ),
    "hasLaptopOrComputer": MessageLookupByLibrary.simpleMessage(
      "Do you have a laptop or computer?",
    ),
    "hasStableInternet": MessageLookupByLibrary.simpleMessage(
      "Do you have a stable internet connection?",
    ),
    "hasTeachingExperience": MessageLookupByLibrary.simpleMessage(
      "Do you have teaching experience?",
    ),
    "hireTeachers": MessageLookupByLibrary.simpleMessage("Hire Teachers"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeworkLabel": MessageLookupByLibrary.simpleMessage("Homework"),
    "hourlyRate": MessageLookupByLibrary.simpleMessage("Hourly Rate (SAR)"),
    "hourlyRateMustBeNumber": MessageLookupByLibrary.simpleMessage(
      "Hourly rate must be a number",
    ),
    "hourlyRateRequired": MessageLookupByLibrary.simpleMessage(
      "Hourly rate is required",
    ),
    "hoursPackage": m14,
    "howHandleWeakStudent": MessageLookupByLibrary.simpleMessage(
      "How do you deal with a weak student?",
    ),
    "idealSupervisor": MessageLookupByLibrary.simpleMessage("Ideal Supervisor"),
    "idealSupervisorCertificate": MessageLookupByLibrary.simpleMessage(
      "Ideal Supervisor Certificate",
    ),
    "idealSupervisorCertificateAlreadyExists":
        MessageLookupByLibrary.simpleMessage(
          "An ideal supervisor certificate was already issued this month",
        ),
    "idealSupervisorIssuedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Ideal supervisor certificate issued successfully",
    ),
    "idealTeacher": MessageLookupByLibrary.simpleMessage("Ideal Teacher"),
    "idealTeacherCertificate": MessageLookupByLibrary.simpleMessage(
      "Ideal Teacher Certificate",
    ),
    "idealTeacherIssuedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Ideal teacher certificate issued successfully",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("InActive"),
    "instapay": MessageLookupByLibrary.simpleMessage("InstaPay"),
    "interaction": MessageLookupByLibrary.simpleMessage("Interaction"),
    "interactionAppreciationCertificate": MessageLookupByLibrary.simpleMessage(
      "Appreciation Certificate - Interaction",
    ),
    "interactionLevel": MessageLookupByLibrary.simpleMessage(
      "Interaction Level",
    ),
    "invalidCertificateRecipient": MessageLookupByLibrary.simpleMessage(
      "The selected account is not a supervisor",
    ),
    "invalidChildrenCount": MessageLookupByLibrary.simpleMessage(
      "Enter a positive children count",
    ),
    "invalidCvUrl": MessageLookupByLibrary.simpleMessage(
      "The CV link is invalid",
    ),
    "invalidData": MessageLookupByLibrary.simpleMessage(
      "Please check the entered data",
    ),
    "invalidDiscountPercentage": MessageLookupByLibrary.simpleMessage(
      "Enter a valid percentage",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address.",
    ),
    "invalidEvaluationBonus": MessageLookupByLibrary.simpleMessage(
      "Bonus points must be from 0 to 5",
    ),
    "invalidIdealSupervisorSelection": MessageLookupByLibrary.simpleMessage(
      "Select at least one valid supervisor",
    ),
    "invalidLink": MessageLookupByLibrary.simpleMessage("Invalid link"),
    "invalidPackage": MessageLookupByLibrary.simpleMessage(
      "Invalid package data",
    ),
    "invalidPaymentAmount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount of at least 0.01",
    ),
    "invalidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid phone number",
    ),
    "isActive": MessageLookupByLibrary.simpleMessage("Active"),
    "issueCertificate": MessageLookupByLibrary.simpleMessage(
      "Issue Certificate",
    ),
    "issueNewCertificate": MessageLookupByLibrary.simpleMessage(
      "Issue New Certificate",
    ),
    "kuwaitiCurriculum": MessageLookupByLibrary.simpleMessage(
      "Kuwaiti Curriculum",
    ),
    "lastSixMonths": MessageLookupByLibrary.simpleMessage("Last 6 Months"),
    "latestEarnedPoints": MessageLookupByLibrary.simpleMessage(
      "Latest Earned Points",
    ),
    "lessonDate": MessageLookupByLibrary.simpleMessage("Lesson date"),
    "lessonLabel": MessageLookupByLibrary.simpleMessage("Lesson"),
    "lessonStartsSoon": MessageLookupByLibrary.simpleMessage(
      "Math lesson starts in 15 min",
    ),
    "lessons": MessageLookupByLibrary.simpleMessage("Lessons"),
    "lessonsManagement": MessageLookupByLibrary.simpleMessage(
      "Lessons Management",
    ),
    "lightAndShadowExperiment": MessageLookupByLibrary.simpleMessage(
      "Light and Shadow Experiment",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "loadingClassrooms": MessageLookupByLibrary.simpleMessage(
      "Loading classrooms",
    ),
    "loadingStudents": MessageLookupByLibrary.simpleMessage("Loading students"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginNow": MessageLookupByLibrary.simpleMessage("Login"),
    "loginWelcomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Log in to access your dashboard",
    ),
    "loginWelcomeTitle": MessageLookupByLibrary.simpleMessage("Welcome"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutSuccess": MessageLookupByLibrary.simpleMessage(
      "Logged out successfully",
    ),
    "major": MessageLookupByLibrary.simpleMessage("Major"),
    "manageStudentsAndClasses": MessageLookupByLibrary.simpleMessage(
      "Manage classes and students",
    ),
    "manualPaymentConfirmation": MessageLookupByLibrary.simpleMessage(
      "Confirm manual payment",
    ),
    "manualTransferReviewPending": MessageLookupByLibrary.simpleMessage(
      "Pending manual receipt review",
    ),
    "march2026": MessageLookupByLibrary.simpleMessage("March 2026"),
    "markAllNotificationsRead": MessageLookupByLibrary.simpleMessage(
      "Mark all as read",
    ),
    "markAsRead": MessageLookupByLibrary.simpleMessage("Mark as read"),
    "materialsManagement": MessageLookupByLibrary.simpleMessage(
      "Materials Management",
    ),
    "math": MessageLookupByLibrary.simpleMessage("Math"),
    "mathShort": MessageLookupByLibrary.simpleMessage("Math"),
    "mathTeacherSarah": MessageLookupByLibrary.simpleMessage(
      "Math . Ms. Sarah Abdullah",
    ),
    "mayCertificate": MessageLookupByLibrary.simpleMessage("May Certificate"),
    "messageDocuments": MessageLookupByLibrary.simpleMessage(
      "Message Documents",
    ),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "monday": MessageLookupByLibrary.simpleMessage("Monday"),
    "month": MessageLookupByLibrary.simpleMessage("Month"),
    "monthlyCertificateTitle": m15,
    "monthlyPackage": MessageLookupByLibrary.simpleMessage("Monthly Package"),
    "monthlyProfits": MessageLookupByLibrary.simpleMessage("Monthly Profits"),
    "monthlyRevenue": MessageLookupByLibrary.simpleMessage("Monthly Revenue"),
    "mostPopular": MessageLookupByLibrary.simpleMessage("Most popular"),
    "moveToReview": MessageLookupByLibrary.simpleMessage("Move to review"),
    "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
    "myGroups": MessageLookupByLibrary.simpleMessage("My Groups"),
    "myPerformance": MessageLookupByLibrary.simpleMessage("My Performance"),
    "myRequests": MessageLookupByLibrary.simpleMessage("My requests"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Name cannot be empty.",
    ),
    "nameMinLength": MessageLookupByLibrary.simpleMessage(
      "Name must be at least 3 characters.",
    ),
    "nationality": MessageLookupByLibrary.simpleMessage("Nationality"),
    "net": MessageLookupByLibrary.simpleMessage("Net"),
    "netAmount": MessageLookupByLibrary.simpleMessage("Net Amount"),
    "newAssignmentUploaded": MessageLookupByLibrary.simpleMessage(
      "A new assignment was uploaded",
    ),
    "newBadge": MessageLookupByLibrary.simpleMessage("New"),
    "newCertificate": MessageLookupByLibrary.simpleMessage(
      "Certificate of Appreciation",
    ),
    "newClassMessageNotification": MessageLookupByLibrary.simpleMessage(
      "A new message from fourth grade",
    ),
    "newCustomer": MessageLookupByLibrary.simpleMessage("New Customer"),
    "newMessage": MessageLookupByLibrary.simpleMessage(
      "New message from Ms. Sarah",
    ),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage("New Password"),
    "newPrice": MessageLookupByLibrary.simpleMessage("New Price"),
    "newPriceInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid new price",
    ),
    "newPriceMustBeLessThanOldPrice": MessageLookupByLibrary.simpleMessage(
      "The new price must be less than or equal to the old price",
    ),
    "newRating": MessageLookupByLibrary.simpleMessage(
      "New weekly rating for Ahmed",
    ),
    "newWeeklyEvaluation": MessageLookupByLibrary.simpleMessage(
      "New Weekly Evaluation",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "nextLevelPointsText": m16,
    "nextSteps": MessageLookupByLibrary.simpleMessage("Next Steps"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noActiveAccountsFound": MessageLookupByLibrary.simpleMessage(
      "No active accounts found",
    ),
    "noAssignedSubjectsForClassroom": MessageLookupByLibrary.simpleMessage(
      "No assigned subjects for this classroom",
    ),
    "noAssignmentsYet": MessageLookupByLibrary.simpleMessage(
      "No assignments yet",
    ),
    "noAssignmentsYetSubtitle": MessageLookupByLibrary.simpleMessage(
      "New assignments will appear here once they are added.",
    ),
    "noAvailableClassrooms": MessageLookupByLibrary.simpleMessage(
      "No available classrooms",
    ),
    "noCertificatesAvailable": MessageLookupByLibrary.simpleMessage(
      "No certificates are available yet",
    ),
    "noCertificatesForStudent": MessageLookupByLibrary.simpleMessage(
      "There are no certificates for this student",
    ),
    "noChildrenAvailable": MessageLookupByLibrary.simpleMessage(
      "No children available",
    ),
    "noChildrenLinked": MessageLookupByLibrary.simpleMessage(
      "No children are linked to this account",
    ),
    "noClassroomsAvailable": MessageLookupByLibrary.simpleMessage(
      "No classrooms available",
    ),
    "noClassroomsAvailableForGrade": MessageLookupByLibrary.simpleMessage(
      "No classrooms are available for this grade",
    ),
    "noCompletedAssignments": MessageLookupByLibrary.simpleMessage(
      "No completed assignments",
    ),
    "noCompletedAssignmentsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Completed assignments will appear here.",
    ),
    "noCurriculumsAvailable": MessageLookupByLibrary.simpleMessage(
      "No curricula available",
    ),
    "noCurriculumsFound": MessageLookupByLibrary.simpleMessage(
      "No curriculums found",
    ),
    "noDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No information available now",
    ),
    "noDiscountCodes": MessageLookupByLibrary.simpleMessage(
      "No discount codes are available",
    ),
    "noEvaluationForStudent": MessageLookupByLibrary.simpleMessage(
      "No evaluation for this student",
    ),
    "noEvaluationRecordedThisWeek": MessageLookupByLibrary.simpleMessage(
      "No evaluation was recorded for this week",
    ),
    "noEvaluationWeeksAvailable": MessageLookupByLibrary.simpleMessage(
      "No evaluation weeks are available",
    ),
    "noGradesAvailableForCurriculum": MessageLookupByLibrary.simpleMessage(
      "No grades are available for this curriculum",
    ),
    "noGroupsYet": MessageLookupByLibrary.simpleMessage("No groups yet"),
    "noGroupsYetSubtitle": MessageLookupByLibrary.simpleMessage(
      "Your groups and pending requests will appear here.",
    ),
    "noGulfClassroomsAvailable": MessageLookupByLibrary.simpleMessage(
      "No Gulf classrooms are available",
    ),
    "noInactiveAccountsFound": MessageLookupByLibrary.simpleMessage(
      "No inactive accounts found",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "noLessonsAvailable": MessageLookupByLibrary.simpleMessage(
      "No lessons available",
    ),
    "noLessonsForSelectedDay": MessageLookupByLibrary.simpleMessage(
      "No lessons for the selected day",
    ),
    "noMessageDocumentsAvailable": MessageLookupByLibrary.simpleMessage(
      "No message documents are available yet",
    ),
    "noNewRegistrationRequests": MessageLookupByLibrary.simpleMessage(
      "There are no new registration requests",
    ),
    "noNotifications": MessageLookupByLibrary.simpleMessage("No notifications"),
    "noNotificationsYet": MessageLookupByLibrary.simpleMessage(
      "No notifications yet",
    ),
    "noPendingAssignments": MessageLookupByLibrary.simpleMessage(
      "No pending assignments",
    ),
    "noPendingAssignmentsSubtitle": MessageLookupByLibrary.simpleMessage(
      "All current assignments are completed or there are no new assignments yet.",
    ),
    "noPlansAvailable": MessageLookupByLibrary.simpleMessage(
      "No plans available",
    ),
    "noPlansForWeek": MessageLookupByLibrary.simpleMessage(
      "No plans for this week",
    ),
    "noRecordingsAvailable": MessageLookupByLibrary.simpleMessage(
      "No recordings are available yet",
    ),
    "noRegisteredChildren": MessageLookupByLibrary.simpleMessage(
      "There are no registered children",
    ),
    "noReportsAvailable": MessageLookupByLibrary.simpleMessage(
      "No reports are available yet",
    ),
    "noScheduleEntriesForClassroom": MessageLookupByLibrary.simpleMessage(
      "No schedule entries have been added for this classroom yet",
    ),
    "noScheduledLessonForDay": MessageLookupByLibrary.simpleMessage(
      "No lesson is scheduled for this day",
    ),
    "noStudentsInClass": MessageLookupByLibrary.simpleMessage(
      "There are no students in this classroom",
    ),
    "noStudentsInClassroom": MessageLookupByLibrary.simpleMessage(
      "There are no students in this classroom",
    ),
    "noStudyWeeksAvailable": MessageLookupByLibrary.simpleMessage(
      "No study weeks are available for this classroom",
    ),
    "noSubjectEvaluationRecordedThisWeek": MessageLookupByLibrary.simpleMessage(
      "No evaluation was recorded for this subject this week",
    ),
    "noSubjectsAvailable": MessageLookupByLibrary.simpleMessage(
      "No subjects available for this grade",
    ),
    "noSubjectsAvailableForClassroom": MessageLookupByLibrary.simpleMessage(
      "No subjects are available for this classroom",
    ),
    "noSubjectsAvailableForTeacherStudent":
        MessageLookupByLibrary.simpleMessage(
          "No subjects are available to you for this student",
        ),
    "noSubjectsAvailableReadOnly": MessageLookupByLibrary.simpleMessage(
      "No subjects are available",
    ),
    "noSubjectsForStudent": MessageLookupByLibrary.simpleMessage(
      "No subjects are available for this student",
    ),
    "noSubjectsMatchSearch": MessageLookupByLibrary.simpleMessage(
      "No subjects match your search",
    ),
    "noSubjectsRegistered": MessageLookupByLibrary.simpleMessage(
      "No subjects registered yet",
    ),
    "noSubmission": MessageLookupByLibrary.simpleMessage("Submitted"),
    "noSummaryContent": MessageLookupByLibrary.simpleMessage(
      "No summary content is available",
    ),
    "noSupervisorsFound": MessageLookupByLibrary.simpleMessage(
      "No supervisors found",
    ),
    "noTeachersAvailable": MessageLookupByLibrary.simpleMessage(
      "No teachers are available",
    ),
    "noTermPlansAvailable": MessageLookupByLibrary.simpleMessage(
      "No term plans available",
    ),
    "noUnassignedStudents": MessageLookupByLibrary.simpleMessage(
      "No unassigned students",
    ),
    "noValidSubjectForClassroom": MessageLookupByLibrary.simpleMessage(
      "No valid subject is linked to this classroom",
    ),
    "noWeeklyEvaluations": MessageLookupByLibrary.simpleMessage(
      "No weekly evaluations",
    ),
    "notActivated": MessageLookupByLibrary.simpleMessage("Inactive"),
    "notAvailable": MessageLookupByLibrary.simpleMessage("Not available"),
    "notSubmitted": MessageLookupByLibrary.simpleMessage("Not submitted"),
    "notes": MessageLookupByLibrary.simpleMessage(
      "Additional notes or details",
    ),
    "notesHint": MessageLookupByLibrary.simpleMessage(
      "Example: every Monday and Wednesday at 5 PM",
    ),
    "notesText": MessageLookupByLibrary.simpleMessage("Notes"),
    "notificationAcademic": MessageLookupByLibrary.simpleMessage("Academic"),
    "notificationAdmin": MessageLookupByLibrary.simpleMessage("Administration"),
    "notificationAnnouncements": MessageLookupByLibrary.simpleMessage(
      "Announcements",
    ),
    "notificationCategories": MessageLookupByLibrary.simpleMessage(
      "Notification categories",
    ),
    "notificationChannels": MessageLookupByLibrary.simpleMessage(
      "Notification channels",
    ),
    "notificationChat": MessageLookupByLibrary.simpleMessage("Chats"),
    "notificationFinance": MessageLookupByLibrary.simpleMessage(
      "Payments and subscriptions",
    ),
    "notificationHourAgo": MessageLookupByLibrary.simpleMessage("An hour ago"),
    "notificationHoursAgo": m17,
    "notificationInApp": MessageLookupByLibrary.simpleMessage(
      "In-app notifications",
    ),
    "notificationMinutesAgo": m18,
    "notificationNow": MessageLookupByLibrary.simpleMessage("Now"),
    "notificationPush": MessageLookupByLibrary.simpleMessage(
      "Device notifications",
    ),
    "notificationSettings": MessageLookupByLibrary.simpleMessage(
      "Notification settings",
    ),
    "notificationSupervisor": MessageLookupByLibrary.simpleMessage(
      "Supervision",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "notificationsEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "We will let you know when there is an update",
    ),
    "numberOfHours": MessageLookupByLibrary.simpleMessage("Number of Hours"),
    "numberOfHoursHint": MessageLookupByLibrary.simpleMessage(
      "Example: 12 hours",
    ),
    "oldPasswordLabel": MessageLookupByLibrary.simpleMessage("Old Password"),
    "oldPrice": m19,
    "oldPriceInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid old price",
    ),
    "onboardingSubtitle1": MessageLookupByLibrary.simpleMessage(
      "An educational platform that helps you develop your skills",
    ),
    "onboardingSubtitle2": MessageLookupByLibrary.simpleMessage(
      "Enjoy a flexible learning experience that fits your day and style",
    ),
    "onboardingSubtitle3": MessageLookupByLibrary.simpleMessage(
      "Interactive content that helps you learn in a more enjoyable way",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Start your learning journey easily",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Interactive lessons and engaging content",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Success starts here",
    ),
    "onlineNow": MessageLookupByLibrary.simpleMessage("Online now"),
    "openAction": MessageLookupByLibrary.simpleMessage("Open"),
    "openDocument": MessageLookupByLibrary.simpleMessage("Open Document"),
    "openFile": MessageLookupByLibrary.simpleMessage("Open File"),
    "openLink": MessageLookupByLibrary.simpleMessage("Open Link"),
    "openRecording": MessageLookupByLibrary.simpleMessage("Open Recording"),
    "openSessionLink": MessageLookupByLibrary.simpleMessage("Open lesson link"),
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "optionalDiscountCode": MessageLookupByLibrary.simpleMessage(
      "Discount code (optional)",
    ),
    "originalAmount": MessageLookupByLibrary.simpleMessage("Original price"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "package4Hours": MessageLookupByLibrary.simpleMessage("4-hour package"),
    "packageAccessScope": MessageLookupByLibrary.simpleMessage("Package Scope"),
    "packageCalculation": m20,
    "packageCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Package added successfully",
    ),
    "packageDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Package deleted successfully",
    ),
    "packageDetails": MessageLookupByLibrary.simpleMessage("Package Details"),
    "packageDuration": MessageLookupByLibrary.simpleMessage("Package Duration"),
    "packageDurationHint": MessageLookupByLibrary.simpleMessage(
      "Example: 4-Hour Package",
    ),
    "packageDurationInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid package duration",
    ),
    "packageExpiryText": MessageLookupByLibrary.simpleMessage(
      "Expires in 18 days. Auto renewal",
    ),
    "packageFormName": MessageLookupByLibrary.simpleMessage("Package Name"),
    "packageHoursType": MessageLookupByLibrary.simpleMessage("Hours Package"),
    "packageName": MessageLookupByLibrary.simpleMessage("Package Name"),
    "packageNameRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter the package name",
    ),
    "packageOldPrice": MessageLookupByLibrary.simpleMessage("Old Price"),
    "packagePrice": MessageLookupByLibrary.simpleMessage("Session Price"),
    "packageType": MessageLookupByLibrary.simpleMessage("Package Type"),
    "packageUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Package updated successfully",
    ),
    "packages": MessageLookupByLibrary.simpleMessage("Packages"),
    "packagesManagement": MessageLookupByLibrary.simpleMessage(
      "Package Management",
    ),
    "paidAmount": MessageLookupByLibrary.simpleMessage("Paid amount"),
    "paidAmountHint": MessageLookupByLibrary.simpleMessage("Example: SAR 512"),
    "parent": MessageLookupByLibrary.simpleMessage("Parent"),
    "parentAccount": MessageLookupByLibrary.simpleMessage("My Account"),
    "parentAddChild": MessageLookupByLibrary.simpleMessage("Add child"),
    "parentAddChildFailed": MessageLookupByLibrary.simpleMessage(
      "The child could not be added. Please try again.",
    ),
    "parentAddChildTitle": MessageLookupByLibrary.simpleMessage(
      "Add a new child",
    ),
    "parentAddressLine1": MessageLookupByLibrary.simpleMessage("Address"),
    "parentAddressLine2": MessageLookupByLibrary.simpleMessage(
      "Additional address details",
    ),
    "parentBackToChildren": MessageLookupByLibrary.simpleMessage(
      "Back to children",
    ),
    "parentCertificates": MessageLookupByLibrary.simpleMessage("Certificates"),
    "parentCheckPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Check payment status",
    ),
    "parentChildAccountStep": MessageLookupByLibrary.simpleMessage(
      "Child details",
    ),
    "parentChildAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Child added successfully",
    ),
    "parentChildEmailUsed": MessageLookupByLibrary.simpleMessage(
      "This email is already in use",
    ),
    "parentChildren": MessageLookupByLibrary.simpleMessage("Children"),
    "parentChoosePackage": MessageLookupByLibrary.simpleMessage("Choose"),
    "parentDailyPlans": MessageLookupByLibrary.simpleMessage("Daily Plans"),
    "parentEvaluations": MessageLookupByLibrary.simpleMessage("Evaluations"),
    "parentFirstPreparatoryGrade": MessageLookupByLibrary.simpleMessage(
      "First Preparatory Grade",
    ),
    "parentGuardian": MessageLookupByLibrary.simpleMessage("Parent"),
    "parentHomeTitle": MessageLookupByLibrary.simpleMessage("Home"),
    "parentInfo": MessageLookupByLibrary.simpleMessage("Parent Information"),
    "parentMessages": MessageLookupByLibrary.simpleMessage("Messages"),
    "parentName": MessageLookupByLibrary.simpleMessage("Parent Name"),
    "parentNameHint": MessageLookupByLibrary.simpleMessage("Enter parent name"),
    "parentNotifications": MessageLookupByLibrary.simpleMessage(
      "Notifications",
    ),
    "parentOpenPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Open payment page",
    ),
    "parentPackageSelected": MessageLookupByLibrary.simpleMessage("Selected"),
    "parentPackageStep": MessageLookupByLibrary.simpleMessage("Choose package"),
    "parentPackagesAndSubscription": MessageLookupByLibrary.simpleMessage(
      "Packages and Subscription",
    ),
    "parentPasswordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "parentPaymentAddress": MessageLookupByLibrary.simpleMessage(
      "Payment address",
    ),
    "parentPaymentAddressRequired": MessageLookupByLibrary.simpleMessage(
      "Please complete the payment address",
    ),
    "parentPaymentConfirmedWaiting": MessageLookupByLibrary.simpleMessage(
      "Payment is confirmed and awaiting final approval.",
    ),
    "parentPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Payment was not completed. You can try again.",
    ),
    "parentPaymentMethodOptional": MessageLookupByLibrary.simpleMessage(
      "Payment method (optional)",
    ),
    "parentPaymentProcessing": MessageLookupByLibrary.simpleMessage(
      "Checking payment status...",
    ),
    "parentPaymentStatusTimeout": MessageLookupByLibrary.simpleMessage(
      "We could not confirm the payment status yet.",
    ),
    "parentPaymentStep": MessageLookupByLibrary.simpleMessage("Payment"),
    "parentReceiptError": MessageLookupByLibrary.simpleMessage(
      "The receipt could not be submitted. Check the file and try again.",
    ),
    "parentReceiptPendingMessage": MessageLookupByLibrary.simpleMessage(
      "The receipt was submitted and is pending review.",
    ),
    "parentReceiptSelected": MessageLookupByLibrary.simpleMessage(
      "Receipt selected",
    ),
    "parentReferenceNumberOptional": MessageLookupByLibrary.simpleMessage(
      "Reference number (optional)",
    ),
    "parentRegion": MessageLookupByLibrary.simpleMessage("Region"),
    "parentRegistrationForm": MessageLookupByLibrary.simpleMessage(
      "Parent Registration Form",
    ),
    "parentRenew": MessageLookupByLibrary.simpleMessage("Renew"),
    "parentRetryPayment": MessageLookupByLibrary.simpleMessage("Retry payment"),
    "parentReviewStep": MessageLookupByLibrary.simpleMessage(
      "Price and discount review",
    ),
    "parentRole": MessageLookupByLibrary.simpleMessage("Parent"),
    "parentSchedule": MessageLookupByLibrary.simpleMessage("Schedule"),
    "parentSecondPreparatoryGrade": MessageLookupByLibrary.simpleMessage(
      "Second Preparatory Grade",
    ),
    "parentShowAll": MessageLookupByLibrary.simpleMessage("Show All"),
    "parentSingleSubjectRequired": MessageLookupByLibrary.simpleMessage(
      "Exactly one subject is required for this package",
    ),
    "parentSubjectsStep": MessageLookupByLibrary.simpleMessage(
      "Choose subjects",
    ),
    "parentSubmitPayment": MessageLookupByLibrary.simpleMessage(
      "Submit payment",
    ),
    "parentSubscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "parentSubscriptionEndsSoon": MessageLookupByLibrary.simpleMessage(
      "Laila\'s subscription will end in 5 days",
    ),
    "parentSubscriptionRenewHint": MessageLookupByLibrary.simpleMessage(
      "Renew it now to avoid suspension",
    ),
    "parentSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Subscriptions",
    ),
    "parentThirdPreparatoryGrade": MessageLookupByLibrary.simpleMessage(
      "Third Preparatory Grade",
    ),
    "parentUnableToOpenCheckout": MessageLookupByLibrary.simpleMessage(
      "Unable to open the payment link",
    ),
    "parentUnsupportedRegistrationMode": MessageLookupByLibrary.simpleMessage(
      "This curriculum registration mode is not supported.",
    ),
    "parentWelcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "parentYourChildren": MessageLookupByLibrary.simpleMessage("Your Children"),
    "participation": MessageLookupByLibrary.simpleMessage("Participation"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordAndConfirmRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter and confirm your password",
    ),
    "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Password cannot be empty.",
    ),
    "passwordChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Password changed successfully",
    ),
    "passwordHint": MessageLookupByLibrary.simpleMessage(
      "At least 6 characters",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters.",
    ),
    "passwordMustHaveNumber": MessageLookupByLibrary.simpleMessage(
      "Password must contain at least one number.",
    ),
    "passwordMustHaveUpperCase": MessageLookupByLibrary.simpleMessage(
      "Password must contain at least one uppercase letter.",
    ),
    "passwordWillBeUsed": MessageLookupByLibrary.simpleMessage(
      "You will use it to log in with your email after completing payment.",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match.",
    ),
    "paymentCompleted": MessageLookupByLibrary.simpleMessage("Paid"),
    "paymentConfirmedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Payment confirmed successfully",
    ),
    "paymentDoneOn": MessageLookupByLibrary.simpleMessage("Paid On"),
    "paymentInfo": MessageLookupByLibrary.simpleMessage("Payment Information"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "paymentMethods": MessageLookupByLibrary.simpleMessage("Payment methods"),
    "paymentReceipt": MessageLookupByLibrary.simpleMessage("Payment receipt"),
    "paymentReceiptRequired": MessageLookupByLibrary.simpleMessage(
      "Payment receipt image is required",
    ),
    "paymentStatus": MessageLookupByLibrary.simpleMessage("Payment Status"),
    "payrollAccountHolder": MessageLookupByLibrary.simpleMessage(
      "Account holder",
    ),
    "payrollAccountNumber": MessageLookupByLibrary.simpleMessage(
      "Account number",
    ),
    "payrollAddPayoutProfile": MessageLookupByLibrary.simpleMessage(
      "Add payout details",
    ),
    "payrollAdjustmentNote": MessageLookupByLibrary.simpleMessage(
      "Adjustment reason",
    ),
    "payrollAdjustments": MessageLookupByLibrary.simpleMessage(
      "Bonus and deductions",
    ),
    "payrollAllStatuses": MessageLookupByLibrary.simpleMessage("All statuses"),
    "payrollAllTeachers": MessageLookupByLibrary.simpleMessage("All teachers"),
    "payrollAmount": MessageLookupByLibrary.simpleMessage("Amount"),
    "payrollApplyFilters": MessageLookupByLibrary.simpleMessage(
      "Apply filters",
    ),
    "payrollBankAccount": MessageLookupByLibrary.simpleMessage("Bank account"),
    "payrollBankDestinationRequired": MessageLookupByLibrary.simpleMessage(
      "Enter an account number or IBAN",
    ),
    "payrollBankName": MessageLookupByLibrary.simpleMessage("Bank name"),
    "payrollBonus": MessageLookupByLibrary.simpleMessage("Bonus"),
    "payrollCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "payrollChooseReceipt": MessageLookupByLibrary.simpleMessage(
      "Choose receipt image",
    ),
    "payrollConfirmPayment": MessageLookupByLibrary.simpleMessage(
      "Confirm payment",
    ),
    "payrollContinueDraft": MessageLookupByLibrary.simpleMessage(
      "Continue draft",
    ),
    "payrollCreate": MessageLookupByLibrary.simpleMessage("Create payroll"),
    "payrollCurrentPeriod": MessageLookupByLibrary.simpleMessage(
      "Current period",
    ),
    "payrollCurriculumsCount": MessageLookupByLibrary.simpleMessage(
      "Curriculums",
    ),
    "payrollDeduction": MessageLookupByLibrary.simpleMessage("Deduction"),
    "payrollDraft": MessageLookupByLibrary.simpleMessage("Draft"),
    "payrollDuration": MessageLookupByLibrary.simpleMessage("Duration"),
    "payrollDurationMinutes": MessageLookupByLibrary.simpleMessage(
      "Duration in minutes",
    ),
    "payrollEditPayoutProfile": MessageLookupByLibrary.simpleMessage(
      "Edit payout details",
    ),
    "payrollEgyptian": MessageLookupByLibrary.simpleMessage("Egyptian"),
    "payrollEgyptianWork": MessageLookupByLibrary.simpleMessage("Egyptian"),
    "payrollExcludedSessions": m21,
    "payrollFilterAction": MessageLookupByLibrary.simpleMessage(
      "Filter payrolls",
    ),
    "payrollFilters": MessageLookupByLibrary.simpleMessage("Payroll filters"),
    "payrollFromDate": MessageLookupByLibrary.simpleMessage("From date"),
    "payrollGulf": MessageLookupByLibrary.simpleMessage("Gulf"),
    "payrollGulfWork": MessageLookupByLibrary.simpleMessage("Gulf"),
    "payrollHourlyRate": MessageLookupByLibrary.simpleMessage("Hourly rate"),
    "payrollIban": MessageLookupByLibrary.simpleMessage("IBAN"),
    "payrollIncluded": MessageLookupByLibrary.simpleMessage("Included"),
    "payrollInstapay": MessageLookupByLibrary.simpleMessage("InstaPay"),
    "payrollInstapayAddress": MessageLookupByLibrary.simpleMessage(
      "InstaPay address",
    ),
    "payrollInvalidAmount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid non-negative amount",
    ),
    "payrollNegativeTotal": MessageLookupByLibrary.simpleMessage(
      "Payroll total cannot be negative",
    ),
    "payrollNetTotal": MessageLookupByLibrary.simpleMessage("Net total"),
    "payrollNoMatchingTeachers": MessageLookupByLibrary.simpleMessage(
      "No teachers match the selected period or filters",
    ),
    "payrollNoPayoutProfile": MessageLookupByLibrary.simpleMessage(
      "No payout details. Add them before recording payment.",
    ),
    "payrollNoWork": MessageLookupByLibrary.simpleMessage(
      "No eligible work exists for this teacher in the selected period",
    ),
    "payrollPaid": MessageLookupByLibrary.simpleMessage("Paid"),
    "payrollPaidAt": MessageLookupByLibrary.simpleMessage("Payment date"),
    "payrollPaymentConfirmationBody": m22,
    "payrollPaymentConfirmationTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm payroll payment?",
    ),
    "payrollPaymentDetails": MessageLookupByLibrary.simpleMessage(
      "Payment details",
    ),
    "payrollPayoutDetails": MessageLookupByLibrary.simpleMessage(
      "Payout details",
    ),
    "payrollPayoutMethod": MessageLookupByLibrary.simpleMessage(
      "Payout method",
    ),
    "payrollPeriod": MessageLookupByLibrary.simpleMessage("Period"),
    "payrollReceiptInvalidType": MessageLookupByLibrary.simpleMessage(
      "Use a PNG, JPG, JPEG, or WebP image",
    ),
    "payrollReceiptMissing": MessageLookupByLibrary.simpleMessage(
      "The selected file is unavailable",
    ),
    "payrollReceiptRequired": MessageLookupByLibrary.simpleMessage(
      "Transfer receipt is required",
    ),
    "payrollReceiptTooLarge": MessageLookupByLibrary.simpleMessage(
      "The receipt must not exceed 5 MB",
    ),
    "payrollRemoveReceipt": MessageLookupByLibrary.simpleMessage(
      "Remove receipt",
    ),
    "payrollResetFilters": MessageLookupByLibrary.simpleMessage(
      "Reset filters",
    ),
    "payrollReviewSessions": MessageLookupByLibrary.simpleMessage(
      "Review sessions",
    ),
    "payrollSaveDraft": MessageLookupByLibrary.simpleMessage("Save as draft"),
    "payrollSessionDetails": MessageLookupByLibrary.simpleMessage(
      "Session details",
    ),
    "payrollSessionRate": MessageLookupByLibrary.simpleMessage("Session rate"),
    "payrollSessionsCount": MessageLookupByLibrary.simpleMessage("Sessions"),
    "payrollStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "payrollSystem": MessageLookupByLibrary.simpleMessage("System"),
    "payrollTeacherDetails": MessageLookupByLibrary.simpleMessage(
      "Teacher and period",
    ),
    "payrollToDate": MessageLookupByLibrary.simpleMessage("To date"),
    "payrollTotal": MessageLookupByLibrary.simpleMessage("Total"),
    "payrollTransactionReference": MessageLookupByLibrary.simpleMessage(
      "Transaction reference",
    ),
    "payrollTransferReceipt": MessageLookupByLibrary.simpleMessage(
      "Transfer receipt",
    ),
    "payrollUnprepared": MessageLookupByLibrary.simpleMessage("Unprepared"),
    "payrollViewDetails": MessageLookupByLibrary.simpleMessage("View details"),
    "payrollWallet": MessageLookupByLibrary.simpleMessage("Electronic wallet"),
    "payrollWalletPhone": MessageLookupByLibrary.simpleMessage("Wallet phone"),
    "payrollWalletProvider": MessageLookupByLibrary.simpleMessage(
      "Wallet provider",
    ),
    "payrollWorkSummary": MessageLookupByLibrary.simpleMessage("Work summary"),
    "pending": MessageLookupByLibrary.simpleMessage("In Progress"),
    "pendingMathSubtitle": MessageLookupByLibrary.simpleMessage(
      "Fractions lesson, waiting for a teacher",
    ),
    "pendingPayments": MessageLookupByLibrary.simpleMessage("Pending Payments"),
    "pendingReceipts": MessageLookupByLibrary.simpleMessage("Pending Receipts"),
    "pendingRegisterRequests": MessageLookupByLibrary.simpleMessage(
      "Register Requests Pending",
    ),
    "pendingRequests": MessageLookupByLibrary.simpleMessage("Pending Requests"),
    "pendingReview": MessageLookupByLibrary.simpleMessage("Pending Review"),
    "pendingScienceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Light lesson, waiting for a teacher",
    ),
    "pendingWaiting": MessageLookupByLibrary.simpleMessage("Pending"),
    "performance": MessageLookupByLibrary.simpleMessage("Performance"),
    "permanentlyDeleteFromSystem": MessageLookupByLibrary.simpleMessage(
      "Permanently delete from system",
    ),
    "personalProfile": MessageLookupByLibrary.simpleMessage("Personal Profile"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone number"),
    "physics": MessageLookupByLibrary.simpleMessage("Physics"),
    "planFile": MessageLookupByLibrary.simpleMessage("Plan file"),
    "planFileRequired": MessageLookupByLibrary.simpleMessage(
      "Plan file is required",
    ),
    "plansTitle": MessageLookupByLibrary.simpleMessage("Plans"),
    "platformsUsed": MessageLookupByLibrary.simpleMessage("Platforms used"),
    "pleaseAnswerAllQuestions": MessageLookupByLibrary.simpleMessage(
      "Please answer all questions",
    ),
    "pleaseChooseAtLeastOneGrade": MessageLookupByLibrary.simpleMessage(
      "Please choose at least one grade",
    ),
    "pleaseChooseAtLeastOneSubjectForEachGrade":
        MessageLookupByLibrary.simpleMessage(
          "Please choose at least one subject for each grade",
        ),
    "pleaseChooseCurriculumGrades": m23,
    "pleaseChooseCurriculumSubjects": m24,
    "pleaseChooseTeachingCurriculum": MessageLookupByLibrary.simpleMessage(
      "Please choose the curriculum you teach",
    ),
    "pleaseEnterSubjectsGrades": MessageLookupByLibrary.simpleMessage(
      "Please enter the subjects grades",
    ),
    "pleaseFillRequiredInfo": MessageLookupByLibrary.simpleMessage(
      "Please fill in all required fields",
    ),
    "pleaseSelectFile": MessageLookupByLibrary.simpleMessage(
      "Please select a file first",
    ),
    "pleaseSelectStudent": MessageLookupByLibrary.simpleMessage(
      "Please select a student",
    ),
    "poemAnalysis": MessageLookupByLibrary.simpleMessage("Poem Analysis"),
    "point": MessageLookupByLibrary.simpleMessage("Point"),
    "points": MessageLookupByLibrary.simpleMessage("Points"),
    "pointsCount": MessageLookupByLibrary.simpleMessage("points"),
    "pointsTipDescription": MessageLookupByLibrary.simpleMessage(
      "Make sure to submit weekly evaluations on time to earn 20 extra points weekly",
    ),
    "positiveWeekRequired": MessageLookupByLibrary.simpleMessage(
      "Enter a positive whole week number",
    ),
    "preferredDays": MessageLookupByLibrary.simpleMessage(
      "Preferred student schedule",
    ),
    "preferredDaysHint": MessageLookupByLibrary.simpleMessage(
      "Select preferred days and times",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "primaryGradeFive": MessageLookupByLibrary.simpleMessage("Grade 5 Primary"),
    "privacy": MessageLookupByLibrary.simpleMessage("الخصوصية"),
    "qarCurrency": MessageLookupByLibrary.simpleMessage("Qatari Riyal (QAR)"),
    "qarShort": MessageLookupByLibrary.simpleMessage("QAR"),
    "qatariCurriculum": MessageLookupByLibrary.simpleMessage(
      "Qatari Curriculum",
    ),
    "qatariCurriculumDesc": MessageLookupByLibrary.simpleMessage(
      "A curriculum approved by the Ministry of Education in Qatar, covering basic stages up to secondary school.",
    ),
    "qualification": MessageLookupByLibrary.simpleMessage("Qualification"),
    "quotaReport": MessageLookupByLibrary.simpleMessage("Quota report"),
    "quran": MessageLookupByLibrary.simpleMessage("Quran"),
    "ranking": MessageLookupByLibrary.simpleMessage("Ranking"),
    "rating": MessageLookupByLibrary.simpleMessage("Rating"),
    "readyGroupSubtitle": MessageLookupByLibrary.simpleMessage(
      "Math - Ready group",
    ),
    "recordings": MessageLookupByLibrary.simpleMessage("Recordings"),
    "registerAsParent": MessageLookupByLibrary.simpleMessage(
      "Register as Parent",
    ),
    "registerAsParentSubtitle": MessageLookupByLibrary.simpleMessage(
      "Track your children’s progress and contact teachers",
    ),
    "registerAsStudent": MessageLookupByLibrary.simpleMessage(
      "Register as Student",
    ),
    "registerAsStudentSubtitle": MessageLookupByLibrary.simpleMessage(
      "Join classes and start your learning journey",
    ),
    "registrationDate": MessageLookupByLibrary.simpleMessage(
      "Registration Date",
    ),
    "registrationMode": MessageLookupByLibrary.simpleMessage(
      "Registration Mode",
    ),
    "registrationRequestRejectedSuccessfully":
        MessageLookupByLibrary.simpleMessage(
          "Registration request rejected successfully",
        ),
    "registrationRequests": MessageLookupByLibrary.simpleMessage(
      "Registration Requests",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Reject"),
    "relationships": MessageLookupByLibrary.simpleMessage("Relationships"),
    "remainingDays": m25,
    "remainingHours": m26,
    "remainingSessions": MessageLookupByLibrary.simpleMessage("Remaining"),
    "renewSubscription": MessageLookupByLibrary.simpleMessage(
      "Renew subscription",
    ),
    "renewalAllSubjectsNoSelection": MessageLookupByLibrary.simpleMessage(
      "This package includes all subjects; no subject selection is required.",
    ),
    "renewalCompleted": MessageLookupByLibrary.simpleMessage(
      "The subscription was renewed successfully.",
    ),
    "renewalCurrentSubscription": MessageLookupByLibrary.simpleMessage(
      "Current subscription",
    ),
    "renewalExpiry": MessageLookupByLibrary.simpleMessage("Expiry date"),
    "renewalFailed": MessageLookupByLibrary.simpleMessage(
      "The subscription could not be renewed. Please try again.",
    ),
    "renewalIdempotencyRequired": MessageLookupByLibrary.simpleMessage(
      "A new payment attempt is required. Please try again.",
    ),
    "renewalPurchasedHours": MessageLookupByLibrary.simpleMessage(
      "Purchased hours",
    ),
    "renewalReceiptPending": MessageLookupByLibrary.simpleMessage(
      "The renewal request and receipt were submitted for review.",
    ),
    "renewalRemainingHours": MessageLookupByLibrary.simpleMessage(
      "Remaining hours",
    ),
    "renewalStudentAccessDenied": MessageLookupByLibrary.simpleMessage(
      "You are not allowed to renew this student\'s subscription.",
    ),
    "renewalSubjectNotAssigned": MessageLookupByLibrary.simpleMessage(
      "This subject is not assigned to the student.",
    ),
    "renewalSubscriptionStillActive": MessageLookupByLibrary.simpleMessage(
      "This subscription is still active and cannot be renewed yet.",
    ),
    "renewalUsedHours": MessageLookupByLibrary.simpleMessage("Used hours"),
    "reports": MessageLookupByLibrary.simpleMessage("Reports"),
    "requestAccepted": MessageLookupByLibrary.simpleMessage(
      "Your request has been accepted!",
    ),
    "requestNewLesson": MessageLookupByLibrary.simpleMessage(
      "Request New Lesson",
    ),
    "requestSubmittedUnderReview": MessageLookupByLibrary.simpleMessage(
      "Your request has been submitted and is now under review.",
    ),
    "resendCode": MessageLookupByLibrary.simpleMessage("Resend code?"),
    "resetCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter the verification code",
    ),
    "resetCodeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Check your email and enter the code sent to you",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordInstructions": MessageLookupByLibrary.simpleMessage(
      " and follow the instructions to reset your password.",
    ),
    "resetPasswordSuccessSubtitle": m27,
    "resetPasswordSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Sent successfully",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "revenues": MessageLookupByLibrary.simpleMessage("Revenues"),
    "reviewNewStudents": MessageLookupByLibrary.simpleMessage(
      "Review new students",
    ),
    "reviewPaidRequests": MessageLookupByLibrary.simpleMessage(
      "Review paid requests",
    ),
    "reviews": MessageLookupByLibrary.simpleMessage("Reviews"),
    "rewardPoints": MessageLookupByLibrary.simpleMessage("Reward Points"),
    "rewards": MessageLookupByLibrary.simpleMessage("Rewards"),
    "role": MessageLookupByLibrary.simpleMessage("Role"),
    "salary": MessageLookupByLibrary.simpleMessage("Salary"),
    "salaryCalculationFormula": MessageLookupByLibrary.simpleMessage(
      "Number of Sessions * Session Price",
    ),
    "salaryCalculationFormulaDesc": MessageLookupByLibrary.simpleMessage(
      "Base salary is calculated",
    ),
    "salaryCalculationMethod": MessageLookupByLibrary.simpleMessage(
      "Salary Calculation Method",
    ),
    "sampleExercisesHomework": MessageLookupByLibrary.simpleMessage(
      "Solve exercise 45",
    ),
    "sampleGrammarLesson": MessageLookupByLibrary.simpleMessage(
      "Grammar rules",
    ),
    "sampleQuadraticEquations": MessageLookupByLibrary.simpleMessage(
      "Quadratic equations",
    ),
    "sampleTeacherOne": MessageLookupByLibrary.simpleMessage("Sarah Abdullah"),
    "sampleTeacherTwo": MessageLookupByLibrary.simpleMessage("Mona Ahmed"),
    "sarCurrency": MessageLookupByLibrary.simpleMessage("Saudi Riyal (SAR)"),
    "sarShort": MessageLookupByLibrary.simpleMessage("SAR"),
    "saturday": MessageLookupByLibrary.simpleMessage("Saturday"),
    "saudi": MessageLookupByLibrary.simpleMessage("Saudi"),
    "saudiCurriculum": MessageLookupByLibrary.simpleMessage("Saudi Curriculum"),
    "saudiCurriculumDesc": MessageLookupByLibrary.simpleMessage(
      "We provide all subjects for primary, middle, and secondary stages according to the approved curriculum.",
    ),
    "saudiDepartment": MessageLookupByLibrary.simpleMessage("Saudi Department"),
    "saudiRiyal": MessageLookupByLibrary.simpleMessage("Saudi Riyal"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveAmount": m28,
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "savedInLocation": m29,
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
    "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
    "scheduleCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Schedule added successfully",
    ),
    "scheduleDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Schedule deleted successfully",
    ),
    "scheduleForDay": m30,
    "scheduleImageRequired": MessageLookupByLibrary.simpleMessage(
      "Please choose a schedule image",
    ),
    "scheduleUpdated": MessageLookupByLibrary.simpleMessage(
      "Next week schedule was updated",
    ),
    "schoolSubjects": MessageLookupByLibrary.simpleMessage("School Subjects"),
    "science": MessageLookupByLibrary.simpleMessage("Science"),
    "scoreRange": m31,
    "scoreRequired": MessageLookupByLibrary.simpleMessage("Score is required"),
    "searchByNameOrPhone": MessageLookupByLibrary.simpleMessage(
      "Search by name or phone",
    ),
    "searchForSubject": MessageLookupByLibrary.simpleMessage(
      "Search for a subject",
    ),
    "secondPrimaryClassroom": MessageLookupByLibrary.simpleMessage(
      "Second primary grade",
    ),
    "secondSecondaryClassroom": MessageLookupByLibrary.simpleMessage(
      "Second secondary grade",
    ),
    "sections": MessageLookupByLibrary.simpleMessage("Sections"),
    "selectChild": MessageLookupByLibrary.simpleMessage("Select Child"),
    "selectClassroom": MessageLookupByLibrary.simpleMessage("Select classroom"),
    "selectClassroomFirst": MessageLookupByLibrary.simpleMessage(
      "Select classroom first",
    ),
    "selectCurriculum": MessageLookupByLibrary.simpleMessage(
      "Select curriculum",
    ),
    "selectCurriculumFirst": MessageLookupByLibrary.simpleMessage(
      "Please select a curriculum",
    ),
    "selectFile": MessageLookupByLibrary.simpleMessage("Select File"),
    "selectGrade": MessageLookupByLibrary.simpleMessage("Select grade"),
    "selectGradeToViewAttendance": MessageLookupByLibrary.simpleMessage(
      "Select a grade to view attendance data",
    ),
    "selectIdealSupervisor": MessageLookupByLibrary.simpleMessage(
      "Select the ideal supervisor",
    ),
    "selectIdealTeacher": MessageLookupByLibrary.simpleMessage(
      "Select the ideal teacher",
    ),
    "selectLesson": MessageLookupByLibrary.simpleMessage("Select lesson"),
    "selectStudent": MessageLookupByLibrary.simpleMessage("Select Student"),
    "selectStudentFirst": MessageLookupByLibrary.simpleMessage(
      "Select student first",
    ),
    "selectSubject": MessageLookupByLibrary.simpleMessage("Select subject"),
    "selectTeacher": MessageLookupByLibrary.simpleMessage("Select teacher"),
    "selectWeek": MessageLookupByLibrary.simpleMessage("Select week"),
    "selectedLessonDatePreview": MessageLookupByLibrary.simpleMessage(
      "Thursday, 07 May 2026",
    ),
    "selectedPackage": MessageLookupByLibrary.simpleMessage("Selected Package"),
    "semesterName": MessageLookupByLibrary.simpleMessage("Semester Name"),
    "semesterOne": MessageLookupByLibrary.simpleMessage("Semester 1"),
    "semesterThree": MessageLookupByLibrary.simpleMessage("Semester 3"),
    "semesterTwo": MessageLookupByLibrary.simpleMessage("Semester 2"),
    "send": MessageLookupByLibrary.simpleMessage("Sent"),
    "sendAll": MessageLookupByLibrary.simpleMessage("Send All"),
    "sendCorrection": MessageLookupByLibrary.simpleMessage("Submit Grade"),
    "sendNotificationToParentAndStudent": MessageLookupByLibrary.simpleMessage(
      "Send notification to parent and student",
    ),
    "sendResetCode": MessageLookupByLibrary.simpleMessage("Send reset code"),
    "sendResetLink": MessageLookupByLibrary.simpleMessage("Send reset Code"),
    "sending": MessageLookupByLibrary.simpleMessage("Sending..."),
    "services": MessageLookupByLibrary.simpleMessage("Services"),
    "sessionRecording": MessageLookupByLibrary.simpleMessage(
      "Session Recording",
    ),
    "sessionStartUnauthorized": MessageLookupByLibrary.simpleMessage(
      "You are not authorized to start this lesson",
    ),
    "sessionStarted": MessageLookupByLibrary.simpleMessage("Lesson started"),
    "sessionStartedLinkOpenFailed": MessageLookupByLibrary.simpleMessage(
      "The lesson started, but its link could not be opened",
    ),
    "sessionStarting": MessageLookupByLibrary.simpleMessage("Starting lesson"),
    "sessionSubjectUnavailable": MessageLookupByLibrary.simpleMessage(
      "Subject data is unavailable",
    ),
    "sessionSummary": MessageLookupByLibrary.simpleMessage("Session Summary"),
    "sessions": MessageLookupByLibrary.simpleMessage("Sessions"),
    "sessionsThisMonth": MessageLookupByLibrary.simpleMessage(
      "Sessions This Month",
    ),
    "shortVideoLinkOptional": MessageLookupByLibrary.simpleMessage(
      "Short video link (optional)",
    ),
    "singleSubject": MessageLookupByLibrary.simpleMessage("Single Subject"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "socialStudies": MessageLookupByLibrary.simpleMessage("Social Studies"),
    "specialization": MessageLookupByLibrary.simpleMessage("Specialization"),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startDate": MessageLookupByLibrary.simpleMessage("Start date"),
    "startLessonViaZoom": MessageLookupByLibrary.simpleMessage(
      "Start lesson via Zoom",
    ),
    "startNow": MessageLookupByLibrary.simpleMessage("Start now"),
    "startSession": MessageLookupByLibrary.simpleMessage("Start lesson"),
    "startTime": MessageLookupByLibrary.simpleMessage("Start time"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "student": MessageLookupByLibrary.simpleMessage("student"),
    "studentAssignedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Student assigned successfully",
    ),
    "studentCertificate": MessageLookupByLibrary.simpleMessage(
      "Student Certificate",
    ),
    "studentEmail": MessageLookupByLibrary.simpleMessage("Student Email"),
    "studentInfo": MessageLookupByLibrary.simpleMessage("Student Information"),
    "studentName": MessageLookupByLibrary.simpleMessage("Student name"),
    "studentNotes": MessageLookupByLibrary.simpleMessage("Student Notes"),
    "studentNotesAndSchedule": MessageLookupByLibrary.simpleMessage(
      "Student notes and schedule preferences",
    ),
    "studentNotesAndScheduleHint": MessageLookupByLibrary.simpleMessage(
      "Notes about lessons that need explanation, goals, or any other comments",
    ),
    "studentNotesExample": MessageLookupByLibrary.simpleMessage(
      "Example: Needs explanation for fractions and long division ...",
    ),
    "studentPassword": MessageLookupByLibrary.simpleMessage(
      "Student platform password",
    ),
    "studentPasswordField": MessageLookupByLibrary.simpleMessage(
      "Student password",
    ),
    "studentProfileClass": MessageLookupByLibrary.simpleMessage("القسم المصري"),
    "studentProfileGrade": MessageLookupByLibrary.simpleMessage(
      "الصف الثاني الإعدادي",
    ),
    "studentRegistrationForm": MessageLookupByLibrary.simpleMessage(
      "Student Registration Form",
    ),
    "studentRequestAccepted": MessageLookupByLibrary.simpleMessage(
      "A study group will be created and the student will be transferred directly to you.",
    ),
    "studentUsesItForDashboard": MessageLookupByLibrary.simpleMessage(
      "The student will use it to log in to the dashboard",
    ),
    "students": MessageLookupByLibrary.simpleMessage("Students"),
    "studentsByDepartment": MessageLookupByLibrary.simpleMessage(
      "Students By Department",
    ),
    "studyCurriculaTitle": MessageLookupByLibrary.simpleMessage(
      "Study Curricula ",
    ),
    "studyMaterials": MessageLookupByLibrary.simpleMessage("Study Materials"),
    "studyPlanFor": MessageLookupByLibrary.simpleMessage("Study Plan"),
    "studyPlanTitlePrefix": MessageLookupByLibrary.simpleMessage(
      "Study plan for",
    ),
    "studySchedule": MessageLookupByLibrary.simpleMessage("Study Schedule"),
    "subject": MessageLookupByLibrary.simpleMessage("Subject"),
    "subjectCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Subject added successfully",
    ),
    "subjectLabel": MessageLookupByLibrary.simpleMessage("Subject"),
    "subjectName": MessageLookupByLibrary.simpleMessage("Subject Name"),
    "subjectRequestAdminReview": MessageLookupByLibrary.simpleMessage(
      "Awaiting admin review",
    ),
    "subjectRequestAssigned": MessageLookupByLibrary.simpleMessage(
      "Teacher assigned",
    ),
    "subjectRequestChoosePackage": MessageLookupByLibrary.simpleMessage(
      "Choose package",
    ),
    "subjectRequestChooseSubject": MessageLookupByLibrary.simpleMessage(
      "Choose subject",
    ),
    "subjectRequestMyRequests": MessageLookupByLibrary.simpleMessage(
      "My current requests",
    ),
    "subjectRequestNoPackages": MessageLookupByLibrary.simpleMessage(
      "No packages are currently available for a subject request",
    ),
    "subjectRequestNotesCounter": m32,
    "subjectRequestPaymentCompleted": MessageLookupByLibrary.simpleMessage(
      "Payment completed; searching for a teacher",
    ),
    "subjectRequestPaymentTimeout": MessageLookupByLibrary.simpleMessage(
      "Payment could not be confirmed automatically. Verify it manually.",
    ),
    "subjectRequestRejected": MessageLookupByLibrary.simpleMessage(
      "Request rejected",
    ),
    "subjectRequestSearchingTeacher": MessageLookupByLibrary.simpleMessage(
      "Searching for a teacher",
    ),
    "subjectRequestSubmitted": MessageLookupByLibrary.simpleMessage(
      "The request was sent to admin for review",
    ),
    "subjectRequestVerifyPayment": MessageLookupByLibrary.simpleMessage(
      "Verify payment status",
    ),
    "subjectRequired": MessageLookupByLibrary.simpleMessage(
      "Subject is required",
    ),
    "subjects": MessageLookupByLibrary.simpleMessage("Subjects"),
    "subjectsGrades": MessageLookupByLibrary.simpleMessage("Subjects Grades"),
    "subjectsManagement": MessageLookupByLibrary.simpleMessage(
      "Subjects Management",
    ),
    "submissionDate": MessageLookupByLibrary.simpleMessage("Submitted:"),
    "submitAssignment": MessageLookupByLibrary.simpleMessage(
      "Submit Assignment",
    ),
    "submitAssignmentCorrection": MessageLookupByLibrary.simpleMessage(
      "Grade Submission",
    ),
    "submitRequest": MessageLookupByLibrary.simpleMessage("Submit Request"),
    "submitted": MessageLookupByLibrary.simpleMessage("Submitted"),
    "submittedBadge": MessageLookupByLibrary.simpleMessage("Submitted"),
    "subscribeNow": MessageLookupByLibrary.simpleMessage("Subscribe now"),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "subscriptionEndsSoon": MessageLookupByLibrary.simpleMessage(
      "Your subscription ends in 5 days",
    ),
    "subscriptions": MessageLookupByLibrary.simpleMessage("Subscriptions"),
    "sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
    "supervisedClasses": MessageLookupByLibrary.simpleMessage(
      "Supervised classes",
    ),
    "supervisor": MessageLookupByLibrary.simpleMessage("Supervisor"),
    "supervisorAbdelfattah": MessageLookupByLibrary.simpleMessage(
      "Abdelfattah",
    ),
    "supervisorAssignedNotification": MessageLookupByLibrary.simpleMessage(
      "You were assigned as supervisor for third grade",
    ),
    "supervisorAssignment": MessageLookupByLibrary.simpleMessage(
      "Supervisor Assignment",
    ),
    "supervisorNotActive": MessageLookupByLibrary.simpleMessage(
      "The selected supervisor is not active",
    ),
    "supervisorNotFound": MessageLookupByLibrary.simpleMessage(
      "The selected supervisor no longer exists",
    ),
    "supervisorRequired": MessageLookupByLibrary.simpleMessage(
      "Supervisor is required",
    ),
    "supervisorSaraAhmed": MessageLookupByLibrary.simpleMessage("Sara Ahmed"),
    "supervisorSomaya": MessageLookupByLibrary.simpleMessage("Somaya"),
    "tabbyTamara": MessageLookupByLibrary.simpleMessage(
      "Split your bill with Tamara",
    ),
    "taughtOnlineBefore": MessageLookupByLibrary.simpleMessage(
      "Have you taught online before?",
    ),
    "taughtSubjects": MessageLookupByLibrary.simpleMessage("Taught subjects"),
    "teachableGrades": MessageLookupByLibrary.simpleMessage("Teachable grades"),
    "teacher": MessageLookupByLibrary.simpleMessage("teacher"),
    "teacherAhmedFouad": MessageLookupByLibrary.simpleMessage(
      "Mr. Ahmed Fouad",
    ),
    "teacherApplicationDetailsTitle": m33,
    "teacherApplications": MessageLookupByLibrary.simpleMessage(
      "Teacher Applications",
    ),
    "teacherApplySubtitle": MessageLookupByLibrary.simpleMessage(
      "Your application will be reviewed and we will reply to you soon",
    ),
    "teacherApplyTitle": MessageLookupByLibrary.simpleMessage(
      "Apply as a Teacher at Banan Academy",
    ),
    "teacherAssignedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Teacher assigned successfully",
    ),
    "teacherDeclarationAgreement": MessageLookupByLibrary.simpleMessage(
      "I confirm that all the information mentioned above is correct, and I agree to follow Banan Academy rules and policies",
    ),
    "teacherMyEarnings": MessageLookupByLibrary.simpleMessage("My Earnings"),
    "teacherNotAssignedToSessionSubject": MessageLookupByLibrary.simpleMessage(
      "No teacher is assigned to this subject",
    ),
    "teacherNote": MessageLookupByLibrary.simpleMessage("Teacher Note"),
    "teacherNoteText": MessageLookupByLibrary.simpleMessage(
      "Excellent work on solving the assignments this time.",
    ),
    "teacherPayrollAccountAddress": MessageLookupByLibrary.simpleMessage(
      "Address",
    ),
    "teacherPayrollAccountName": MessageLookupByLibrary.simpleMessage(
      "Account name",
    ),
    "teacherPayrollAddPayoutContact": MessageLookupByLibrary.simpleMessage(
      "Contact administration to add payout details.",
    ),
    "teacherPayrollAll": MessageLookupByLibrary.simpleMessage("All"),
    "teacherPayrollContactAdmin": MessageLookupByLibrary.simpleMessage(
      "Contact administration to update these details.",
    ),
    "teacherPayrollDraftNote": MessageLookupByLibrary.simpleMessage(
      "This amount is under review and may change before payment.",
    ),
    "teacherPayrollEmpty": MessageLookupByLibrary.simpleMessage(
      "No payroll earnings or reports yet",
    ),
    "teacherPayrollMethod": MessageLookupByLibrary.simpleMessage("Method"),
    "teacherPayrollNoPayout": MessageLookupByLibrary.simpleMessage(
      "No payout details are registered",
    ),
    "teacherPayrollNotTransferred": MessageLookupByLibrary.simpleMessage(
      "Payment has not been transferred yet",
    ),
    "teacherPayrollPaidAmount": MessageLookupByLibrary.simpleMessage("Paid"),
    "teacherPayrollPaidOn": MessageLookupByLibrary.simpleMessage("Paid on"),
    "teacherPayrollPaymentDetails": MessageLookupByLibrary.simpleMessage(
      "Payment Details",
    ),
    "teacherPayrollPayoutDetails": MessageLookupByLibrary.simpleMessage(
      "Payout Details",
    ),
    "teacherPayrollPreparingAmount": MessageLookupByLibrary.simpleMessage(
      "Preparing",
    ),
    "teacherPayrollReceipt": MessageLookupByLibrary.simpleMessage(
      "View payment receipt",
    ),
    "teacherPayrollReceiptLater": MessageLookupByLibrary.simpleMessage(
      "The transfer receipt will appear here after payment.",
    ),
    "teacherPayrollReport": MessageLookupByLibrary.simpleMessage(
      "Payroll Report",
    ),
    "teacherPayrollReportSummary": MessageLookupByLibrary.simpleMessage(
      "Report Summary",
    ),
    "teacherPayrollReportTitle": m34,
    "teacherPayrollTransferredTo": MessageLookupByLibrary.simpleMessage(
      "Transferred to",
    ),
    "teacherPayrollUnavailable": MessageLookupByLibrary.simpleMessage(
      "Payroll report is unavailable",
    ),
    "teacherPayrollUnderReview": MessageLookupByLibrary.simpleMessage(
      "Under Review",
    ),
    "teacherPayrollViewReport": MessageLookupByLibrary.simpleMessage(
      "View Report",
    ),
    "teacherPayrollViewReportReceipt": MessageLookupByLibrary.simpleMessage(
      "View Report & Receipt",
    ),
    "teacherPayrolls": MessageLookupByLibrary.simpleMessage("Teacher Payrolls"),
    "teacherRequestAcceptedSuccess": MessageLookupByLibrary.simpleMessage(
      "The request was accepted and the classroom was created successfully",
    ),
    "teacherRequestAlreadyAssigned": MessageLookupByLibrary.simpleMessage(
      "This request was accepted by another teacher",
    ),
    "teacherRequestNotEligible": MessageLookupByLibrary.simpleMessage(
      "The request cannot be accepted because the subject or grade teaching details changed",
    ),
    "teacherSarahName": MessageLookupByLibrary.simpleMessage(
      "Ms. Sarah Abdullah",
    ),
    "teacherSarahShort": MessageLookupByLibrary.simpleMessage("Ms. Sarah"),
    "teacherStepAttachments": MessageLookupByLibrary.simpleMessage(
      "Attachments and Declaration",
    ),
    "teacherStepEvaluation": MessageLookupByLibrary.simpleMessage("Evaluation"),
    "teacherStepExperience": MessageLookupByLibrary.simpleMessage(
      "Work Experience",
    ),
    "teacherStepPersonalInfo": MessageLookupByLibrary.simpleMessage(
      "Personal Information",
    ),
    "teacherStepQualification": MessageLookupByLibrary.simpleMessage(
      "Academic Qualification",
    ),
    "teacherStepTeachingDetails": MessageLookupByLibrary.simpleMessage(
      "Teaching Details",
    ),
    "teacherStepTechnicalSkills": MessageLookupByLibrary.simpleMessage(
      "Technical Skills",
    ),
    "teacherUnassignedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Teacher assignment removed successfully",
    ),
    "teachers": MessageLookupByLibrary.simpleMessage("Teachers"),
    "teachingInBnan": MessageLookupByLibrary.simpleMessage("Teaching in Bnan"),
    "technicalAppsLevel": MessageLookupByLibrary.simpleMessage(
      "What is your level of using Computer?",
    ),
    "termPlan": MessageLookupByLibrary.simpleMessage("Term Plan"),
    "termPlanUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Term plan uploaded successfully",
    ),
    "theRequiredLesson": MessageLookupByLibrary.simpleMessage(
      "The required lesson",
    ),
    "theSupervisor": MessageLookupByLibrary.simpleMessage("The SuperVisor"),
    "thirdTermExercises": MessageLookupByLibrary.simpleMessage(
      "Third Term Exercises",
    ),
    "threeDaysAgo": MessageLookupByLibrary.simpleMessage("3 days ago"),
    "thursday": MessageLookupByLibrary.simpleMessage("Thursday"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "tipToIncreasePoints": MessageLookupByLibrary.simpleMessage(
      "Tip to Increase Points",
    ),
    "to": MessageLookupByLibrary.simpleMessage("To"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "todayAtTime": m35,
    "todayClasses": MessageLookupByLibrary.simpleMessage("Today\'s Classes"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalSessions": MessageLookupByLibrary.simpleMessage("Total Sessions"),
    "totalStudents": MessageLookupByLibrary.simpleMessage("Total Students"),
    "trainingHours": m36,
    "tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
    "twelveHoursPlan": MessageLookupByLibrary.simpleMessage("12-hour package"),
    "twentyHoursPlan": MessageLookupByLibrary.simpleMessage("20-hour package"),
    "twoDaysAgo": MessageLookupByLibrary.simpleMessage("2 days ago"),
    "typeMessage": MessageLookupByLibrary.simpleMessage("Type message....."),
    "unableToDownloadFile": MessageLookupByLibrary.simpleMessage(
      "Unable to download file",
    ),
    "unableToLoadAttachment": MessageLookupByLibrary.simpleMessage(
      "Unable to load the attachment",
    ),
    "unableToLoadSubjects": MessageLookupByLibrary.simpleMessage(
      "Unable to load subjects",
    ),
    "unableToOpenAttachment": MessageLookupByLibrary.simpleMessage(
      "Unable to open the attachment",
    ),
    "unableToOpenDocument": MessageLookupByLibrary.simpleMessage(
      "Unable to open the document",
    ),
    "unableToOpenFile": MessageLookupByLibrary.simpleMessage(
      "Unable to open the file",
    ),
    "unableToOpenLink": MessageLookupByLibrary.simpleMessage(
      "Unable to open link",
    ),
    "unableToOpenPaymentReceipt": MessageLookupByLibrary.simpleMessage(
      "Unable to open payment receipt",
    ),
    "unableToOpenSessionRecording": MessageLookupByLibrary.simpleMessage(
      "Unable to open the session recording",
    ),
    "unableToOpenWhatsApp": MessageLookupByLibrary.simpleMessage(
      "Unable to open WhatsApp",
    ),
    "underProcessing": MessageLookupByLibrary.simpleMessage("Under Processing"),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred",
    ),
    "universityOrInstitutionName": MessageLookupByLibrary.simpleMessage(
      "University / Institution Name",
    ),
    "upcomingLesson": MessageLookupByLibrary.simpleMessage("Upcoming Lesson"),
    "upcomingLessons": MessageLookupByLibrary.simpleMessage("Upcoming Lessons"),
    "upgradePackage": MessageLookupByLibrary.simpleMessage("Upgrade Package"),
    "uploadAction": MessageLookupByLibrary.simpleMessage("Upload"),
    "uploadAssignment": MessageLookupByLibrary.simpleMessage(
      "Upload Assignment",
    ),
    "uploadCertificateFile": MessageLookupByLibrary.simpleMessage(
      "Upload certificate or qualification image (image/pdf)",
    ),
    "uploadCvFile": MessageLookupByLibrary.simpleMessage("Upload CV (pdf)"),
    "uploadNationalIdFile": MessageLookupByLibrary.simpleMessage(
      "Upload national ID / identity image (image/pdf)",
    ),
    "uploadPaymentReceipt": MessageLookupByLibrary.simpleMessage(
      "Upload receipt image",
    ),
    "uploadReceipt": MessageLookupByLibrary.simpleMessage("Upload Receipt"),
    "uploadSchedule": MessageLookupByLibrary.simpleMessage("Upload Schedule"),
    "uploadStudyPlan": MessageLookupByLibrary.simpleMessage(
      "Upload study plan",
    ),
    "usedDays": m37,
    "usedHours": m38,
    "userCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "User created successfully",
    ),
    "userDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "User deleted successfully",
    ),
    "userDetails": MessageLookupByLibrary.simpleMessage("User Details"),
    "userName": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
    "userPasswordUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "User password updated successfully",
    ),
    "userRole": MessageLookupByLibrary.simpleMessage("User Role"),
    "userStatusUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "User status updated successfully",
    ),
    "userUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "User updated successfully",
    ),
    "usersCount": m39,
    "usersManagement": MessageLookupByLibrary.simpleMessage("Users Management"),
    "validIntegerScore": MessageLookupByLibrary.simpleMessage(
      "Enter a valid integer score",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "veryGood": MessageLookupByLibrary.simpleMessage("Very Good"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
    "viewTermPlan": MessageLookupByLibrary.simpleMessage("View Term Plan"),
    "visibleToCustomers": MessageLookupByLibrary.simpleMessage(
      "Visible to Customers",
    ),
    "waitingForCorrection": MessageLookupByLibrary.simpleMessage(
      "Waiting for Grading",
    ),
    "waitingForReceiptReview": MessageLookupByLibrary.simpleMessage(
      "Waiting for receipt review",
    ),
    "waitingForTeacherApproval": MessageLookupByLibrary.simpleMessage(
      "Waiting for teacher approval",
    ),
    "wallet": MessageLookupByLibrary.simpleMessage("Electronic wallet"),
    "wednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
    "week": MessageLookupByLibrary.simpleMessage("Week"),
    "weekDays": MessageLookupByLibrary.simpleMessage("Week days"),
    "weekNumber": m40,
    "weekOne": MessageLookupByLibrary.simpleMessage("Week 1"),
    "weekStart": MessageLookupByLibrary.simpleMessage("Week Start"),
    "weekTwo": MessageLookupByLibrary.simpleMessage("Week 2"),
    "weeklyEvaluation": MessageLookupByLibrary.simpleMessage(
      "Weekly evaluation",
    ),
    "weeklyEvaluationAddedNotification": MessageLookupByLibrary.simpleMessage(
      "A weekly evaluation was added for class 4A",
    ),
    "weeklyEvaluationStudentTitle": m41,
    "weeklyEvaluations": MessageLookupByLibrary.simpleMessage(
      "Weekly Evaluations",
    ),
    "weeklyEvaluationsGulfClassroomConflict": MessageLookupByLibrary.simpleMessage(
      "There is a problem with the classroom subject setup. Please contact administration",
    ),
    "weeklyEvaluationsStudentAccessDenied":
        MessageLookupByLibrary.simpleMessage(
          "You are not authorized to view this student\'s data",
        ),
    "weeklyHours": MessageLookupByLibrary.simpleMessage("Weekly hours"),
    "weeklyIdealStudent": MessageLookupByLibrary.simpleMessage(
      "Weekly Ideal Student",
    ),
    "weeklyIdealStudentsRanking": MessageLookupByLibrary.simpleMessage(
      "Weekly Ideal Students Ranking",
    ),
    "weeklyLessons": m42,
    "weeklyPlans": MessageLookupByLibrary.simpleMessage("Weekly Plans"),
    "welcomeYou": MessageLookupByLibrary.simpleMessage("Welcome"),
    "whatsappNumber": MessageLookupByLibrary.simpleMessage("WhatsApp number"),
    "whyJoinBananAcademy": MessageLookupByLibrary.simpleMessage(
      "Why do you want to join Banan Academy?",
    ),
    "withTeacher": MessageLookupByLibrary.simpleMessage(
      "With Ms. Sarah Abdullah",
    ),
    "years": MessageLookupByLibrary.simpleMessage("Years"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
  };
}
