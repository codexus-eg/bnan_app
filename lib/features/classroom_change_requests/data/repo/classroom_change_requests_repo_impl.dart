import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_requests_page.dart';
import 'classroom_change_requests_repo.dart';

class ClassroomChangeRequestsRepoImpl implements ClassroomChangeRequestsRepo {
  const ClassroomChangeRequestsRepoImpl(this._api);
  final ApiConsumer _api;

  @override
  submitStudent({
    required String classroomId,
    String? classroomSubjectId,
    required String notes,
    String requestType = 'change_teacher',
  }) => repoGuard(
    () async => _message(
      await _api.post(
        EndPoints.classroomChangeRequests(classroomId),
        data: {
          'requestType': requestType,
          if (requestType == 'change_teacher')
            'classroomSubjectId': classroomSubjectId?.trim(),
          'notes': notes.trim(),
        },
        isProtected: true,
      ),
    ),
  );

  @override
  submitTeacher({required String classroomId, required String notes}) =>
      repoGuard(
        () async => _message(
          await _api.post(
            EndPoints.classroomTeacherRequests(classroomId),
            data: {'notes': notes.trim()},
            isProtected: true,
          ),
        ),
      );

  @override
  getAdminRequests() => repoGuard(
    () async => ClassroomChangeRequestsPage.fromJson(
      asMap(
        await _api.get(
          EndPoints.adminClassroomChangeRequests,
          isProtected: true,
        ),
      ),
    ),
  );

  @override
  getAdminRequest(String id) => repoGuard(() async {
    final json = asMap(
      await _api.get(
        EndPoints.adminClassroomChangeRequest(id),
        isProtected: true,
      ),
    );
    final data = json['data'];
    final nested = data is Map ? Map<String, dynamic>.from(data) : json;
    final request = nested['request'];
    return ClassroomChangeRequestModel.fromJson(
      request is Map ? Map<String, dynamic>.from(request) : nested,
    );
  });

  @override
  approve(String id, {String? adminNotes}) => repoGuard(
    () async => _message(
      await _api.patch(
        EndPoints.approveClassroomChangeRequest(id),
        data: {
          if (adminNotes?.trim().isNotEmpty == true)
            'adminNotes': adminNotes!.trim(),
        },
        isProtected: true,
      ),
    ),
  );

  @override
  reject(String id, {required String rejectionReason}) => repoGuard(
    () async => _message(
      await _api.patch(
        EndPoints.rejectClassroomChangeRequest(id),
        data: {'rejectionReason': rejectionReason.trim()},
        isProtected: true,
      ),
    ),
  );

  String _message(Object? response) =>
      asMap(response)['message']?.toString() ?? '';
}
