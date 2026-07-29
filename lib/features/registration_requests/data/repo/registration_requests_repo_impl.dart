import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/registration_requests/data/models/confirm_registration_payment_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/get_registration_requests_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_action_response_model.dart';
import 'package:bnan_app/features/registration_requests/data/repo/registration_requests_repo.dart';
import 'package:dartz/dartz.dart';

class RegistrationRequestsRepoImpl implements RegistrationRequestsRepo {
  const RegistrationRequestsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GetRegistrationRequestsResponseModel>>
  getEgyptianRegistrationRequests({required String status, int page = 1}) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.egyptianRegistrationRequests,
        queryParameter: {'status': status, 'page': page},
        isProtected: true,
      );
      return GetRegistrationRequestsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  confirmEgyptianRegistrationPayment({
    required String studentId,
    required ConfirmRegistrationPaymentRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(
        EndPoints.confirmEgyptianRegistrationPayment(studentId),
        data: await request.toFormData(),
        isFormData: true,
        isProtected: true,
      );
      return _actionFromResponse(response);
    });
  }

  @override
  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  approveEgyptianRegistration({required String studentId}) {
    return _performAction(EndPoints.approveEgyptianRegistration(studentId));
  }

  @override
  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  rejectEgyptianRegistration({required String studentId}) {
    return _performAction(EndPoints.rejectEgyptianRegistration(studentId));
  }

  Future<Either<Failure, RegistrationRequestActionResponseModel>>
  _performAction(String endpoint) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(endpoint, isProtected: true);
      return _actionFromResponse(response);
    });
  }

  RegistrationRequestActionResponseModel _actionFromResponse(Object? response) {
    return RegistrationRequestActionResponseModel.fromJson(asMap(response));
  }
}
