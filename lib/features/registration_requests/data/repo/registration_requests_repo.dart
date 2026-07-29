import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/registration_requests/data/models/confirm_registration_payment_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/get_registration_requests_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_action_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class RegistrationRequestsRepo {
  Future<Either<Failure, GetRegistrationRequestsResponseModel>>
  getEgyptianRegistrationRequests({required String status, int page = 1});

  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  confirmEgyptianRegistrationPayment({
    required String studentId,
    required ConfirmRegistrationPaymentRequestModel request,
  });

  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  approveEgyptianRegistration({required String studentId});

  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  rejectEgyptianRegistration({required String studentId});
}
