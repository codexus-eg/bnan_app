import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_requests_page.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo.dart';

class AdminSubjectRequestsRepoImpl implements AdminSubjectRequestsRepo {
  const AdminSubjectRequestsRepoImpl(this._api);
  final ApiConsumer _api;

  @override
  getRequests({int page = 1, int limit = 20}) => repoGuard(
    () async => AdminSubjectRequestsPage.fromJson(
      asMap(
        await _api.get(
          EndPoints.adminSubjectRequests,
          queryParameter: {'page': page, 'limit': limit},
          isProtected: true,
        ),
      ),
    ),
  );

  @override
  approve({
    required String requestId,
    required AdminSubjectRequestApproval approval,
  }) => repoGuard(() async {
    final response = asMap(
      await _api.patch(
        EndPoints.approveAdminSubjectRequest(requestId),
        data: await approval.toFormData(),
        isFormData: true,
        isProtected: true,
      ),
    );
    return _message(response);
  });

  @override
  reject(String requestId) => repoGuard(() async {
    final response = asMap(
      await _api.patch(
        EndPoints.rejectAdminSubjectRequest(requestId),
        isProtected: true,
      ),
    );
    return _message(response);
  });

  String _message(Map<String, dynamic> json) =>
      json['message']?.toString().trim() ?? '';
}
