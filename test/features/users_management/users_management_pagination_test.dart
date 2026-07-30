import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_pagination_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_response_model.dart';
import 'package:bnan_app/features/users_management/data/repo/users_management_repo.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads 43 users across three pages without duplicate ids', () async {
    final repo = _FakeUsersRepo({
      1: _response(1, List.generate(20, (i) => _user('${i + 1}'))),
      2: _response(2, List.generate(20, (i) => _user('${i + 21}'))),
      3: _response(3, [_user('40'), _user('41'), _user('42'), _user('43')]),
    });
    final cubit = UsersManagementCubit(repo);

    await cubit.getUsers();
    expect(cubit.users, hasLength(20));
    expect(cubit.usersCount, 43);

    await cubit.loadMore();
    expect(cubit.users, hasLength(40));

    await cubit.loadMore();
    expect(cubit.users, hasLength(43));
    expect(cubit.canLoadMore, isFalse);

    await cubit.loadMore();
    expect(repo.calls.map((call) => call.page), [1, 2, 3]);
    await cubit.close();
  });

  test(
    'keeps filters for every page and preserves users without ids',
    () async {
      final repo = _FakeUsersRepo({
        1: _response(1, [_user(''), _user(''), _user('1'), _user('1')]),
        2: _response(2, [_user('2')]),
      });
      final cubit = UsersManagementCubit(repo);

      await cubit.applyFilters(search: ' Salma ', role: 'teacher');
      expect(cubit.users, hasLength(3));
      await cubit.loadMore();

      expect(repo.calls, [
        (page: 1, search: 'Salma', role: 'teacher'),
        (page: 2, search: 'Salma', role: 'teacher'),
      ]);
      await cubit.close();
    },
  );

  test('parses both id keys and curriculum string, list, or null', () {
    expect(_parsed({'_id': 'mongo', 'curriculum': 'Egyptian'}).id, 'mongo');
    expect(
      _parsed({
        'id': 'plain',
        'curriculum': ['Saudi'],
      }).id,
      'plain',
    );
    expect(_parsed({'curriculum': 'Egyptian'}).curriculum, ['Egyptian']);
    expect(
      _parsed({
        'curriculum': ['Saudi', 'Saudi2'],
      }).curriculum,
      ['Saudi', 'Saudi2'],
    );
    expect(_parsed({'curriculum': null}).curriculum, isEmpty);
  });
}

class _FakeUsersRepo implements UsersManagementRepo {
  _FakeUsersRepo(this.pages);

  final Map<int, UsersResponseModel> pages;
  final List<({int page, String? search, String? role})> calls = [];

  @override
  Future<Either<Failure, UsersResponseModel>> getUsers({
    required int page,
    String? search,
    String? role,
  }) async {
    calls.add((page: page, search: search, role: role));
    return Right(pages[page]!);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UsersResponseModel _response(int page, List<UserItem> users) {
  return UsersResponseModel(
    success: true,
    results: users.length,
    pagination: UsersPaginationModel(
      currentPage: page,
      perPage: 20,
      total: 43,
      lastPage: page == 2 && users.length == 1 ? 2 : 3,
    ),
    data: users,
  );
}

UserItem _parsed(Map<String, dynamic> json) => UserItem.fromJson(json);

UserItem _user(String id) => UserItem.fromJson({'_id': id});
