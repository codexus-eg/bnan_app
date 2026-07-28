import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/registration_requests/data/models/confirm_registration_payment_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_action_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/repo/registration_requests_repo.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/registration_request_actions_cubit/registration_request_actions_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationRequestActionsCubit
    extends Cubit<RegistrationRequestActionsState> {
  RegistrationRequestActionsCubit(this.registrationRequestsRepo)
    : super(RegistrationRequestActionsInitial());

  final RegistrationRequestsRepo registrationRequestsRepo;
  final Set<String> _loadingActions = {};

  Future<void> confirmPayment({
    required String studentId,
    required ConfirmRegistrationPaymentRequestModel request,
  }) {
    return _perform(
      studentId: studentId,
      actionType: RegistrationRequestActionType.confirmPayment,
      request: () =>
          registrationRequestsRepo.confirmEgyptianRegistrationPayment(
            studentId: studentId,
            request: request,
          ),
    );
  }

  Future<void> approveRegistration({required String studentId}) {
    return _perform(
      studentId: studentId,
      actionType: RegistrationRequestActionType.approve,
      request: () => registrationRequestsRepo.approveEgyptianRegistration(
        studentId: studentId,
      ),
    );
  }

  Future<void> rejectRegistration({required String studentId}) {
    return _perform(
      studentId: studentId,
      actionType: RegistrationRequestActionType.reject,
      request: () => registrationRequestsRepo.rejectEgyptianRegistration(
        studentId: studentId,
      ),
    );
  }

  bool isActionLoading({
    required String studentId,
    required RegistrationRequestActionType actionType,
  }) {
    return _loadingActions.contains(_actionKey(studentId, actionType));
  }

  Future<void> _perform({
    required String studentId,
    required RegistrationRequestActionType actionType,
    required Future<Either<Failure, RegistrationRequestActionResponseModel>>
    Function()
    request,
  }) async {
    final key = _actionKey(studentId, actionType);
    if (_loadingActions.contains(key)) return;
    _loadingActions.add(key);
    emit(
      RegistrationRequestActionLoading(
        studentId: studentId,
        actionType: actionType,
      ),
    );

    try {
      final result = await request();
      if (isClosed) return;
      _loadingActions.remove(key);
      result.fold(
        (failure) => emit(
          RegistrationRequestActionFailure(
            studentId: studentId,
            actionType: actionType,
            errorMessage: failure.message,
          ),
        ),
        (response) => emit(
          RegistrationRequestActionSuccess(
            studentId: studentId,
            actionType: actionType,
            message: response.message,
            student: response.student,
          ),
        ),
      );
    } finally {
      _loadingActions.remove(key);
    }
  }

  String _actionKey(
    String studentId,
    RegistrationRequestActionType actionType,
  ) {
    return '$studentId-${actionType.name}';
  }
}
