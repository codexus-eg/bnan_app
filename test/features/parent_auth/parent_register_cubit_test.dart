import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_user_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo.dart';
import 'package:bnan_app/features/parent_auth/presentation/manager/parent_register_cubit/parent_register_cubit.dart';
import 'package:bnan_app/features/parent_auth/presentation/manager/parent_register_cubit/parent_register_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const request = ParentRegisterRequestModel(
    fullName: 'Parent',
    email: 'parent@bnan.edu',
    password: '123456',
    phone: '123',
    whatsappNumber: '',
  );

  test('emits loading then success', () async {
    final cubit = ParentRegisterCubit(_FakeRepo(const Right(_response)));
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<ParentRegisterLoading>(),
        isA<ParentRegisterSuccess>(),
      ]),
    );
    await cubit.registerParent(request);
    await states;
    await cubit.close();
  });

  test('emits loading then backend failure message', () async {
    final cubit = ParentRegisterCubit(
      _FakeRepo(Left(Failure(message: 'البريد مستخدم بالفعل'))),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<ParentRegisterLoading>(),
        isA<ParentRegisterFailure>().having(
          (state) => state.errorMessage,
          'message',
          'البريد مستخدم بالفعل',
        ),
      ]),
    );
    await cubit.registerParent(request);
    await states;
    await cubit.close();
  });
}

const _response = ParentRegisterResponseModel(
  success: true,
  token: 'token',
  data: ParentRegisterUserModel(
    id: 'id',
    fullName: 'Parent',
    email: 'parent@bnan.edu',
    role: 'parent',
    status: 'active',
    createdAt: '',
    updatedAt: '',
  ),
);

class _FakeRepo implements ParentAuthRepo {
  _FakeRepo(this.result);
  final Either<Failure, ParentRegisterResponseModel> result;

  @override
  Future<Either<Failure, ParentRegisterResponseModel>> registerParent(
    ParentRegisterRequestModel request,
  ) async => result;
}
