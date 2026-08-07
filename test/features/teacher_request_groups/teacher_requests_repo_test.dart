import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/teacher_request_groups/data/repo/teacher_registration_requests_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_teacher_requests_api.dart';

void main() {
  test('GET uses protected endpoint with page and limit', () async {
    final api = FakeTeacherRequestsApi();
    final result = await TeacherRegistrationRequestsRepoImpl(
      api,
    ).getRequests(page: 2);

    expect(result.isRight(), isTrue);
    expect(api.getPath, EndPoints.gulfTeacherRequests);
    expect(api.query, {'page': 2, 'limit': 20});
    expect(api.getProtected, isTrue);
  });

  test('accept PATCH uses requestId and has no body', () async {
    final api = FakeTeacherRequestsApi();
    final result = await TeacherRegistrationRequestsRepoImpl(
      api,
    ).acceptRequest('teacher-request');

    expect(result.isRight(), isTrue);
    expect(
      api.patchPath,
      EndPoints.acceptGulfTeacherRequest('teacher-request'),
    );
    expect(api.patchData, isNull);
    expect(api.patchProtected, isTrue);
  });
}
