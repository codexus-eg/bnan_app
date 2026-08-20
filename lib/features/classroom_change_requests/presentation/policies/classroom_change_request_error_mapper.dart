import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/generated/l10n.dart';

String mapClassroomChangeRequestFailure(Failure failure) {
  final code = (failure.code ?? '').trim().toUpperCase();
  if (code == 'CHANGE_TEACHER_REQUEST_ALREADY_PENDING') {
    return S.current.changeTeacherRequestAlreadyPending;
  }
  return failure.message;
}
