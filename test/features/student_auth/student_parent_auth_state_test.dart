import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_user_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cases = <(Failure, Type, bool)>[
    (
      Failure(message: 'missing', statusCode: 404),
      ParentVerificationRequired,
      true,
    ),
    (
      Failure(message: 'raw credentials error', code: 'INCORRECT_LOGIN_DATA'),
      ParentVerificationRequired,
      true,
    ),
    (
      Failure(message: 'inactive', code: 'ACCOUNT_NOT_VERIFIED'),
      ParentVerificationRequired,
      false,
    ),
  ];
  for (final scenario in cases) {
    testWidgets('maps ${scenario.$1.message} parent correctly', (tester) async {
      final registrationRepo = _RegistrationRepo(const Right(_response));
      final cubit = RegisterCubit(
        _AuthRepo(),
        _ParentRepo(scenario.$1),
        registrationRepo,
      );
      addTearDown(cubit.close);
      await tester.pumpWidget(_app(cubit));
      cubit.applyParentCredentials(
        email: 'parent@bnan.edu',
        password: '12345678',
      );
      cubit.parentNameController.text = 'Parent Name';
      cubit.parentPhoneController.text = '01000000000';
      await cubit.authenticateParentAndContinue();
      expect(cubit.state.runtimeType, scenario.$2);
      expect(registrationRepo.calls, scenario.$3 ? 1 : 0);
    });
  }

  testWidgets('401 incorrect login auto-registers parent before failure', (
    tester,
  ) async {
    final loginApi = _IncorrectLoginApi();
    final registrationRepo = _RegistrationRepo(const Right(_response));
    final cubit = RegisterCubit(
      _AuthRepo(),
      GulfParentAuthRepoImpl(loginApi),
      registrationRepo,
    );
    final emitted = <RegisterState>[];
    final subscription = cubit.stream.listen(emitted.add);
    addTearDown(subscription.cancel);
    addTearDown(cubit.close);
    await tester.pumpWidget(_app(cubit));

    await cubit.authenticateParentAndContinue();

    expect(loginApi.paths, [EndPoints.login]);
    expect(registrationRepo.calls, 1);
    expect(cubit.state, isA<ParentVerificationRequired>());
    expect(emitted.whereType<RegisterFailure>(), isEmpty);
  });

  testWidgets('successful non-parent login stays on parent step', (
    tester,
  ) async {
    final loginApi = _SuccessfulLoginApi(role: 'student');
    final registrationRepo = _RegistrationRepo(const Right(_response));
    final cubit = RegisterCubit(
      _AuthRepo(),
      GulfParentAuthRepoImpl(loginApi),
      registrationRepo,
    );
    addTearDown(cubit.close);
    await tester.pumpWidget(_app(cubit));

    await cubit.authenticateParentAndContinue();

    expect(loginApi.paths, [EndPoints.login]);
    expect(registrationRepo.calls, 0);
    expect(cubit.state, isA<RegisterFailure>());
    expect(
      (cubit.state as RegisterFailure).errorMessage,
      S.current.studentRegistrationEmailBelongsToAnotherAccount,
    );
  });

  testWidgets('incorrect login then duplicate registration does not retry', (
    tester,
  ) async {
    final registrationRepo = _RegistrationRepo(
      Left(Failure(message: 'raw duplicate', code: 'EMAIL_ALREADY_EXISTS')),
    );
    final cubit = RegisterCubit(
      _AuthRepo(),
      _ParentRepo(
        Failure(message: 'raw credentials', code: 'INCORRECT_LOGIN_DATA'),
      ),
      registrationRepo,
    );
    addTearDown(cubit.close);
    await tester.pumpWidget(_app(cubit));
    await cubit.authenticateParentAndContinue();

    expect(registrationRepo.calls, 1);
    expect(cubit.state, isA<RegisterFailure>());
    expect(
      (cubit.state as RegisterFailure).errorMessage,
      S.current.studentRegistrationEmailAlreadyRegistered,
    );
  });
}

Widget _app(RegisterCubit cubit) => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Form(key: cubit.parentFormKey, child: const SizedBox()),
);

class _AuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ParentRepo implements GulfParentAuthRepo {
  _ParentRepo(this.failure);
  final Failure failure;
  @override
  Future<Either<Failure, AuthResponseModel>> authenticate(
    RegisterParentModel request,
  ) async => Left(failure);
}

class _RegistrationRepo implements ParentAuthRepo {
  _RegistrationRepo(this.result);

  final Either<Failure, ParentRegisterResponseModel> result;
  int calls = 0;

  @override
  Future<Either<Failure, ParentRegisterResponseModel>> registerParent(
    ParentRegisterRequestModel request,
  ) async {
    calls++;
    return result;
  }
}

class _IncorrectLoginApi implements ApiConsumer {
  final paths = <String>[];

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    paths.add(path);
    throw AppException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: path),
        response: Response(
          requestOptions: RequestOptions(path: path),
          statusCode: 401,
          data: const {'backendCode': 'INCORRECT_LOGIN_DATA'},
        ),
        type: DioExceptionType.badResponse,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SuccessfulLoginApi implements ApiConsumer {
  _SuccessfulLoginApi({required this.role});

  final String role;
  final paths = <String>[];

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    paths.add(path);
    return {
      'success': true,
      'token': 'token',
      'data': {
        'user': {
          '_id': 'user-1',
          'fullName': 'Existing User',
          'email': 'existing@bnan.edu',
          'role': role,
          'status': 'active',
        },
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _response = ParentRegisterResponseModel(
  success: true,
  token: '',
  data: ParentRegisterUserModel(
    id: 'parent-1',
    fullName: 'Parent Name',
    email: 'parent@bnan.edu',
    role: 'parent',
    status: 'pending',
    createdAt: '',
    updatedAt: '',
  ),
);
