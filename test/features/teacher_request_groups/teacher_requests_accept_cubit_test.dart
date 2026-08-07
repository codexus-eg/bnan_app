import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_request_action_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_teacher_requests_repo.dart';
import 'teacher_requests_test_data.dart';

void main() {
  test('accept uses requestId, removes item, and retains created ids', () async {
    final repo = FakeTeacherRequestsRepo()
      ..pages[1] = Right(page(1, 1, [request('one')]));
    final cubit = TeacherRegistrationRequestsCubit(repo);
    await cubit.refresh();

    await cubit.acceptRequest('one');

    expect(repo.acceptedIds, ['one']);
    expect(cubit.requests, isEmpty);
    expect(cubit.lastClassroomId, 'classroom');
    expect(cubit.lastChatRoomId, 'chat');
    expect(cubit.state, isA<TeacherRequestAccepted>());
  });

  test('already assigned removes stale request with friendly state', () async {
    final repo = FakeTeacherRequestsRepo()
      ..pages[1] = Right(page(1, 1, [request('one')]))
      ..acceptResult = Left(
        Failure(message: 'Conflict', code: 'REQUEST_ALREADY_ASSIGNED'),
      );
    final cubit = TeacherRegistrationRequestsCubit(repo);
    await cubit.refresh();

    await cubit.acceptRequest('one');

    expect(cubit.requests, isEmpty);
    expect(cubit.state, isA<TeacherRequestAlreadyAssigned>());
  });
}
