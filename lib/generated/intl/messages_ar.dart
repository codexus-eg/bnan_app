// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(teacherName) => "توظيف ${teacherName} في مادة";

  static String m1(percent) => "متوسط ${percent}%";

  static String m2(gradeName, subjectName) =>
      "هل تريد إلغاء توظيف هذا المعلم من ${gradeName} - ${subjectName} ؟";

  static String m3(price) => "${price} ر.س";

  static String m4(days) => "باقة ${days} أيام";

  static String m5(name) => "هل تريد تعطيل حساب ${name}؟";

  static String m6(statusCode) => "خطأ غير معروف: ${statusCode}";

  static String m7(fieldName) => "برجاء إدخال ${fieldName}";

  static String m8(grade) => "الدرجة: ${grade}";

  static String m9(count) => "${count} صف دراسي";

  static String m10(hours) => "${hours} ساعة";

  static String m11(teachers, points) =>
      "المرتبة التالية بعد ${teachers} معلماً، ${points} نقطة للمستوى التالي";

  static String m12(price) => "${price} ر.س";

  static String m13(price, studentsCount, total) =>
      "${price} ريال × ${studentsCount} طالب = ${total} ريال";

  static String m14(curriculum) => "برجاء اختيار صفوف المنهج ${curriculum}";

  static String m15(curriculum) => "برجاء اختيار مواد المنهج ${curriculum}";

  static String m16(days) => "${days} أيام متبقية";

  static String m17(hours) => "${hours} ساعات متبقية";

  static String m18(email) =>
      "تحقق من بريدك الإلكتروني ${email} واتبع التعليمات لإعادة تعيين كلمة المرور.";

  static String m19(amount) => "وفر ${amount} ر.س";

  static String m20(name) => "تفاصيل الطلب - ${name}";

  static String m21(time) => "اليوم، ${time}";

  static String m22(hours) => "${hours} ساعة تدريبية";

  static String m23(used, total) => "تم استخدام ${used} من ${total} أيام";

  static String m24(used, total) => "تم استخدام ${used} من ${total}";

  static String m25(count) => "${count} مستخدم";

  static String m26(count) => "${count} محاضرة أسبوعية";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Packages": MessageLookupByLibrary.simpleMessage("باقات"),
        "PackagesandSubscriptions":
            MessageLookupByLibrary.simpleMessage("الباقات والاشتراكات"),
        "absence": MessageLookupByLibrary.simpleMessage("غياب"),
        "absent": MessageLookupByLibrary.simpleMessage("غياب"),
        "academicPerformanceMessage":
            MessageLookupByLibrary.simpleMessage("للتميز في الأداء الأكاديمي"),
        "accept": MessageLookupByLibrary.simpleMessage("قبول"),
        "acceptRequest": MessageLookupByLibrary.simpleMessage("قبول الطلب"),
        "acceptStudentRequest":
            MessageLookupByLibrary.simpleMessage("قبول طلب"),
        "active": MessageLookupByLibrary.simpleMessage("نشطة"),
        "active2": MessageLookupByLibrary.simpleMessage("نشط"),
        "activeGroups":
            MessageLookupByLibrary.simpleMessage("المجموعات النشطة"),
        "activeSubscriptions":
            MessageLookupByLibrary.simpleMessage("اشتراكات نشطة"),
        "addNewChapter": MessageLookupByLibrary.simpleMessage("إضافة فصل جديد"),
        "addNewCurriculum":
            MessageLookupByLibrary.simpleMessage("إضافة منهج جديد"),
        "addNewEvaluation":
            MessageLookupByLibrary.simpleMessage("إضافة تقييم جديد"),
        "addNewGrade": MessageLookupByLibrary.simpleMessage("إضافة صف جديد"),
        "addNewSchedule":
            MessageLookupByLibrary.simpleMessage("إضافة جدول جديد"),
        "addNewSemester":
            MessageLookupByLibrary.simpleMessage("إضافة فصل جديد"),
        "addNewSubject":
            MessageLookupByLibrary.simpleMessage("إضافة مادة جديد"),
        "addNewUser": MessageLookupByLibrary.simpleMessage("إضافة مستخدم جديد"),
        "addRewardPointsDesc": MessageLookupByLibrary.simpleMessage(
            "يتم احتساب المكافآت بناءً على الأداء"),
        "addRewardPointsTitle":
            MessageLookupByLibrary.simpleMessage("إضافة نقاط التميز"),
        "addSubject": MessageLookupByLibrary.simpleMessage("إضافة مادة"),
        "addUser": MessageLookupByLibrary.simpleMessage("إضافة مستخدم"),
        "admin": MessageLookupByLibrary.simpleMessage("أدمن"),
        "adminSupervisors": MessageLookupByLibrary.simpleMessage("مشرفين"),
        "adminUsers": MessageLookupByLibrary.simpleMessage("مستخدمين"),
        "algebraCourseCertificate":
            MessageLookupByLibrary.simpleMessage("شهادة إتمام دورة الجبر"),
        "all": MessageLookupByLibrary.simpleMessage("الكل"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("لديك حساب؟ "),
        "amount": MessageLookupByLibrary.simpleMessage("المبلغ"),
        "applePay": MessageLookupByLibrary.simpleMessage("أبل باي"),
        "applyAsTeacher": MessageLookupByLibrary.simpleMessage("التقديم كمعلم"),
        "applyAsTeacherSubtitle": MessageLookupByLibrary.simpleMessage(
            "شارك خبراتك وانضم إلى فريقنا التعليمي"),
        "approveAccountActivation":
            MessageLookupByLibrary.simpleMessage("موافقة تفعيل الحساب"),
        "april2026": MessageLookupByLibrary.simpleMessage("أبريل 2026"),
        "arabic": MessageLookupByLibrary.simpleMessage("عربي"),
        "arabicLanguage": MessageLookupByLibrary.simpleMessage("اللغة العربية"),
        "assignSubject": MessageLookupByLibrary.simpleMessage("توظيف في مادة"),
        "assignTeacherInSubject": m0,
        "assignmentDescription": MessageLookupByLibrary.simpleMessage("الوصف"),
        "assignmentNotSubmittedYet":
            MessageLookupByLibrary.simpleMessage("لم يسلم الواجب بعد"),
        "assignmentSubmittedSuccessfully":
            MessageLookupByLibrary.simpleMessage("تم رفع الواجب بنجاح"),
        "assignmentTitle": MessageLookupByLibrary.simpleMessage("العنوان"),
        "assignments": MessageLookupByLibrary.simpleMessage("الواجبات"),
        "assignmentsEvaluation":
            MessageLookupByLibrary.simpleMessage("تقييم الواجبات"),
        "atLeastSixChars":
            MessageLookupByLibrary.simpleMessage("6 أحرف على الأقل"),
        "attachedFile": MessageLookupByLibrary.simpleMessage("ملف مرفق"),
        "attachmentFile": MessageLookupByLibrary.simpleMessage("ملف مرفق"),
        "attendance": MessageLookupByLibrary.simpleMessage("الحضور"),
        "attendanceRate": MessageLookupByLibrary.simpleMessage("نسبة الحضور"),
        "availability": MessageLookupByLibrary.simpleMessage("الأوقات المتاحة"),
        "available": MessageLookupByLibrary.simpleMessage("المتاحة"),
        "availableDay": MessageLookupByLibrary.simpleMessage("اليوم المتاح"),
        "averagePercent": m1,
        "backToLogin":
            MessageLookupByLibrary.simpleMessage("العودة لتسجيل الدخول"),
        "behavior": MessageLookupByLibrary.simpleMessage("السلوك"),
        "biology": MessageLookupByLibrary.simpleMessage("الأحياء"),
        "birthDate": MessageLookupByLibrary.simpleMessage("تاريخ الميلاد"),
        "browseSection": MessageLookupByLibrary.simpleMessage("تصفح القسم"),
        "canChangeCurrency": MessageLookupByLibrary.simpleMessage(
            "يمكنك تغيير العملة من القائمة"),
        "canDemo":
            MessageLookupByLibrary.simpleMessage("هل يمكن تقديم درس تجريبي؟"),
        "canProvideTrialLesson":
            MessageLookupByLibrary.simpleMessage("هل يمكنك تقديم حصة تجريبية؟"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "cancelAssignment": MessageLookupByLibrary.simpleMessage("إلغاء توظيف"),
        "cancelAssignmentMessage": m2,
        "cardHolderName":
            MessageLookupByLibrary.simpleMessage("اسم حامل البطاقة"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("رقم الكارت"),
        "certificateReceived":
            MessageLookupByLibrary.simpleMessage("حصلت على شهادة شهر مايو"),
        "certificates": MessageLookupByLibrary.simpleMessage("الشهادات"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("تغيير كلمة المرور"),
        "changePasswordTitle":
            MessageLookupByLibrary.simpleMessage("تعديل كلمة المرور"),
        "changePhoneTitle":
            MessageLookupByLibrary.simpleMessage("تعديل رقم الهاتف"),
        "changeUsernameTitle":
            MessageLookupByLibrary.simpleMessage("تعديل اسم المستخدم"),
        "chatMsg1": MessageLookupByLibrary.simpleMessage(
            "أهلا أحمد، كيف الأداء في الواجب الجديد؟"),
        "chatMsg2": MessageLookupByLibrary.simpleMessage(
            "تمام أ/ سارة وشكراً على الإنشاء."),
        "chatMsg3": MessageLookupByLibrary.simpleMessage(
            "ممتاز، لا تنسى مراجعة الفصل الثالث قبل الحصة."),
        "chatMsg4": MessageLookupByLibrary.simpleMessage("تمام، سأبدأ الآن"),
        "checkYourEmailPrefix":
            MessageLookupByLibrary.simpleMessage("تحقق من بريدك الإلكتروني "),
        "chemistry": MessageLookupByLibrary.simpleMessage("الكيمياء"),
        "children": MessageLookupByLibrary.simpleMessage("الأبناء"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("اختر نوع الحساب للمتابعة"),
        "chooseClassRoom": MessageLookupByLibrary.simpleMessage("اختر الفصل"),
        "chooseCurriculum": MessageLookupByLibrary.simpleMessage(
            "اختر المنهج الدراسي المناسب لأبنائك وابدأ رحلة التعليم معنا"),
        "chooseFile": MessageLookupByLibrary.simpleMessage("اختر ملف"),
        "chooseGrade": MessageLookupByLibrary.simpleMessage("اختر الصف"),
        "chooseNewCurriculum":
            MessageLookupByLibrary.simpleMessage("اختر المنهج"),
        "chooseSubject": MessageLookupByLibrary.simpleMessage("اختر المادة"),
        "city": MessageLookupByLibrary.simpleMessage("المدينة"),
        "classDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الفصل"),
        "classLabel": MessageLookupByLibrary.simpleMessage("الفصول"),
        "className": MessageLookupByLibrary.simpleMessage("اسم الفصل"),
        "classNameRequired":
            MessageLookupByLibrary.simpleMessage("اسم الفصل مطلوب"),
        "classR": MessageLookupByLibrary.simpleMessage("فصل"),
        "classRoom": MessageLookupByLibrary.simpleMessage("الفصل"),
        "classSchedulesManagement":
            MessageLookupByLibrary.simpleMessage("إدارة جداول الصفوف"),
        "classes": MessageLookupByLibrary.simpleMessage("الصفوف"),
        "classesCount": MessageLookupByLibrary.simpleMessage("الحصص"),
        "classesManagement":
            MessageLookupByLibrary.simpleMessage("إدارة الفصول"),
        "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
        "completed": MessageLookupByLibrary.simpleMessage("مكتمل"),
        "completedSessions":
            MessageLookupByLibrary.simpleMessage("الحصص المكتملة"),
        "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
        "confirmDelete": MessageLookupByLibrary.simpleMessage(
            "هل أنت متأكد أنك تريد الحذف؟"),
        "confirmNewPassword":
            MessageLookupByLibrary.simpleMessage("تأكيد كلمة المرور"),
        "confirmPasswordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "تأكيد كلمة المرور لا يمكن أن يكون فارغًا."),
        "confirmPasswordLabel":
            MessageLookupByLibrary.simpleMessage("تأكيد كلمة المرور"),
        "confirmRequest": MessageLookupByLibrary.simpleMessage("تأكيد الطلب"),
        "congrats": MessageLookupByLibrary.simpleMessage("مبروك"),
        "congratsThisMonth":
            MessageLookupByLibrary.simpleMessage("إتقان هذا الشهر"),
        "contactInfo": MessageLookupByLibrary.simpleMessage("معلومات الاتصال"),
        "contactWhatsApp": MessageLookupByLibrary.simpleMessage("تواصل واتساب"),
        "correctAssignment":
            MessageLookupByLibrary.simpleMessage("تصحيح الواجب"),
        "country": MessageLookupByLibrary.simpleMessage("الدولة"),
        "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
        "createAssignment":
            MessageLookupByLibrary.simpleMessage("إنشاء الواجب"),
        "createNewAccount":
            MessageLookupByLibrary.simpleMessage("إنشاء حساب جديد"),
        "createNewAssignment":
            MessageLookupByLibrary.simpleMessage("إنشاء واجب جديد"),
        "creditCard": MessageLookupByLibrary.simpleMessage("بطاقة إئتمانية"),
        "currency": MessageLookupByLibrary.simpleMessage("العملة:"),
        "currentMonth": MessageLookupByLibrary.simpleMessage("الشهر الحالي"),
        "currentPrice": m3,
        "currentProfits":
            MessageLookupByLibrary.simpleMessage("الأرباح الحالية"),
        "curricula": MessageLookupByLibrary.simpleMessage("المناهج"),
        "curriculum": MessageLookupByLibrary.simpleMessage("المنهج"),
        "curriculumName": MessageLookupByLibrary.simpleMessage("اسم المنهج"),
        "curriculumRequired":
            MessageLookupByLibrary.simpleMessage("المنهج مطلوب"),
        "curriculumSelection":
            MessageLookupByLibrary.simpleMessage("اختيار المنهج"),
        "curriculums": MessageLookupByLibrary.simpleMessage("المناهج"),
        "cv": MessageLookupByLibrary.simpleMessage("CV"),
        "cvv": MessageLookupByLibrary.simpleMessage("رمز التحقق CVV"),
        "dailyProfits": MessageLookupByLibrary.simpleMessage("الأرباح اليومية"),
        "dashboard": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "day": MessageLookupByLibrary.simpleMessage("يوم"),
        "days": MessageLookupByLibrary.simpleMessage("أيام"),
        "daysPackage": m4,
        "deductionsDesc":
            MessageLookupByLibrary.simpleMessage("الغياب أو التأخير"),
        "deductionsTitle":
            MessageLookupByLibrary.simpleMessage("خصم أي استقطاعات"),
        "degree": MessageLookupByLibrary.simpleMessage("الدرجة"),
        "delete": MessageLookupByLibrary.simpleMessage("حذف"),
        "deleteAssignment": MessageLookupByLibrary.simpleMessage("حذف الواجب"),
        "deleteAssignmentConfirmation": MessageLookupByLibrary.simpleMessage(
            "هل أنت متأكد من حذف هذا الواجب؟"),
        "deliveryDate": MessageLookupByLibrary.simpleMessage("موعد التسليم"),
        "desiredSubjects":
            MessageLookupByLibrary.simpleMessage("المواد المرغوبة"),
        "details": MessageLookupByLibrary.simpleMessage("التفاصيل"),
        "disable": MessageLookupByLibrary.simpleMessage("تعطيل"),
        "disableUserDescription": MessageLookupByLibrary.simpleMessage(
            "لن يستطيع الدخول حتى تقوم بتفعيله."),
        "disableUserQuestion": m5,
        "discounts": MessageLookupByLibrary.simpleMessage("خصومات"),
        "doNotHaveAccount":
            MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟ "),
        "download": MessageLookupByLibrary.simpleMessage("تحميل"),
        "downloadPdf": MessageLookupByLibrary.simpleMessage("تحميل PDF"),
        "dueFriday": MessageLookupByLibrary.simpleMessage("حتى الجمعة"),
        "dueSunday": MessageLookupByLibrary.simpleMessage("حتى الأحد"),
        "dues": MessageLookupByLibrary.simpleMessage("المستحقات"),
        "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
        "editCertificate":
            MessageLookupByLibrary.simpleMessage("تعديل الشهادة"),
        "editClass": MessageLookupByLibrary.simpleMessage("تعديل الفصل"),
        "editData": MessageLookupByLibrary.simpleMessage("تعديل البيانات"),
        "editEvaluation": MessageLookupByLibrary.simpleMessage("تعديل التقييم"),
        "editGrade": MessageLookupByLibrary.simpleMessage("تعديل الدرجة"),
        "editSubject": MessageLookupByLibrary.simpleMessage("تعديل المادة"),
        "egpCurrency": MessageLookupByLibrary.simpleMessage("جنيه مصري (ج.م)"),
        "egpShort": MessageLookupByLibrary.simpleMessage("ج.م"),
        "egyptianCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج المصري"),
        "egyptianCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "تعليم متكامل للصفوف الابتدائية والإعدادية والثانوية وفق المنهج المصري الحديث."),
        "egyptianDepartment":
            MessageLookupByLibrary.simpleMessage("القسم المصري"),
        "egyptianPound": MessageLookupByLibrary.simpleMessage("الجنيه المصري"),
        "eightHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 8 ساعات"),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "البريد الإلكتروني لا يمكن أن يكون فارغًا."),
        "emailRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال البريد الإلكتروني"),
        "emiratiCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج الإماراتي"),
        "english": MessageLookupByLibrary.simpleMessage("إنجليزي"),
        "errorBadCertificate":
            MessageLookupByLibrary.simpleMessage("شهادة SSL غير موثوقة."),
        "errorBadRequest":
            MessageLookupByLibrary.simpleMessage("طلب غير صالح."),
        "errorCancel": MessageLookupByLibrary.simpleMessage("تم إلغاء الطلب."),
        "errorConnectionTimeout":
            MessageLookupByLibrary.simpleMessage("انتهت مهلة الاتصال بالخادم."),
        "errorForbidden":
            MessageLookupByLibrary.simpleMessage("تم رفض الوصول."),
        "errorInternalServer":
            MessageLookupByLibrary.simpleMessage("خطأ داخلي في الخادم."),
        "errorNoInternet":
            MessageLookupByLibrary.simpleMessage("لا يوجد اتصال بالإنترنت."),
        "errorNotFound":
            MessageLookupByLibrary.simpleMessage("العنصر غير موجود."),
        "errorReceiveTimeout":
            MessageLookupByLibrary.simpleMessage("انتهت مهلة استلام البيانات."),
        "errorSendTimeout":
            MessageLookupByLibrary.simpleMessage("انتهت مهلة إرسال البيانات."),
        "errorUnauthorized":
            MessageLookupByLibrary.simpleMessage("انتهت صلاحية الجلسة."),
        "errorUnknown":
            MessageLookupByLibrary.simpleMessage("حدث خطأ غير متوقع."),
        "errorUnknownStatusCode": m6,
        "errorValidation": MessageLookupByLibrary.simpleMessage(
            "يرجى مراجعة البيانات المُدخلة والمحاولة مرة أخرى."),
        "evaluations": MessageLookupByLibrary.simpleMessage("التقييمات"),
        "excellencePoints": MessageLookupByLibrary.simpleMessage("نقاط التميز"),
        "excellent": MessageLookupByLibrary.simpleMessage("ممتاز"),
        "excellentTeacher":
            MessageLookupByLibrary.simpleMessage("المعلم المثالي"),
        "expected": MessageLookupByLibrary.simpleMessage("المتوقع"),
        "expenses": MessageLookupByLibrary.simpleMessage("المصاريف"),
        "experience": MessageLookupByLibrary.simpleMessage("الخبرة"),
        "expiredSubscriptions":
            MessageLookupByLibrary.simpleMessage("اشتراكات منتهية"),
        "expiryDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
        "fieldIsRequired": m7,
        "fieldRequired":
            MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
        "fileDownloadStarted":
            MessageLookupByLibrary.simpleMessage("تم فتح ملف الواجب"),
        "fillAllRequiredFields": MessageLookupByLibrary.simpleMessage(
            "يرجى ملء جميع الحقول المطلوبة."),
        "finalDelete": MessageLookupByLibrary.simpleMessage("حذف نهائي"),
        "finalDeleteDescription": MessageLookupByLibrary.simpleMessage(
            "سيتم حذف هذا الحساب نهائيًا من النظام، بما في ذلك حساب الدخول وملف البيانات المرتبط به. لا يمكن التراجع عن هذا الإجراء."),
        "finalDeleteUser":
            MessageLookupByLibrary.simpleMessage("حذف نهائي للمستخدم"),
        "finished": MessageLookupByLibrary.simpleMessage("منتهي"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
        "forgotPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "أدخل بريدك الإلكتروني وسنرسل لك كود إعادة التعيين"),
        "forgotPasswordTitle":
            MessageLookupByLibrary.simpleMessage("استعادة كلمة المرور"),
        "fourDaysAgo": MessageLookupByLibrary.simpleMessage("منذ 4 أيام"),
        "fourHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 4 ساعات"),
        "from": MessageLookupByLibrary.simpleMessage("من"),
        "fullName": MessageLookupByLibrary.simpleMessage("الاسم بالكامل"),
        "goToPayment": MessageLookupByLibrary.simpleMessage("الإنتقال للدفع"),
        "good": MessageLookupByLibrary.simpleMessage("جيد"),
        "grade": MessageLookupByLibrary.simpleMessage("الصف"),
        "gradeAndAssignScore":
            MessageLookupByLibrary.simpleMessage("تصحيح ووضع الدرجة"),
        "gradeLabel": m8,
        "gradeLevel": MessageLookupByLibrary.simpleMessage("المرحلة الدراسية"),
        "gradeName": MessageLookupByLibrary.simpleMessage("اسم الصف"),
        "gradeRequired": MessageLookupByLibrary.simpleMessage("الصف مطلوب"),
        "graded": MessageLookupByLibrary.simpleMessage("مصحح"),
        "gradesCount": m9,
        "graduationGrade": MessageLookupByLibrary.simpleMessage("التقدير"),
        "graduationYear": MessageLookupByLibrary.simpleMessage("سنة التخرج"),
        "groupCreatedByYou":
            MessageLookupByLibrary.simpleMessage("تم إنشاء المجموعة، ابدأ بكم"),
        "groups": MessageLookupByLibrary.simpleMessage("المجموعات"),
        "hasClearMic":
            MessageLookupByLibrary.simpleMessage("هل لديك مايك واضح؟"),
        "hasGoodCamera":
            MessageLookupByLibrary.simpleMessage("هل لديك كاميرا جيدة؟"),
        "hasLaptopOrComputer":
            MessageLookupByLibrary.simpleMessage("هل لديك لاب توب أو كمبيوتر؟"),
        "hasStableInternet":
            MessageLookupByLibrary.simpleMessage("هل لديك إنترنت مستقر؟"),
        "hasTeachingExperience":
            MessageLookupByLibrary.simpleMessage("هل لديك خبرة في التدريس؟"),
        "hireTeachers": MessageLookupByLibrary.simpleMessage("توظيف المعلمين"),
        "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "hourlyRate": MessageLookupByLibrary.simpleMessage("سعر الساعة(ر.س)"),
        "hourlyRateMustBeNumber":
            MessageLookupByLibrary.simpleMessage("سعر الساعة يجب أن يكون رقم"),
        "hourlyRateRequired":
            MessageLookupByLibrary.simpleMessage("سعر الساعة مطلوب"),
        "hoursPackage": m10,
        "howHandleWeakStudent": MessageLookupByLibrary.simpleMessage(
            "كيف تتعامل مع طالب ضعيف المستوى؟"),
        "inactive": MessageLookupByLibrary.simpleMessage("غير نشطة"),
        "interaction": MessageLookupByLibrary.simpleMessage("التفاعل"),
        "interactionAppreciationCertificate":
            MessageLookupByLibrary.simpleMessage("شكر وتقدير - التفاعل"),
        "interactionLevel":
            MessageLookupByLibrary.simpleMessage("مستوى التفاعل"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال عنوان بريد إلكتروني صالح."),
        "issueNewCertificate":
            MessageLookupByLibrary.simpleMessage("إصدار شهادة جديدة"),
        "kuwaitiCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج الكويتي"),
        "lastSixMonths": MessageLookupByLibrary.simpleMessage("آخر ٦ شهور"),
        "latestEarnedPoints":
            MessageLookupByLibrary.simpleMessage("آخر النقاط المكتسبة"),
        "lessonStartsSoon": MessageLookupByLibrary.simpleMessage(
            "حصة الرياضيات تبدأ خلال 15 د"),
        "lessons": MessageLookupByLibrary.simpleMessage("حصة"),
        "lightAndShadowExperiment":
            MessageLookupByLibrary.simpleMessage("تجربة الضوء والظل"),
        "loading": MessageLookupByLibrary.simpleMessage("جاري التحميل..."),
        "login": MessageLookupByLibrary.simpleMessage("تسجيل دخول"),
        "loginNow": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginWelcomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "سجل دخولك للوصول إلى لوحة التحكم"),
        "loginWelcomeTitle": MessageLookupByLibrary.simpleMessage("مرحباً بك"),
        "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "logoutSuccess":
            MessageLookupByLibrary.simpleMessage("تم تسجيل الخروج بنجاح"),
        "major": MessageLookupByLibrary.simpleMessage("التخصص العلمي"),
        "manageStudentsAndClasses":
            MessageLookupByLibrary.simpleMessage("إدارة الفصول والطلاب"),
        "manualPaymentConfirmation":
            MessageLookupByLibrary.simpleMessage("تأكيد الدفع يدوياً"),
        "manualTransferReviewPending":
            MessageLookupByLibrary.simpleMessage("بانتظار مراجعة الإيصال يدوي"),
        "march2026": MessageLookupByLibrary.simpleMessage("مارس 2026"),
        "markAsRead": MessageLookupByLibrary.simpleMessage("تمييز كمقروءة"),
        "materialsManagement":
            MessageLookupByLibrary.simpleMessage("إدارة المواد"),
        "math": MessageLookupByLibrary.simpleMessage("الرياضيات"),
        "mathShort": MessageLookupByLibrary.simpleMessage("رياضيات"),
        "mathTeacherSarah":
            MessageLookupByLibrary.simpleMessage("الرياضيات . أ/سارة عبدالله"),
        "mayCertificate":
            MessageLookupByLibrary.simpleMessage("شهادة شهر مايو"),
        "messages": MessageLookupByLibrary.simpleMessage("الرسائل"),
        "monday": MessageLookupByLibrary.simpleMessage("الإثنين"),
        "month": MessageLookupByLibrary.simpleMessage("الشهر"),
        "monthlyProfits":
            MessageLookupByLibrary.simpleMessage("الأرباح الشهرية"),
        "monthlyRevenue": MessageLookupByLibrary.simpleMessage("إيرادات الشهر"),
        "mostPopular": MessageLookupByLibrary.simpleMessage("الأكثر طلباً"),
        "moveToReview": MessageLookupByLibrary.simpleMessage("نقل للمراجعة"),
        "myAccount": MessageLookupByLibrary.simpleMessage("حسابي"),
        "myGroups": MessageLookupByLibrary.simpleMessage("مجموعاتي"),
        "myPerformance": MessageLookupByLibrary.simpleMessage("أدائي"),
        "myRequests": MessageLookupByLibrary.simpleMessage("طلباتي"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "الاسم لا يمكن أن يكون فارغًا."),
        "nameMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب أن يحتوي الاسم على 3 أحرف على الأقل."),
        "nationality": MessageLookupByLibrary.simpleMessage("الجنسية"),
        "net": MessageLookupByLibrary.simpleMessage("الصافي"),
        "netAmount": MessageLookupByLibrary.simpleMessage("الصافي"),
        "newAssignmentUploaded":
            MessageLookupByLibrary.simpleMessage("تم رفع واجب جديد"),
        "newBadge": MessageLookupByLibrary.simpleMessage("جديد"),
        "newCertificate": MessageLookupByLibrary.simpleMessage("شهادة تقدير"),
        "newCustomer": MessageLookupByLibrary.simpleMessage("عميل جديد"),
        "newMessage":
            MessageLookupByLibrary.simpleMessage("رسالة جديدة من أ/ سارة"),
        "newPassword":
            MessageLookupByLibrary.simpleMessage("كلمة المرور الجديدة"),
        "newPasswordLabel":
            MessageLookupByLibrary.simpleMessage("كلمة المرور الجديدة"),
        "newRating":
            MessageLookupByLibrary.simpleMessage("تقييم أسبوعي جديد لأحمد"),
        "newWeeklyEvaluation":
            MessageLookupByLibrary.simpleMessage("تقييم أسبوعي جديد"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "nextLevelPointsText": m11,
        "no": MessageLookupByLibrary.simpleMessage("لا"),
        "noAssignmentsYet":
            MessageLookupByLibrary.simpleMessage("لا توجد واجبات حالياً"),
        "noAssignmentsYetSubtitle": MessageLookupByLibrary.simpleMessage(
            "عند إضافة واجبات جديدة ستظهر في هذه الصفحة."),
        "noCompletedAssignments":
            MessageLookupByLibrary.simpleMessage("لا توجد واجبات مكتملة"),
        "noCompletedAssignmentsSubtitle":
            MessageLookupByLibrary.simpleMessage("عند حل الواجبات ستظهر هنا."),
        "noGroupsYet":
            MessageLookupByLibrary.simpleMessage("لا توجد مجموعات حالياً"),
        "noGroupsYetSubtitle": MessageLookupByLibrary.simpleMessage(
            "عند الانضمام إلى مجموعة أو إرسال طلب جديد ستظهر هنا."),
        "noPendingAssignments":
            MessageLookupByLibrary.simpleMessage("لا توجد واجبات قيد الانتظار"),
        "noPendingAssignmentsSubtitle": MessageLookupByLibrary.simpleMessage(
            "كل الواجبات الحالية تم حلها أو لا توجد واجبات جديدة بعد."),
        "noSubjectsAvailable": MessageLookupByLibrary.simpleMessage(
            "لا توجد مواد متاحة لهذا الصف"),
        "noSubmission": MessageLookupByLibrary.simpleMessage("تم التسليم"),
        "notAvailable": MessageLookupByLibrary.simpleMessage("غير متاحة"),
        "notSubmitted": MessageLookupByLibrary.simpleMessage("لم يسلم"),
        "notes": MessageLookupByLibrary.simpleMessage(
            "ملاحظات إضافية أو تفاصيل تريد مشاركتها معنا"),
        "notesHint": MessageLookupByLibrary.simpleMessage(
            "مثال: كل يوم اثنين وأربعاء الساعة 5 مساءً"),
        "notesText": MessageLookupByLibrary.simpleMessage("ملاحظات"),
        "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "oldPasswordLabel":
            MessageLookupByLibrary.simpleMessage("كلمة المرور القديمة"),
        "oldPrice": m12,
        "onboardingSubtitle1": MessageLookupByLibrary.simpleMessage(
            "منصة تعليمية تساعدك على تطوير مهاراتك"),
        "onboardingSubtitle2": MessageLookupByLibrary.simpleMessage(
            "استمتع بتجربة تعليمية مرنة تناسب يومك وأسلوبك"),
        "onboardingSubtitle3": MessageLookupByLibrary.simpleMessage(
            "محتوى تفاعلي يساعدك على التعلم بطريقة أكثر متعة"),
        "onboardingTitle1":
            MessageLookupByLibrary.simpleMessage("ابدأ رحلتك التعليمية بسهولة"),
        "onboardingTitle2":
            MessageLookupByLibrary.simpleMessage("دروس تفاعلية ومحتوى ممتع"),
        "onboardingTitle3":
            MessageLookupByLibrary.simpleMessage("النجاح يبدأ هنا"),
        "onlineNow": MessageLookupByLibrary.simpleMessage("متصل الآن"),
        "optional": MessageLookupByLibrary.simpleMessage("اختياري"),
        "package4Hours": MessageLookupByLibrary.simpleMessage("باقة 4 ساعات"),
        "packageCalculation": m13,
        "packageDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الباقة"),
        "packageExpiryText": MessageLookupByLibrary.simpleMessage(
            "ينتهي خلال 18 يوم . تجديد تلقائي"),
        "packagePrice": MessageLookupByLibrary.simpleMessage("سعر الحصة"),
        "packages": MessageLookupByLibrary.simpleMessage("الباقات"),
        "parent": MessageLookupByLibrary.simpleMessage("ولي الأمر"),
        "parentAccount": MessageLookupByLibrary.simpleMessage("حسابي"),
        "parentCertificates": MessageLookupByLibrary.simpleMessage("الشهادات"),
        "parentChildren": MessageLookupByLibrary.simpleMessage("الأبناء"),
        "parentDailyPlans":
            MessageLookupByLibrary.simpleMessage("الخطط اليومية"),
        "parentEvaluations": MessageLookupByLibrary.simpleMessage("التقييمات"),
        "parentFirstPreparatoryGrade":
            MessageLookupByLibrary.simpleMessage("الصف الأول الإعدادي"),
        "parentGuardian": MessageLookupByLibrary.simpleMessage("ولي أمر"),
        "parentHomeTitle": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "parentInfo": MessageLookupByLibrary.simpleMessage("معلومات ولي الأمر"),
        "parentMessages": MessageLookupByLibrary.simpleMessage("الرسائل"),
        "parentName": MessageLookupByLibrary.simpleMessage("اسم ولي الأمر"),
        "parentNotifications":
            MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "parentPackagesAndSubscription":
            MessageLookupByLibrary.simpleMessage("الباقات والاشتراك"),
        "parentRenew": MessageLookupByLibrary.simpleMessage("جدد"),
        "parentRole": MessageLookupByLibrary.simpleMessage("ولي أمر"),
        "parentSchedule": MessageLookupByLibrary.simpleMessage("الجدول"),
        "parentSecondPreparatoryGrade":
            MessageLookupByLibrary.simpleMessage("الصف الثاني الإعدادي"),
        "parentShowAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
        "parentSubscription": MessageLookupByLibrary.simpleMessage("الاشتراك"),
        "parentSubscriptionEndsSoon": MessageLookupByLibrary.simpleMessage(
            "اشتراك ليلى سينتهي خلال 5 أيام"),
        "parentSubscriptionRenewHint":
            MessageLookupByLibrary.simpleMessage("جدده الآن لتجنب التعليق"),
        "parentSubscriptions":
            MessageLookupByLibrary.simpleMessage("الاشتراكات"),
        "parentThirdPreparatoryGrade":
            MessageLookupByLibrary.simpleMessage("الصف الثالث الإعدادي"),
        "parentWelcome": MessageLookupByLibrary.simpleMessage("أهلًا بك"),
        "parentYourChildren": MessageLookupByLibrary.simpleMessage("أبناؤك"),
        "participation": MessageLookupByLibrary.simpleMessage("المشاركة"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordAndConfirmRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال كلمة المرور وتأكيدها"),
        "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "كلمة المرور لا يمكن أن تكون فارغة."),
        "passwordChangedSuccessfully":
            MessageLookupByLibrary.simpleMessage("تم تغيير كلمة المرور بنجاح"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("6 أحرف علي الأقل"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل."),
        "passwordMustHaveNumber": MessageLookupByLibrary.simpleMessage(
            "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل."),
        "passwordMustHaveUpperCase": MessageLookupByLibrary.simpleMessage(
            "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل."),
        "passwordWillBeUsed": MessageLookupByLibrary.simpleMessage(
            "ستستخدمها للدخول مع البريد الإلكتروني بعد إتمام الدفع"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("كلمتا المرور غير متطابقتين."),
        "paymentCompleted": MessageLookupByLibrary.simpleMessage("تم الدفع"),
        "paymentDoneOn": MessageLookupByLibrary.simpleMessage("تم الدفع في"),
        "paymentInfo": MessageLookupByLibrary.simpleMessage("معلومات الدفع"),
        "paymentMethod": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
        "paymentStatus": MessageLookupByLibrary.simpleMessage("حالة الدفع"),
        "pending": MessageLookupByLibrary.simpleMessage("معلق"),
        "pendingMathSubtitle":
            MessageLookupByLibrary.simpleMessage("درس الكسور، بانتظار أي معلم"),
        "pendingPayments":
            MessageLookupByLibrary.simpleMessage("المدفوعات المعلقة"),
        "pendingReceipts":
            MessageLookupByLibrary.simpleMessage("إيصالات معلقة"),
        "pendingRegisterRequests":
            MessageLookupByLibrary.simpleMessage("طلبات تسجيل معلقة"),
        "pendingRequests": MessageLookupByLibrary.simpleMessage("طلبات معلقة"),
        "pendingReview": MessageLookupByLibrary.simpleMessage("قيد المراجعة"),
        "pendingScienceSubtitle": MessageLookupByLibrary.simpleMessage(
            "درس بناء الضوء، بانتظار أي معلم"),
        "pendingWaiting": MessageLookupByLibrary.simpleMessage("قيد الانتظار"),
        "performance": MessageLookupByLibrary.simpleMessage("أدائي"),
        "permanentlyDeleteFromSystem":
            MessageLookupByLibrary.simpleMessage("حذف نهائي من النظام"),
        "personalProfile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
        "physics": MessageLookupByLibrary.simpleMessage("الفيزياء"),
        "platformsUsed":
            MessageLookupByLibrary.simpleMessage("المنصات المستخدمة"),
        "pleaseAnswerAllQuestions": MessageLookupByLibrary.simpleMessage(
            "برجاء الإجابة على جميع الأسئلة"),
        "pleaseChooseAtLeastOneGrade": MessageLookupByLibrary.simpleMessage(
            "برجاء اختيار صف واحد على الأقل"),
        "pleaseChooseAtLeastOneSubjectForEachGrade":
            MessageLookupByLibrary.simpleMessage(
                "برجاء اختيار مادة واحدة على الأقل لكل صف"),
        "pleaseChooseCurriculumGrades": m14,
        "pleaseChooseCurriculumSubjects": m15,
        "pleaseChooseTeachingCurriculum": MessageLookupByLibrary.simpleMessage(
            "برجاء اختيار المنهج الذي تدرسه"),
        "pleaseFillRequiredInfo": MessageLookupByLibrary.simpleMessage(
            "يرجى ملء جميع الحقول المطلوبة"),
        "pleaseSelectFile":
            MessageLookupByLibrary.simpleMessage("من فضلك اختاري ملفًا أولًا"),
        "poemAnalysis": MessageLookupByLibrary.simpleMessage("تحليل القصيدة"),
        "point": MessageLookupByLibrary.simpleMessage("نقطة"),
        "points": MessageLookupByLibrary.simpleMessage("النقاط"),
        "pointsCount": MessageLookupByLibrary.simpleMessage("نقطة"),
        "pointsTipDescription": MessageLookupByLibrary.simpleMessage(
            "احرص على تسليم التقييمات الأسبوعية في موعدها لكسب ٢٠ نقطة إضافية أسبوعيًا"),
        "preferredDays":
            MessageLookupByLibrary.simpleMessage("مواعيد الطالب المفضلة"),
        "preferredDaysHint": MessageLookupByLibrary.simpleMessage(
            "حدد الأيام والأوقات المفضلة للحضور"),
        "preview": MessageLookupByLibrary.simpleMessage("معاينة"),
        "previous": MessageLookupByLibrary.simpleMessage("السابق"),
        "primaryGradeFive":
            MessageLookupByLibrary.simpleMessage("الصف الخامس الابتدائي"),
        "privacy": MessageLookupByLibrary.simpleMessage("الخصوصية"),
        "qarCurrency": MessageLookupByLibrary.simpleMessage("ريال قطري (ر.ق)"),
        "qatariCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج القطري"),
        "qatariCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "منهج معتمد من وزارة التربية والتعليم في قطر، ويشمل المراحل الأساسية حتى الثانوية."),
        "qualification": MessageLookupByLibrary.simpleMessage("المؤهل"),
        "quotaReport": MessageLookupByLibrary.simpleMessage("تقرير الحصص"),
        "quran": MessageLookupByLibrary.simpleMessage("القرآن الكريم"),
        "ranking": MessageLookupByLibrary.simpleMessage("الترتيب"),
        "rating": MessageLookupByLibrary.simpleMessage("تقييم"),
        "readyGroupSubtitle":
            MessageLookupByLibrary.simpleMessage("الرياضيات - مجموعة جاهزة"),
        "registerAsParent":
            MessageLookupByLibrary.simpleMessage("التسجيل كولي أمر"),
        "registerAsParentSubtitle": MessageLookupByLibrary.simpleMessage(
            "تابع تقدم أبنائك وتواصل مع المعلمين"),
        "registerAsStudent":
            MessageLookupByLibrary.simpleMessage("التسجيل كطالب"),
        "registerAsStudentSubtitle": MessageLookupByLibrary.simpleMessage(
            "انضم للفصول الدراسية وابدأ رحلتك التعليمية"),
        "registrationDate":
            MessageLookupByLibrary.simpleMessage("تاريخ التسجيل"),
        "registrationRequests":
            MessageLookupByLibrary.simpleMessage("طلبات التسجيل"),
        "reject": MessageLookupByLibrary.simpleMessage("رفض"),
        "relationships": MessageLookupByLibrary.simpleMessage("العلاقات"),
        "remainingDays": m16,
        "remainingHours": m17,
        "remainingSessions": MessageLookupByLibrary.simpleMessage("المتبقية"),
        "requestAccepted":
            MessageLookupByLibrary.simpleMessage("تم قبول طلبك!"),
        "requestNewLesson":
            MessageLookupByLibrary.simpleMessage("طلب درس جديد"),
        "requestSubmittedUnderReview": MessageLookupByLibrary.simpleMessage(
            "تم إرسال طلبك وهو الآن قيد المراجعة."),
        "resendCode": MessageLookupByLibrary.simpleMessage("إعادة الإرسال؟"),
        "resetCodeRequired":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال كود التحقق"),
        "resetCodeSubtitle": MessageLookupByLibrary.simpleMessage(
            "تحقق من بريدك الإلكتروني وأدخل الكود المرسل إليك"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("إعادة تعيين كلمة المرور"),
        "resetPasswordInstructions": MessageLookupByLibrary.simpleMessage(
            " واتبع التعليمات لإعادة تعيين كلمة المرور."),
        "resetPasswordSuccessSubtitle": m18,
        "resetPasswordSuccessTitle":
            MessageLookupByLibrary.simpleMessage("تم الإرسال بنجاح"),
        "revenues": MessageLookupByLibrary.simpleMessage("الإيرادات"),
        "reviewNewStudents":
            MessageLookupByLibrary.simpleMessage("عرض طلبات الطلاب"),
        "reviewPaidRequests":
            MessageLookupByLibrary.simpleMessage("عرض طلبات الدفع"),
        "reviews": MessageLookupByLibrary.simpleMessage("التقييمات"),
        "rewardPoints": MessageLookupByLibrary.simpleMessage("نقاط المكافآت"),
        "rewards": MessageLookupByLibrary.simpleMessage("مكافآت"),
        "role": MessageLookupByLibrary.simpleMessage("دور"),
        "salary": MessageLookupByLibrary.simpleMessage("الراتب"),
        "salaryCalculationFormula":
            MessageLookupByLibrary.simpleMessage("عدد الحصص * سعر الحصة"),
        "salaryCalculationFormulaDesc":
            MessageLookupByLibrary.simpleMessage("يتم احتساب الراتب الأساسي"),
        "salaryCalculationMethod":
            MessageLookupByLibrary.simpleMessage("طريقة احتساب الراتب"),
        "sarCurrency": MessageLookupByLibrary.simpleMessage("ريال سعودي (ر.س)"),
        "sarShort": MessageLookupByLibrary.simpleMessage("ريال"),
        "saudiCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج السعودي"),
        "saudiCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "نقدم جميع المواد الدراسية للمرحلة الابتدائية، المتوسطة، والثانوية وفق المنهج المعتمد."),
        "saudiDepartment":
            MessageLookupByLibrary.simpleMessage("القسم السعودي"),
        "saudiRiyal": MessageLookupByLibrary.simpleMessage("الريال السعودي"),
        "save": MessageLookupByLibrary.simpleMessage("حفظ"),
        "saveAmount": m19,
        "schedule": MessageLookupByLibrary.simpleMessage("الجدول"),
        "scheduleUpdated": MessageLookupByLibrary.simpleMessage(
            "تم تعديل جدول الأسبوع القادم"),
        "science": MessageLookupByLibrary.simpleMessage("العلوم"),
        "searchByNameOrPhone":
            MessageLookupByLibrary.simpleMessage("بحث بالاسم أو الهاتف"),
        "sections": MessageLookupByLibrary.simpleMessage("الفصول"),
        "selectFile": MessageLookupByLibrary.simpleMessage("اختر ملف"),
        "selectGrade": MessageLookupByLibrary.simpleMessage("اختر الصف"),
        "selectStudent": MessageLookupByLibrary.simpleMessage("اختر الطالب"),
        "selectSubject": MessageLookupByLibrary.simpleMessage("اختر المادة"),
        "selectedPackage":
            MessageLookupByLibrary.simpleMessage("الباقة المختارة"),
        "semesterName": MessageLookupByLibrary.simpleMessage("اسم الفصل"),
        "semesterOne": MessageLookupByLibrary.simpleMessage("فصل ١"),
        "semesterThree": MessageLookupByLibrary.simpleMessage("فصل ٣"),
        "semesterTwo": MessageLookupByLibrary.simpleMessage("فصل ٢"),
        "send": MessageLookupByLibrary.simpleMessage("أرسلت"),
        "sendCorrection": MessageLookupByLibrary.simpleMessage("إرسال التصحيح"),
        "sendResetCode":
            MessageLookupByLibrary.simpleMessage("إرسال كود الاستعادة"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("إرسال كود الاستعادة"),
        "services": MessageLookupByLibrary.simpleMessage("الخدمات"),
        "sessions": MessageLookupByLibrary.simpleMessage("حصة"),
        "sessionsThisMonth":
            MessageLookupByLibrary.simpleMessage("حصة هذا الشهر"),
        "shortVideoLinkOptional":
            MessageLookupByLibrary.simpleMessage("رابط فيديو قصير (اختياري)"),
        "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
        "socialStudies": MessageLookupByLibrary.simpleMessage("الاجتماعيات"),
        "specialization": MessageLookupByLibrary.simpleMessage("التخصص"),
        "start": MessageLookupByLibrary.simpleMessage("ابدأ"),
        "startLessonViaZoom":
            MessageLookupByLibrary.simpleMessage("ابدأ الحصة عبر Zoom"),
        "startNow": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
        "student": MessageLookupByLibrary.simpleMessage("طالب"),
        "studentEmail": MessageLookupByLibrary.simpleMessage("ايميل الطالب"),
        "studentInfo": MessageLookupByLibrary.simpleMessage("معلومات الطالب"),
        "studentName": MessageLookupByLibrary.simpleMessage("اسم الطالب"),
        "studentNotes": MessageLookupByLibrary.simpleMessage("ملاحظات الطالب"),
        "studentNotesAndSchedule": MessageLookupByLibrary.simpleMessage(
            "ملاحظات الطالب وتفضيلات المواعيد"),
        "studentNotesAndScheduleHint": MessageLookupByLibrary.simpleMessage(
            "ملاحظات (الدروس التي تحتاج شرحها، الأهداف، أي ملاحظات أخرى)"),
        "studentNotesExample": MessageLookupByLibrary.simpleMessage(
            "مثال: يحتاج شرح درس الكسور والقسمة المطولة ..."),
        "studentPassword": MessageLookupByLibrary.simpleMessage(
            "كلمة المرور للدخول على المنصة"),
        "studentPasswordField":
            MessageLookupByLibrary.simpleMessage("كلمة المرور للطالب"),
        "studentProfileClass":
            MessageLookupByLibrary.simpleMessage("القسم المصري"),
        "studentProfileGrade":
            MessageLookupByLibrary.simpleMessage("الصف الثاني الإعدادي"),
        "studentRegistrationForm":
            MessageLookupByLibrary.simpleMessage("نموذج تسجيل الطالب"),
        "studentRequestAccepted": MessageLookupByLibrary.simpleMessage(
            "سيتم إنشاء مجموعة دراسية وتحويل الطالب إليك مباشرة"),
        "studentUsesItForDashboard": MessageLookupByLibrary.simpleMessage(
            "يستخدمه الطالب للدخول على الداشبورد"),
        "students": MessageLookupByLibrary.simpleMessage("الطلاب"),
        "studentsByDepartment":
            MessageLookupByLibrary.simpleMessage("الطلاب حسب القسم"),
        "studyCurriculaTitle":
            MessageLookupByLibrary.simpleMessage("المناهج الدراسية "),
        "studyMaterials":
            MessageLookupByLibrary.simpleMessage("المواد الدراسية"),
        "studySchedule": MessageLookupByLibrary.simpleMessage("الجدول الدراسي"),
        "subject": MessageLookupByLibrary.simpleMessage("المادة"),
        "subjectLabel": MessageLookupByLibrary.simpleMessage("المادة"),
        "subjectName": MessageLookupByLibrary.simpleMessage("اسم المادة"),
        "subjectRequired":
            MessageLookupByLibrary.simpleMessage("المادة مطلوبة"),
        "subjects": MessageLookupByLibrary.simpleMessage("المواد"),
        "subjectsGrades": MessageLookupByLibrary.simpleMessage("درجات المواد"),
        "subjectsManagement":
            MessageLookupByLibrary.simpleMessage("إدارة المواد الدراسية"),
        "submissionDate": MessageLookupByLibrary.simpleMessage("تم التسليم:"),
        "submitAssignment": MessageLookupByLibrary.simpleMessage("رفع الواجب"),
        "submitAssignmentCorrection":
            MessageLookupByLibrary.simpleMessage("تصحيح تسليم"),
        "submitRequest": MessageLookupByLibrary.simpleMessage("إرسال الطلب"),
        "submitted": MessageLookupByLibrary.simpleMessage("مسلم"),
        "submittedBadge": MessageLookupByLibrary.simpleMessage("مرفوع"),
        "subscribeNow": MessageLookupByLibrary.simpleMessage("اشترك الآن"),
        "subscription": MessageLookupByLibrary.simpleMessage("الاشتراك"),
        "subscriptionEndsSoon":
            MessageLookupByLibrary.simpleMessage("اشتراكك سينتهي خلال 5 أيام"),
        "subscriptions": MessageLookupByLibrary.simpleMessage("الاشتراكات"),
        "sunday": MessageLookupByLibrary.simpleMessage("الأحد"),
        "supervisor": MessageLookupByLibrary.simpleMessage("مشرف"),
        "supervisorRequired":
            MessageLookupByLibrary.simpleMessage("المشرف مطلوب"),
        "tabbyTamara":
            MessageLookupByLibrary.simpleMessage("قسم فاتورتك مع تمارا"),
        "taughtOnlineBefore":
            MessageLookupByLibrary.simpleMessage("هل سبق لك التدريس أونلاين؟"),
        "taughtSubjects":
            MessageLookupByLibrary.simpleMessage("المواد التي درّسها"),
        "teachableGrades":
            MessageLookupByLibrary.simpleMessage("الصفوف الممكن تدريسها"),
        "teacher": MessageLookupByLibrary.simpleMessage("معلم"),
        "teacherAhmedFouad":
            MessageLookupByLibrary.simpleMessage("أ/ أحمد فؤاد"),
        "teacherApplicationDetailsTitle": m20,
        "teacherApplications":
            MessageLookupByLibrary.simpleMessage("طلبات تقديم المعلمين"),
        "teacherApplySubtitle": MessageLookupByLibrary.simpleMessage(
            "سيتم مراجعة طلبك والرد عليك قريبًا"),
        "teacherApplyTitle": MessageLookupByLibrary.simpleMessage(
            "التقديم كمعلم في أكاديمية بنان"),
        "teacherDeclarationAgreement": MessageLookupByLibrary.simpleMessage(
            "أقر بصحة جميع البيانات المذكورة أعلاه، وأتعهد بالالتزام بقواعد وسياسات أكاديمية بنان"),
        "teacherNote": MessageLookupByLibrary.simpleMessage("ملاحظة المعلم"),
        "teacherNoteText": MessageLookupByLibrary.simpleMessage(
            "ممتاز على حل الواجبات هذه المرة."),
        "teacherSarahName":
            MessageLookupByLibrary.simpleMessage("أ/ سارة عبدالله"),
        "teacherSarahShort": MessageLookupByLibrary.simpleMessage("أ/ سارة"),
        "teacherStepAttachments":
            MessageLookupByLibrary.simpleMessage("المرفقات والإقرار"),
        "teacherStepEvaluation":
            MessageLookupByLibrary.simpleMessage("التقييم"),
        "teacherStepExperience":
            MessageLookupByLibrary.simpleMessage("الخبرة العملية"),
        "teacherStepPersonalInfo":
            MessageLookupByLibrary.simpleMessage("البيانات الشخصية"),
        "teacherStepQualification":
            MessageLookupByLibrary.simpleMessage("المؤهل العلمي"),
        "teacherStepTeachingDetails":
            MessageLookupByLibrary.simpleMessage("تفاصيل التدريس"),
        "teacherStepTechnicalSkills":
            MessageLookupByLibrary.simpleMessage("المهارات التقنية"),
        "teachers": MessageLookupByLibrary.simpleMessage("المعلمون"),
        "teachingInBnan":
            MessageLookupByLibrary.simpleMessage("التدريس في بنان"),
        "technicalAppsLevel":
            MessageLookupByLibrary.simpleMessage("مستوى استخدام الكمبيوتر"),
        "theRequiredLesson":
            MessageLookupByLibrary.simpleMessage("الدرس المطلوب"),
        "theSupervisor": MessageLookupByLibrary.simpleMessage("المشرف"),
        "thirdTermExercises":
            MessageLookupByLibrary.simpleMessage("تمارين الفصل الثالث"),
        "threeDaysAgo": MessageLookupByLibrary.simpleMessage("منذ 3 أيام"),
        "thursday": MessageLookupByLibrary.simpleMessage("الخميس"),
        "time": MessageLookupByLibrary.simpleMessage("الوقت"),
        "tipToIncreasePoints":
            MessageLookupByLibrary.simpleMessage("نصيحة لزيادة النقاط"),
        "to": MessageLookupByLibrary.simpleMessage("إلى"),
        "today": MessageLookupByLibrary.simpleMessage("اليوم"),
        "todayAtTime": m21,
        "todayClasses": MessageLookupByLibrary.simpleMessage("حصص اليوم"),
        "total": MessageLookupByLibrary.simpleMessage("المجموع"),
        "totalSessions": MessageLookupByLibrary.simpleMessage("إجمالي الحصص"),
        "totalStudents": MessageLookupByLibrary.simpleMessage("إجمالي الطلاب"),
        "trainingHours": m22,
        "tuesday": MessageLookupByLibrary.simpleMessage("الثلاثاء"),
        "twelveHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 12 ساعة"),
        "twentyHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 20 ساعة"),
        "twoDaysAgo": MessageLookupByLibrary.simpleMessage("منذ يومين"),
        "typeMessage": MessageLookupByLibrary.simpleMessage("اكتب رسالة....."),
        "underProcessing": MessageLookupByLibrary.simpleMessage("قيد المعالجة"),
        "unexpectedError":
            MessageLookupByLibrary.simpleMessage("حدث خطأ غير متوقع"),
        "universityOrInstitutionName":
            MessageLookupByLibrary.simpleMessage("اسم الجامعة/المؤهل"),
        "upcomingLesson": MessageLookupByLibrary.simpleMessage("الحصة القادمة"),
        "upcomingLessons":
            MessageLookupByLibrary.simpleMessage("الحصص القادمة"),
        "upgradePackage": MessageLookupByLibrary.simpleMessage("ترقية الباقة"),
        "uploadAssignment": MessageLookupByLibrary.simpleMessage("رفع الواجب"),
        "uploadCertificateFile": MessageLookupByLibrary.simpleMessage(
            "صورة من الشهادة أو المؤهل (صورة/pdf)"),
        "uploadCvFile":
            MessageLookupByLibrary.simpleMessage("رفع السيرة الذاتية (pdf)"),
        "uploadNationalIdFile": MessageLookupByLibrary.simpleMessage(
            "صورة بطاقة الرقم القومي/الهوية (صورة/pdf)"),
        "uploadSchedule": MessageLookupByLibrary.simpleMessage("رفع الجدول"),
        "usedDays": m23,
        "usedHours": m24,
        "userDetails": MessageLookupByLibrary.simpleMessage("تفاصيل المستخدم"),
        "userName": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
        "userRole": MessageLookupByLibrary.simpleMessage("دور المستخدم"),
        "usersCount": m25,
        "usersManagement":
            MessageLookupByLibrary.simpleMessage("إدارة المستخدمين"),
        "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
        "veryGood": MessageLookupByLibrary.simpleMessage("جيد جدًا"),
        "view": MessageLookupByLibrary.simpleMessage("عرض"),
        "viewAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
        "waitingForCorrection":
            MessageLookupByLibrary.simpleMessage("بانتظار التصحيح"),
        "waitingForTeacherApproval":
            MessageLookupByLibrary.simpleMessage("بانتظار موافقة المعلم"),
        "wednesday": MessageLookupByLibrary.simpleMessage("الأربعاء"),
        "weekStart": MessageLookupByLibrary.simpleMessage("بداية الأسبوع"),
        "weeklyEvaluation":
            MessageLookupByLibrary.simpleMessage("التقييم الأسبوعي"),
        "weeklyEvaluations":
            MessageLookupByLibrary.simpleMessage("التقييمات الأسبوعية"),
        "weeklyHours":
            MessageLookupByLibrary.simpleMessage("الساعات الأسبوعية"),
        "weeklyIdealStudent":
            MessageLookupByLibrary.simpleMessage("الطالب المثالي للأسبوع"),
        "weeklyIdealStudentsRanking": MessageLookupByLibrary.simpleMessage(
            "ترتيب الطلاب المثاليين هذا الأسبوع"),
        "weeklyLessons": m26,
        "weeklyPlans": MessageLookupByLibrary.simpleMessage("الخطط الأسبوعية"),
        "welcomeYou": MessageLookupByLibrary.simpleMessage("أهلاً بك"),
        "whatsappNumber": MessageLookupByLibrary.simpleMessage("رقم الواتساب"),
        "whyJoinBananAcademy": MessageLookupByLibrary.simpleMessage(
            "لماذا ترغب في الانضمام لأكاديمية بنان؟"),
        "withTeacher":
            MessageLookupByLibrary.simpleMessage("مع أ/ سارة عبدالله"),
        "years": MessageLookupByLibrary.simpleMessage("سنوات"),
        "yes": MessageLookupByLibrary.simpleMessage("نعم"),
        "yesterday": MessageLookupByLibrary.simpleMessage("أمس")
      };
}
