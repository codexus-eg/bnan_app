import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initial state is GetParentChildrenInitial', () async {
    final cubit = GetParentChildrenCubit(_FakeParentHomeRepo(_emptySuccess));
    expect(cubit.state, isA<GetParentChildrenInitial>());
    await cubit.close();
  });

  test('emits loading then success with repository children', () async {
    const children = [ParentChildModel(id: 'child-1', fullName: 'Child One')];
    final repo = _FakeParentHomeRepo(
      const Right(GetParentChildrenResponseModel(data: children)),
    );
    final cubit = GetParentChildrenCubit(repo);
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<GetParentChildrenLoading>(),
        isA<GetParentChildrenSuccess>().having(
          (state) => state.children,
          'children',
          children,
        ),
      ]),
    );

    await cubit.getParentChildren();

    await expectation;
    expect(repo.calls, 1);
    expect(
      (cubit.state as GetParentChildrenSuccess).selectedChildId,
      'child-1',
    );
    await cubit.close();
  });

  test('selects children by id and ignores missing ids', () async {
    const children = [
      ParentChildModel(id: 'child-1'),
      ParentChildModel(id: 'child-2'),
    ];
    final cubit = GetParentChildrenCubit(
      _FakeParentHomeRepo(
        const Right(GetParentChildrenResponseModel(data: children)),
      ),
    );
    await cubit.getParentChildren();

    cubit.selectChild('missing');
    expect(
      (cubit.state as GetParentChildrenSuccess).selectedChildId,
      'child-1',
    );
    cubit.selectChild('child-2');
    expect(
      (cubit.state as GetParentChildrenSuccess).selectedChildId,
      'child-2',
    );
    await cubit.close();
  });

  test('empty repository list is emitted as success', () async {
    final repo = _FakeParentHomeRepo(_emptySuccess);
    final cubit = GetParentChildrenCubit(repo);
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<GetParentChildrenLoading>(),
        isA<GetParentChildrenSuccess>().having(
          (state) => state.children,
          'children',
          isEmpty,
        ),
      ]),
    );

    await cubit.getParentChildren();

    await expectation;
    expect(repo.calls, 1);
    await cubit.close();
  });

  test('emits loading then failure with repository message', () async {
    final repo = _FakeParentHomeRepo(Left(Failure(message: 'failed')));
    final cubit = GetParentChildrenCubit(repo);
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<GetParentChildrenLoading>(),
        isA<GetParentChildrenFailure>().having(
          (state) => state.errorMessage,
          'errorMessage',
          'failed',
        ),
      ]),
    );

    await cubit.getParentChildren();

    await expectation;
    expect(repo.calls, 1);
    await cubit.close();
  });
}

const _emptySuccess = Right<Failure, GetParentChildrenResponseModel>(
  GetParentChildrenResponseModel(),
);

class _FakeParentHomeRepo implements ParentHomeRepo {
  _FakeParentHomeRepo(this.result);

  final Either<Failure, GetParentChildrenResponseModel> result;
  int calls = 0;

  @override
  Future<Either<Failure, GetParentChildrenResponseModel>>
  getParentChildren() async {
    calls++;
    return result;
  }
}
