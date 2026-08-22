import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/generated/l10n.dart';

String mapStudentClassroomsFailure(Failure failure) {
  final code = (failure.code ?? failure.message).trim().toUpperCase();
  if (code == 'STUDENT_NOT_APPROVED') {
    return S.current.studentAssignmentNotApproved;
  }
  if (code == 'NO_AVAILABLE_CLASSROOMS') {
    return S.current.studentAssignmentNoClassrooms;
  }
  if (code == 'STUDENT_ALREADY_ASSIGNED') {
    return S.current.studentAssignmentAlreadyAssigned;
  }
  if (failure.statusCode == 401) {
    return S.current.sessionExpiredLoginAgain;
  }
  if (!failure.responseReceived) {
    return S.current.internetConnectionFailedRetry;
  }
  return S.current.studentClassroomsLoadFailed;
}
