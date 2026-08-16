import 'package:bnan_app/core/error/failure.dart';

bool isChatAccessDenied(Failure failure) {
  final code = (failure.code ?? '').trim().toUpperCase();
  return failure.statusCode == 403 &&
      (code == 'CHAT_ACCESS_DENIED' ||
          failure.message.toUpperCase().contains('CHAT_ACCESS_DENIED'));
}
