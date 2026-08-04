import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/users_management/data/models/add_user_request_model.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/data/models/user_response_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_pagination_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_response_model.dart';
import 'package:bnan_app/features/users_management/data/repo/users_management_repo.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('typing and clearing search use a 400ms debounce', (
    tester,
  ) async {
    final repo = _UsersRepo()..pages.addAll([_response([]), _response([])]);
    final cubit = UsersManagementCubit(repo);
    await tester.pumpWidget(_bodyApp(cubit));

    await tester.enterText(find.byType(TextFormField), 'Ahmed');
    await tester.pump(const Duration(milliseconds: 399));
    expect(repo.calls, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
    expect(repo.calls.single.search, 'Ahmed');

    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(repo.calls.last.search, '');
    await cubit.close();
  });

  test('new search replaces old results and ignores stale response', () async {
    final repo = _UsersRepo()..deferSearches();
    final cubit = UsersManagementCubit(repo);

    final oldRequest = cubit.applyFilters(search: 'a', role: 'all');
    final newRequest = cubit.applyFilters(search: 'ahmed', role: 'all');
    repo.completeSearch('ahmed', [_user('2', 'Ahmed')]);
    await newRequest;
    repo.completeSearch('a', [_user('1', 'Ali')]);
    await oldRequest;

    expect(cubit.users.map((user) => user.name), ['Ahmed']);
    expect(repo.calls.map((call) => call.search), ['a', 'ahmed']);
    await cubit.close();
  });

  test('clearing search restores unfiltered page one', () async {
    final repo = _UsersRepo();
    repo.pages.addAll([
      _response([_user('1', 'Ahmed')]),
      _response([_user('2', 'Mona')]),
    ]);
    final cubit = UsersManagementCubit(repo);

    await cubit.applyFilters(search: 'Ahmed', role: 'all');
    await cubit.applyFilters(search: '', role: 'all');

    expect(repo.calls.last, (page: 1, search: '', role: null));
    expect(cubit.users.single.name, 'Mona');
    await cubit.close();
  });

  testWidgets('complete create response prepends without refresh', (
    tester,
  ) async {
    final repo = _UsersRepo()
      ..pages.addAll([
        _response([_user('1', 'Old')]),
        _response([_user('2', 'New'), _user('1', 'Old')]),
      ])
      ..createdUser = _user('2', 'New');
    final cubit = UsersManagementCubit(repo);
    await cubit.getUsers();
    await _attachForm(tester, cubit);

    await _create(cubit, name: 'New');

    expect(cubit.users.first.id, '2');
    expect(repo.calls, hasLength(1));
    await cubit.refreshUsers();
    expect(cubit.users.where((user) => user.id == '2'), hasLength(1));
    await cubit.close();
  });

  testWidgets('created user respects search and survives clearing it', (
    tester,
  ) async {
    final repo = _UsersRepo()
      ..pages.addAll([_response([]), _response([]), _response([])])
      ..createdUser = _user('3', 'Salma');
    final cubit = UsersManagementCubit(repo);
    await cubit.applyFilters(search: 'Ahmed', role: 'all');
    await _attachForm(tester, cubit);

    await _create(cubit, name: 'Salma');
    expect(cubit.users, isEmpty);
    await cubit.applyFilters(search: 'Salma', role: 'all');
    expect(cubit.users.first.id, '3');
    await cubit.applyFilters(search: '', role: 'all');
    expect(cubit.users.first.id, '3');
    await cubit.close();
  });

  testWidgets('incomplete create response refreshes page one', (tester) async {
    final repo = _UsersRepo()
      ..pages.addAll([
        _response([_user('1', 'Old')]),
        _response([_user('2', 'New'), _user('1', 'Old')]),
      ]);
    final cubit = UsersManagementCubit(repo);
    await cubit.getUsers();
    await _attachForm(tester, cubit);

    await _create(cubit, name: 'New');

    expect(repo.calls, hasLength(2));
    expect(cubit.users.first.id, '2');
    await cubit.close();
  });

  test('create response parses direct, nested, and top-level users', () {
    expect(
      _parsedResponse({
        'data': {'_id': '1'},
      })?.id,
      '1',
    );
    expect(
      _parsedResponse({
        'data': {
          'user': {'_id': '2'},
        },
      })?.id,
      '2',
    );
    expect(
      _parsedResponse({
        'user': {'_id': '3'},
      })?.id,
      '3',
    );
  });
}

Widget _bodyApp(UsersManagementCubit cubit) {
  return BlocProvider.value(
    value: cubit,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const Scaffold(body: UsersManagementBody()),
    ),
  );
}

Future<void> _attachForm(WidgetTester tester, UsersManagementCubit cubit) {
  cubit.setSelectedRole('student');
  return tester.pumpWidget(
    MaterialApp(
      home: Form(key: cubit.formKey, child: const SizedBox()),
    ),
  );
}

Future<void> _create(UsersManagementCubit cubit, {required String name}) {
  return cubit.createUser(
    user: _user('', name),
    password: 'Password1',
    curriculumId: 'curriculum-1',
  );
}

UserItem? _parsedResponse(Map<String, dynamic> json) {
  return UserResponseModel.fromJson({'success': true, ...json}).user;
}

class _UsersRepo implements UsersManagementRepo {
  final pages = <UsersResponseModel>[];
  final calls = <({int page, String? search, String? role})>[];
  final pending = <String, Completer<Either<Failure, UsersResponseModel>>>{};
  UserItem? createdUser;
  bool _deferred = false;

  void deferSearches() => _deferred = true;

  void completeSearch(String search, List<UserItem> users) {
    pending[search]!.complete(Right(_response(users)));
  }

  @override
  Future<Either<Failure, UsersResponseModel>> getUsers({
    required int page,
    String? search,
    String? role,
  }) {
    calls.add((page: page, search: search, role: role));
    if (_deferred) {
      return (pending[search ?? ''] ??= Completer()).future;
    }
    return Future.value(Right(pages.removeAt(0)));
  }

  @override
  Future<Either<Failure, UserResponseModel>> createUser({
    required AddUserRequestModel request,
  }) async {
    return Right(UserResponseModel(success: true, user: createdUser));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UsersResponseModel _response(List<UserItem> users) => UsersResponseModel(
  success: true,
  results: users.length,
  pagination: UsersPaginationModel(
    currentPage: 1,
    perPage: 20,
    total: users.length,
    lastPage: 1,
  ),
  data: users,
);

UserItem _user(String id, String name) => UserItem.fromJson({
  '_id': id,
  'fullName': name,
  'phone': '01000000000',
  'role': 'student',
});
