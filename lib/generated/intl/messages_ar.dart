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

  static String m0(statusCode) => "خطأ غير معروف: ${statusCode}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "confirmPasswordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "تأكيد كلمة المرور لا يمكن أن يكون فارغًا."),
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
        "errorUnknownStatusCode": m0,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال عنوان بريد إلكتروني صالح."),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "الاسم لا يمكن أن يكون فارغًا."),
        "nameMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب أن يحتوي الاسم على 3 أحرف على الأقل."),
        "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "كلمة المرور لا يمكن أن تكون فارغة."),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل."),
        "passwordMustHaveNumber": MessageLookupByLibrary.simpleMessage(
            "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل."),
        "passwordMustHaveUpperCase": MessageLookupByLibrary.simpleMessage(
            "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل."),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("كلمتا المرور غير متطابقتين.")
      };
}
