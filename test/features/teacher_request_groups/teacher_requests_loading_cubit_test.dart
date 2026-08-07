import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_teacher_requests_repo.dart';
import 'teacher_requests_test_data.dart';

void main() {
  test('refresh replaces list and pagination appends unique requests', () async {
    final repo = FakeTeacherRequestsRepo()
      ..pages[1] = Right(page(1, 2, [request('one')]))
      ..pages[2] = Right(page(2, 2, [request('one'), request('two')]));
    final cubit = TeacherRegistrationRequestsCubit(repo);

    await cubit.refresh();
    await cubit.loadMore();

    expect(cubit.requests.map((item) => item.requestId), ['one', 'two']);
    expect(repo.requestedPages, [1, 2]);
    expect(cubit.state, isA<TeacherRequestsSuccess>());
  });

  test('empty first page emits empty and does not load page two', () async {
    final repo = FakeTeacherRequestsRepo()
      ..pages[1] = Right(page(1, 0, []));
    final cubit = TeacherRegistrationRequestsCubit(repo);

    await cubit.refresh();
    await cubit.loadMore();

    expect(cubit.state, isA<TeacherRequestsEmpty>());
    expect(repo.requestedPages, [1]);
  });
}
