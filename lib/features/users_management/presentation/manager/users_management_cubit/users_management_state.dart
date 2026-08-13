part of 'users_management_cubit.dart';

abstract class UsersManagementState {
  const UsersManagementState();
}

class UsersManagementInitial extends UsersManagementState {
  const UsersManagementInitial();
}

enum UsersManagementAction { create, update, password, status, delete }

class UsersActionIdle extends UsersManagementState {
  const UsersActionIdle({required this.action});

  final UsersManagementAction action;
}

class GetUsersLoading extends UsersManagementState {
  const GetUsersLoading();
}

class GetUsersSuccess extends UsersManagementState {
  const GetUsersSuccess({
    required this.users,
    required this.usersCount,
    required this.canLoadMore,
    required this.currentPage,
  });

  final List<UserItem> users;
  final int usersCount;
  final bool canLoadMore;
  final int currentPage;
}

class GetUsersLoadingMore extends UsersManagementState {
  const GetUsersLoadingMore({required this.users});

  final List<UserItem> users;
}

class GetUsersFailure extends UsersManagementState {
  const GetUsersFailure(this.message);

  final String message;
}

class GetUsersLoadMoreFailure extends UsersManagementState {
  const GetUsersLoadMoreFailure({required this.users, required this.message});

  final List<UserItem> users;
  final String message;
}

class GetUserDetailsLoading extends UsersManagementState {
  const GetUserDetailsLoading();
}

class GetUserDetailsSuccess extends UsersManagementState {
  const GetUserDetailsSuccess({required this.user});

  final UserItem? user;
}

class GetUserDetailsFailure extends UsersManagementState {
  const GetUserDetailsFailure(this.message);

  final String message;
}

class UsersActionLoading extends UsersManagementState {
  const UsersActionLoading({required this.action});

  final UsersManagementAction action;
}

class UsersActionSuccess extends UsersManagementState {
  const UsersActionSuccess({required this.action});

  final UsersManagementAction action;
}

class UsersActionFailure extends UsersManagementState {
  const UsersActionFailure({required this.action, required this.message});

  final UsersManagementAction action;
  final String message;
}
