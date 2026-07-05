import 'package:bnan_app/features/users_management/data/models/user_model.dart';
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
  int usersCount = 0;
  UserItem? selectedUser;
  String selectedRole = 'student';

  Future<void> getUsers({bool emitLoading = true}) async {
    if (emitLoading) emit(const GetUsersLoading());

    final result = await usersManagementRepo.getUsers();
    result.fold(
      (failure) => emit(GetUsersFailure(failure.message)),
      (response) {
        users = response.data;
        usersCount = response.results;
        emit(GetUsersSuccess(users: users, usersCount: usersCount));
      },
    );
  }

  Future<void> getUserDetails({required String userId}) async {
    emit(const GetUserDetailsLoading());

    final result = await usersManagementRepo.getUserDetails(userId: userId);
    result.fold(
      (failure) => emit(GetUserDetailsFailure(failure.message)),
      (response) {
        selectedUser = response.user;
        emit(GetUserDetailsSuccess(user: selectedUser));
      },
    );
  }

  void prepareAdd() {
    selectedUser = null;
    selectedRole = 'student';
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
  }) async {
    if (formKey.currentState?.validate() != true) return;
    if (selectedRole.trim().isEmpty) return;

    emit(const UsersActionLoading(action: UsersManagementAction.create));
    final result = await usersManagementRepo.createUser(
      user: _withRole(user, selectedRole),
      password: password,
    );

    await result.fold(
      (failure) async => emit(
        UsersActionFailure(
          action: UsersManagementAction.create,
          message: failure.message,
        ),
      ),
      (_) async {
        emit(const UsersActionSuccess(action: UsersManagementAction.create));
        await getUsers(emitLoading: false);
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
      (_) async {
        emit(const UsersActionSuccess(action: UsersManagementAction.update));
        await getUsers(emitLoading: false);
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
        await getUsers(emitLoading: false);
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
      (_) async {
        emit(const UsersActionSuccess(action: UsersManagementAction.status));
        await getUsers(emitLoading: false);
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
        emit(const UsersActionSuccess(action: UsersManagementAction.delete));
        await getUsers(emitLoading: false);
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
}
