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

  static String m0(price) => "${price} ر.س";

  static String m1(statusCode) => "خطأ غير معروف: ${statusCode}";

  static String m2(hours) => "${hours} ساعة";

  static String m3(price) => "${price} ر.س";

  static String m4(price, studentsCount, total) =>
      "${price} ريال × ${studentsCount} طالب = ${total} ريال";

  static String m5(hours) => "${hours} ساعات متبقية";

  static String m6(email) =>
      "تحقق من بريدك الإلكتروني ${email} واتبع التعليمات لإعادة تعيين كلمة المرور.";

  static String m7(amount) => "وفر ${amount} ر.س";

  static String m8(hours) => "${hours} ساعة تدريبية";

  static String m9(used, total) => "تم استخدام ${used} من ${total}";

  static String m10(count) => "${count} محاضرة أسبوعية";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Packages": MessageLookupByLibrary.simpleMessage("باقات"),
        "PackagesandSubscriptions":
            MessageLookupByLibrary.simpleMessage("الباقات والاشتراكات"),
        "active": MessageLookupByLibrary.simpleMessage("نشطة"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("لديك حساب؟ "),
        "applePay": MessageLookupByLibrary.simpleMessage("أبل باي"),
        "applyAsTeacher": MessageLookupByLibrary.simpleMessage("التقديم كمعلم"),
        "applyAsTeacherSubtitle": MessageLookupByLibrary.simpleMessage(
            "شارك خبراتك وانضم إلى فريقنا التعليمي"),
        "arabicLanguage": MessageLookupByLibrary.simpleMessage("اللغة العربية"),
        "assignments": MessageLookupByLibrary.simpleMessage("الواجبات"),
        "available": MessageLookupByLibrary.simpleMessage("المتاحة"),
        "availableDay": MessageLookupByLibrary.simpleMessage("اليوم المتاح"),
        "backToLogin":
            MessageLookupByLibrary.simpleMessage("العودة لتسجيل الدخول"),
        "browseSection": MessageLookupByLibrary.simpleMessage("تصفح القسم"),
        "canChangeCurrency": MessageLookupByLibrary.simpleMessage(
            "يمكنك تغيير العملة من القائمة"),
        "cardHolderName":
            MessageLookupByLibrary.simpleMessage("اسم حامل البطاقة"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("رقم الكارت"),
        "certificates": MessageLookupByLibrary.simpleMessage("الشهادات"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("تغيير كلمة المرور"),
        "checkYourEmailPrefix":
            MessageLookupByLibrary.simpleMessage("تحقق من بريدك الإلكتروني "),
        "chemistry": MessageLookupByLibrary.simpleMessage("الكيمياء"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("اختر نوع الحساب للمتابعة"),
        "chooseCurriculum": MessageLookupByLibrary.simpleMessage(
            "اختر المنهج الدراسي المناسب لأبنائك وابدأ رحلة التعليم معنا"),
        "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
        "confirmNewPassword":
            MessageLookupByLibrary.simpleMessage("تأكيد كلمة المرور"),
        "confirmPasswordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "تأكيد كلمة المرور لا يمكن أن يكون فارغًا."),
        "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
        "createNewAccount":
            MessageLookupByLibrary.simpleMessage("إنشاء حساب جديد"),
        "creditCard": MessageLookupByLibrary.simpleMessage("بطاقة إئتمانية"),
        "currency": MessageLookupByLibrary.simpleMessage("العملة:"),
        "currentPrice": m0,
        "curricula": MessageLookupByLibrary.simpleMessage("المناهج"),
        "curriculum": MessageLookupByLibrary.simpleMessage("المنهج"),
        "curriculumSelection":
            MessageLookupByLibrary.simpleMessage("اختيار المنهج"),
        "cvv": MessageLookupByLibrary.simpleMessage("رمز التحقق CVV"),
        "dashboard": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "doNotHaveAccount":
            MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟ "),
        "egpCurrency": MessageLookupByLibrary.simpleMessage("جنيه مصري (ج.م)"),
        "egyptianCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج المصري"),
        "egyptianCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "تعليم متكامل للصفوف الابتدائية والإعدادية والثانوية وفق المنهج المصري الحديث."),
        "eightHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 8 ساعات"),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "البريد الإلكتروني لا يمكن أن يكون فارغًا."),
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
        "errorUnknownStatusCode": m1,
        "expiryDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
        "forgotPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "أدخل بريدك الإلكتروني وسنرسل لك كود إعادة التعيين"),
        "forgotPasswordTitle":
            MessageLookupByLibrary.simpleMessage("استعادة كلمة المرور"),
        "fourHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 4 ساعات"),
        "from": MessageLookupByLibrary.simpleMessage("من"),
        "goToPayment": MessageLookupByLibrary.simpleMessage("الإنتقال للدفع"),
        "grade": MessageLookupByLibrary.simpleMessage("الصف"),
        "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "hoursPackage": m2,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال عنوان بريد إلكتروني صالح."),
        "login": MessageLookupByLibrary.simpleMessage("تسجيل دخول"),
        "loginNow": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginWelcomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "سجل دخولك للوصول إلى لوحة التحكم"),
        "loginWelcomeTitle": MessageLookupByLibrary.simpleMessage("مرحباً بك"),
        "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "math": MessageLookupByLibrary.simpleMessage("الرياضيات"),
        "mostPopular": MessageLookupByLibrary.simpleMessage("الأكثر طلباً"),
        "myAccount": MessageLookupByLibrary.simpleMessage("حسابي"),
        "myGroups": MessageLookupByLibrary.simpleMessage("مجموعاتي"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "الاسم لا يمكن أن يكون فارغًا."),
        "nameMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب أن يحتوي الاسم على 3 أحرف على الأقل."),
        "newPassword":
            MessageLookupByLibrary.simpleMessage("كلمة المرور الجديدة"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "notes": MessageLookupByLibrary.simpleMessage(
            "ملاحظات إضافية أو تفاصيل تريد مشاركتها معنا"),
        "notesHint": MessageLookupByLibrary.simpleMessage(
            "مثال: كل يوم اثنين وأربعاء الساعة 5 مساءً"),
        "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "oldPrice": m3,
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
        "optional": MessageLookupByLibrary.simpleMessage("اختياري"),
        "package4Hours": MessageLookupByLibrary.simpleMessage("باقة 4 ساعات"),
        "packageCalculation": m4,
        "packageDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الباقة"),
        "packageExpiryText": MessageLookupByLibrary.simpleMessage(
            "ينتهي خلال 18 يوم . تجديد تلقائي"),
        "packages": MessageLookupByLibrary.simpleMessage("الباقات"),
        "parentInfo": MessageLookupByLibrary.simpleMessage("معلومات ولي الأمر"),
        "parentName": MessageLookupByLibrary.simpleMessage("اسم ولي الأمر"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "كلمة المرور لا يمكن أن تكون فارغة."),
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
        "paymentInfo": MessageLookupByLibrary.simpleMessage("معلومات الدفع"),
        "paymentMethod": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
        "physics": MessageLookupByLibrary.simpleMessage("الفيزياء"),
        "pleaseFillRequiredInfo": MessageLookupByLibrary.simpleMessage(
            "يرجى ملء جميع الحقول المطلوبة"),
        "preferredDays":
            MessageLookupByLibrary.simpleMessage("مواعيد الطالب المفضلة"),
        "preferredDaysHint": MessageLookupByLibrary.simpleMessage(
            "حدد الأيام والأوقات المفضلة للحضور"),
        "previous": MessageLookupByLibrary.simpleMessage("السابق"),
        "primaryGradeFive":
            MessageLookupByLibrary.simpleMessage("الصف الخامس الابتدائي"),
        "qarCurrency": MessageLookupByLibrary.simpleMessage("ريال قطري (ر.ق)"),
        "qatariCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج القطري"),
        "qatariCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "منهج معتمد من وزارة التربية والتعليم في قطر، ويشمل المراحل الأساسية حتى الثانوية."),
        "quran": MessageLookupByLibrary.simpleMessage("القرآن الكريم"),
        "registerAsParent":
            MessageLookupByLibrary.simpleMessage("التسجيل كولي أمر"),
        "registerAsParentSubtitle": MessageLookupByLibrary.simpleMessage(
            "تابع تقدم أبنائك وتواصل مع المعلمين"),
        "registerAsStudent":
            MessageLookupByLibrary.simpleMessage("التسجيل كطالب"),
        "registerAsStudentSubtitle": MessageLookupByLibrary.simpleMessage(
            "انضم للفصول الدراسية وابدأ رحلتك التعليمية"),
        "remainingHours": m5,
        "requestNewLesson":
            MessageLookupByLibrary.simpleMessage("طلب درس جديد"),
        "resendCode": MessageLookupByLibrary.simpleMessage("إعادة الإرسال؟"),
        "resetCodeSubtitle": MessageLookupByLibrary.simpleMessage(
            "تحقق من بريدك الإلكتروني وأدخل الكود المرسل إليك"),
        "resetPasswordInstructions": MessageLookupByLibrary.simpleMessage(
            " واتبع التعليمات لإعادة تعيين كلمة المرور."),
        "resetPasswordSuccessSubtitle": m6,
        "resetPasswordSuccessTitle":
            MessageLookupByLibrary.simpleMessage("تم الإرسال بنجاح"),
        "reviews": MessageLookupByLibrary.simpleMessage("التقييمات"),
        "sarCurrency": MessageLookupByLibrary.simpleMessage("ريال سعودي (ر.س)"),
        "sarShort": MessageLookupByLibrary.simpleMessage("ريال"),
        "saudiCurriculum":
            MessageLookupByLibrary.simpleMessage("المنهج السعودي"),
        "saudiCurriculumDesc": MessageLookupByLibrary.simpleMessage(
            "نقدم جميع المواد الدراسية للمرحلة الابتدائية، المتوسطة، والثانوية وفق المنهج المعتمد."),
        "saveAmount": m7,
        "schedule": MessageLookupByLibrary.simpleMessage("الجدول"),
        "science": MessageLookupByLibrary.simpleMessage("العلوم"),
        "selectGrade": MessageLookupByLibrary.simpleMessage("اختر الصف"),
        "selectedPackage":
            MessageLookupByLibrary.simpleMessage("الباقة المختارة"),
        "sendResetCode":
            MessageLookupByLibrary.simpleMessage("إرسال كود الاستعادة"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("إرسال كود الاستعادة"),
        "services": MessageLookupByLibrary.simpleMessage("الخدمات"),
        "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
        "socialStudies": MessageLookupByLibrary.simpleMessage("الاجتماعيات"),
        "startLessonViaZoom":
            MessageLookupByLibrary.simpleMessage("ابدأ الحصة عبر Zoom"),
        "startNow": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
        "student": MessageLookupByLibrary.simpleMessage("طالب"),
        "studentInfo": MessageLookupByLibrary.simpleMessage("معلومات الطالب"),
        "studentName": MessageLookupByLibrary.simpleMessage("اسم الطالب"),
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
        "studentRegistrationForm":
            MessageLookupByLibrary.simpleMessage("نموذج تسجيل الطالب"),
        "studentUsername":
            MessageLookupByLibrary.simpleMessage("اسم المستخدم للطالب"),
        "studentUsesItForDashboard": MessageLookupByLibrary.simpleMessage(
            "يستخدمه الطالب للدخول على الداشبورد"),
        "studyCurriculaTitle":
            MessageLookupByLibrary.simpleMessage("المناهج الدراسية "),
        "studyMaterials":
            MessageLookupByLibrary.simpleMessage("المواد الدراسية"),
        "subjects": MessageLookupByLibrary.simpleMessage("المواد"),
        "subscribeNow": MessageLookupByLibrary.simpleMessage("اشترك الآن"),
        "subscription": MessageLookupByLibrary.simpleMessage("الاشتراك"),
        "subscriptions": MessageLookupByLibrary.simpleMessage("الاشتراكات"),
        "tabbyTamara":
            MessageLookupByLibrary.simpleMessage("قسم فاتورتك مع تمارا"),
        "to": MessageLookupByLibrary.simpleMessage("إلى"),
        "today": MessageLookupByLibrary.simpleMessage("اليوم"),
        "trainingHours": m8,
        "twelveHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 12 ساعة"),
        "twentyHoursPlan":
            MessageLookupByLibrary.simpleMessage("باقة الـ 20 ساعة"),
        "upcomingLesson": MessageLookupByLibrary.simpleMessage("الحصة القادمة"),
        "upgradePackage": MessageLookupByLibrary.simpleMessage("ترقية الباقة"),
        "usedHours": m9,
        "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
        "weeklyLessons": m10,
        "welcomeYou": MessageLookupByLibrary.simpleMessage("أهلاً بك"),
        "whatsappNumber": MessageLookupByLibrary.simpleMessage("رقم الواتساب"),
        "withTeacher":
            MessageLookupByLibrary.simpleMessage("مع أ/ سارة عبدالله")
      };
}
