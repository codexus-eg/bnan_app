part of 'teacher_registration_requests_cubit.dart';

extension TeacherRequestsAcceptFlow on TeacherRegistrationRequestsCubit {
  Future<void> acceptRequest(String requestId) async {
    if (requestId.isEmpty || _acceptingRequestId != null) return;
    _acceptingRequestId = requestId;
    _emitState(TeacherRequestAccepting(requests, _pagination, requestId));
    final result = await repo.acceptRequest(requestId);
    _acceptingRequestId = null;
    result.fold((failure) => _handleAcceptFailure(requestId, failure), (
      accepted,
    ) {
      _lastClassroomId = accepted.classroomId;
      _lastChatRoomId = accepted.chatRoomId;
      _remove(requestId);
      _emitState(TeacherRequestAccepted(requests, _pagination, accepted));
    });
  }

  void _handleAcceptFailure(String requestId, Failure failure) {
    final code = failure.code ?? failure.message;
    if (code.contains('REQUEST_ALREADY_ASSIGNED')) {
      _remove(requestId);
      _emitState(TeacherRequestAlreadyAssigned(requests, _pagination));
    } else if (code.contains('TEACHER_NOT_ELIGIBLE')) {
      _emitState(TeacherRequestNotEligible(requests, _pagination));
    } else if (code.contains('GULF_TEACHER_REQUEST_NOT_FOUND')) {
      _remove(requestId);
      _emitState(TeacherRequestNotFound(requests, _pagination));
    } else {
      _emitState(
        TeacherRequestAcceptFailure(requests, _pagination, failure.message),
      );
    }
  }

  void _remove(String requestId) {
    _requests.removeWhere((request) => request.requestId == requestId);
  }
}
