import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subjects/data/repo/student_subjects_repo.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emits success, empty, failure, unauthorized, and retries', () async {
    final repo = _FakeRepo([
      const Right([StudentSubjectModel(id: 'one', name: 'English')]),
      const Right([]),
      Left(Failure(message: 'network')),
      Left(Failure(message: 'unauthorized', statusCode: 401)),
    ]);
    final cubit = GetMySubjectsCubit(repo);

    await cubit.loadSubjects();
    expect(cubit.state, isA<GetMySubjectsSuccess>());
    await cubit.retry();
    expect(cubit.state, isA<GetMySubjectsEmpty>());
    await cubit.retry();
    expect(cubit.state, isA<GetMySubjectsFailure>());
    await cubit.retry();
    expect(cubit.state, isA<GetMySubjectsUnauthorized>());
    expect(repo.calls, 4);
    await cubit.close();
  });
}

class _FakeRepo implements StudentSubjectsRepo {
  _FakeRepo(this.results);

  final List<Either<Failure, List<StudentSubjectModel>>> results;
  int calls = 0;

  @override
  Future<Either<Failure, List<StudentSubjectModel>>> getMySubjects() async {
    return results[calls++];
  }
}
