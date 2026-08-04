import 'package:bnan_app/features/users_management/data/models/add_user_request_model.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_pagination_model.dart';
import 'package:bnan_app/features/users_management/data/repo/users_management_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_management_state.dart';

class UsersManagementCubit extends Cubit<UsersManagementState> {
  UsersManagementCubit(this.usersManagementRepo)
    : super(const UsersManagementInitial());

  final UsersManagementRepo usersManagementRepo;
  final formKey = GlobalKey<FormState>();

  List<UserItem> users = [];
  final List<UserItem> _locallyCreatedUsers = [];
  int usersCount = 0;
  UserItem? selectedUser;
  String? selectedRole;
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;
  int _requestId = 0;
  String _search = '';
  String? _role;

  bool get canLoadMore => !_isLoadingMore && _currentPage < _lastPage;

  Future<void> getUsers({bool refresh = false, bool emitLoading = true}) async {
    final requestId = ++_requestId;
    _isLoadingMore = false;
    if (refresh) _resetPagination();
    if (emitLoading) emit(const GetUsersLoading());

    final result = await usersManagementRepo.getUsers(
      page: 1,
      search: _search,
      role: _role,
    );
    if (isClosed || requestId != _requestId) return;

    result.fold((failure) => emit(GetUsersFailure(failure.message)), (
      response,
    ) {
      users = _withLocalUsers(response.data);
      _setPagination(response.pagination);
      emit(_success());
    });
  }

  Future<void> refreshUsers({bool emitLoading = false}) {
    return getUsers(refresh: true, emitLoading: emitLoading);
  }

  Future<void> applyFilters({
    required String search,
    required String role,
  }) async {
    final nextSearch = search.trim();
    final nextRole = role == 'all' ? null : role;
    if (_search == nextSearch && _role == nextRole) return;
    _search = nextSearch;
    _role = nextRole;
    users = [];
    usersCount = 0;
    await refreshUsers(emitLoading: true);
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    _isLoadingMore = true;
    final requestId = _requestId;
    final nextPage = _currentPage + 1;
    emit(GetUsersLoadingMore(users: List.unmodifiable(users)));

    try {
      final result = await usersManagementRepo.getUsers(
        page: nextPage,
        search: _search,
        role: _role,
      );
      if (isClosed || requestId != _requestId) return;
      _isLoadingMore = false;
      result.fold(
        (failure) => emit(
          GetUsersLoadMoreFailure(
            users: List.unmodifiable(users),
            message: failure.message,
          ),
        ),
        (response) {
          _appendUnique(response.data);
          _setPagination(response.pagination);
          emit(_success());
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> getUserDetails({required String userId}) async {
    emit(const GetUserDetailsLoading());

    final result = await usersManagementRepo.getUserDetails(userId: userId);
    result.fold((failure) => emit(GetUserDetailsFailure(failure.message)), (
      response,
    ) {
      selectedUser = response.user;
      emit(GetUserDetailsSuccess(user: selectedUser));
    });
  }

  void prepareAdd() {
    selectedUser = null;
    selectedRole = null;
  }

  void prepareEdit(UserItem user) {
    selectedUser = user;
    selectedRole = user.roles;
  }

  void setSelectedRole(String role) {
    selectedRole = role;
  }

  Future<void> createUser({
    required UserItem user,
    required String password,
    required String curriculumId,
  }) async {
    if (state is UsersActionLoading &&
        (state as UsersActionLoading).action == UsersManagementAction.create) {
      return;
    }
    if (formKey.currentState?.validate() != true) return;
    final role = selectedRole?.trim() ?? '';
    final selectedCurriculumId = curriculumId.trim();
    if (role.isEmpty || selectedCurriculumId.isEmpty) return;

    emit(const UsersActionLoading(action: UsersManagementAction.create));
    final result = await usersManagementRepo.createUser(
      request: AddUserRequestModel(
        fullName: user.name,
        email: user.email,
        phone: user.phone,
        role: role,
        password: password,
        curriculumId: selectedCurriculumId,
      ),
    );

    await result.fold(
      (failure) async => emit(
        UsersActionFailure(
          action: UsersManagementAction.create,
          message: failure.message,
        ),
      ),
      (response) async {
        final createdUser = response.user;
        if (createdUser != null && createdUser.id.isNotEmpty) {
          final isNew = _rememberCreatedUser(createdUser);
          if (_matchesCurrentFilters(createdUser)) {
            users = _prependUnique(createdUser, users);
          }
          if (isNew) usersCount++;
        }
        emit(const UsersActionSuccess(action: UsersManagementAction.create));
        if (createdUser == null || createdUser.id.isEmpty) await refreshUsers();
      },
    );
  }

  Future<void> updateUser({
    required String userId,
    required UserItem user,
  }) async {
    if (formKey.currentState?.validate() != true) return;

    emit(const UsersActionLoading(action: UsersManagementAction.update));
    final result = await usersManagementRepo.updateUser(
      userId: userId,
      user: _withoutRole(user),
    );

    await result.fold(
      (failure) async => emit(
        UsersActionFailure(
          action: UsersManagementAction.update,
          message: failure.message,
        ),
      ),
      (response) async {
        _replaceLocalUser(response.user);
        emit(const UsersActionSuccess(action: UsersManagementAction.update));
        await refreshUsers();
      },
    );
  }

  Future<void> updateUserPassword({
    required String userId,
    required String password,
  }) async {
    if (formKey.currentState?.validate() != true) return;

    emit(const UsersActionLoading(action: UsersManagementAction.password));
    final result = await usersManagementRepo.updateUserPassword(
      userId: userId,
      password: password,
    );

    await result.fold(
      (failure) async => emit(
        UsersActionFailure(
          action: UsersManagementAction.password,
          message: failure.message,
        ),
      ),
      (_) async {
        emit(const UsersActionSuccess(action: UsersManagementAction.password));
        await refreshUsers();
      },
    );
  }

  Future<void> updateUserStatus({required UserItem user}) async {
    final currentStatus = user.status.toLowerCase();
    final nextStatus = currentStatus == 'active' ? 'inactive' : 'active';

    emit(const UsersActionLoading(action: UsersManagementAction.status));
    final result = await usersManagementRepo.updateUserStatus(
      userId: user.id,
      status: nextStatus,
    );

    await result.fold(
      (failure) async => emit(
        UsersActionFailure(
          action: UsersManagementAction.status,
          message: failure.message,
        ),
      ),
      (response) async {
        _replaceLocalUser(response.user);
        emit(const UsersActionSuccess(action: UsersManagementAction.status));
        await refreshUsers();
      },
    );
  }

  Future<void> deleteUser({required String userId}) async {
    emit(const UsersActionLoading(action: UsersManagementAction.delete));
    final result = await usersManagementRepo.deleteUser(userId: userId);

    await result.fold(
      (failure) async => emit(
        UsersActionFailure(
          action: UsersManagementAction.delete,
          message: failure.message,
        ),
      ),
      (_) async {
        _locallyCreatedUsers.removeWhere((user) => user.id == userId);
        emit(const UsersActionSuccess(action: UsersManagementAction.delete));
        await refreshUsers();
      },
    );
  }

  UserItem _withRole(UserItem user, String role) {
    return UserItem(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      registrationDate: user.registrationDate,
      parentName: user.parentName,
      classes: user.classes,
      roles: role,
      status: user.status,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      curriculum: user.curriculum,
      grade: user.grade,
    );
  }

  UserItem _withoutRole(UserItem user) => _withRole(user, '');

  void _appendUnique(List<UserItem> newUsers) {
    final knownIds = users
        .map((user) => user.id)
        .where((id) => id.isNotEmpty)
        .toSet();
    users.addAll(
      newUsers.where((user) => user.id.isEmpty || knownIds.add(user.id)),
    );
  }

  List<UserItem> _unique(List<UserItem> source) {
    final ids = <String>{};
    return source.where((user) => user.id.isEmpty || ids.add(user.id)).toList();
  }

  List<UserItem> _withLocalUsers(List<UserItem> apiUsers) {
    final local = _locallyCreatedUsers.where(_matchesCurrentFilters).toList();
    return _unique([...local, ...apiUsers]);
  }

  List<UserItem> _prependUnique(UserItem user, List<UserItem> source) {
    return [
      user,
      ...source.where((item) => item.id.isEmpty || item.id != user.id),
    ];
  }

  bool _rememberCreatedUser(UserItem user) {
    final isNew = _locallyCreatedUsers.every((item) => item.id != user.id);
    _locallyCreatedUsers.removeWhere((item) => item.id == user.id);
    _locallyCreatedUsers.insert(0, user);
    return isNew;
  }

  void _replaceLocalUser(UserItem? user) {
    if (user == null) return;
    final index = _locallyCreatedUsers.indexWhere((item) => item.id == user.id);
    if (index != -1) _locallyCreatedUsers[index] = user;
  }

  bool _matchesCurrentFilters(UserItem user) {
    final matchesRole =
        _role == null ||
        user.roles.trim().toLowerCase() == _role!.trim().toLowerCase();
    if (!matchesRole) return false;
    final query = _search.toLowerCase();
    if (query.isEmpty) return true;
    return user.name.toLowerCase().contains(query) ||
        user.phone.toLowerCase().contains(query);
  }

  void _setPagination(UsersPaginationModel pagination) {
    _currentPage = pagination.currentPage;
    _lastPage = pagination.lastPage;
    usersCount = pagination.total;
  }

  GetUsersSuccess _success() {
    return GetUsersSuccess(
      users: List.unmodifiable(users),
      usersCount: usersCount,
      canLoadMore: canLoadMore,
      currentPage: _currentPage,
    );
  }

  void _resetPagination() {
    _currentPage = 1;
    _lastPage = 1;
  }
}
