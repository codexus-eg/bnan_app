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

  static String m0(statusCode) => "Unknown status code: ${statusCode}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "confirmPasswordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Confirm password cannot be empty."),
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
        "errorUnknownStatusCode": m0,
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Name cannot be empty."),
        "nameMinLength": MessageLookupByLibrary.simpleMessage(
            "Name must be at least 3 characters."),
        "passwordCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty."),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters."),
        "passwordMustHaveNumber": MessageLookupByLibrary.simpleMessage(
            "Password must contain at least one number."),
        "passwordMustHaveUpperCase": MessageLookupByLibrary.simpleMessage(
            "Password must contain at least one uppercase letter."),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match.")
      };
}
