import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_actions.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_search.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_list.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_role_filter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersManagementBody extends StatefulWidget {
  const UsersManagementBody({super.key});

  @override
  State<UsersManagementBody> createState() => _UsersManagementBodyState();
}

class _UsersManagementBodyState extends State<UsersManagementBody> {
  final searchController = TextEditingController();
  String selectedRoleFilter = 'all';

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocListener<UsersManagementCubit, UsersManagementState>(
        listener: _listenToActions,
        child: BlocBuilder<UsersManagementCubit, UsersManagementState>(
          builder: (context, state) {
            final cubit = context.read<UsersManagementCubit>();
            final isLoading = state is GetUsersLoading;
            final users = isLoading ? cubit.users : _filterUsers(cubit.users);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      CustomAppbar(
                        headerText: S.of(context).usersManagement,
                        iconNeeded: false,
                      ),
                      UsersManagementActions(usersCount: cubit.usersCount),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: UsersManagementSearch(
                              controller: searchController,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 4),
                          UsersRoleFilter(
                            selectedRole: selectedRoleFilter,
                            onChanged: (role) {
                              setState(() => selectedRoleFilter = role);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: UsersManagementList(
                    isLoading: isLoading,
                    users: users,
                    showEmpty: !isLoading && users.isEmpty,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _listenToActions(BuildContext context, UsersManagementState state) {
    if (state is UsersActionSuccess) {
      showCustomSnackBar(context, _successMessage(context, state.action), true);
    } else if (state is UsersActionFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }

  String _successMessage(BuildContext context, UsersManagementAction action) {
    final s = S.of(context);
    return switch (action) {
      UsersManagementAction.create => s.userCreatedSuccessfully,
      UsersManagementAction.update => s.userUpdatedSuccessfully,
      UsersManagementAction.password => s.userPasswordUpdatedSuccessfully,
      UsersManagementAction.status => s.userStatusUpdatedSuccessfully,
      UsersManagementAction.delete => s.userDeletedSuccessfully,
    };
  }

  List<UserItem> _filterUsers(List<UserItem> users) {
    final query = searchController.text.trim().toLowerCase();

    return users.where((user) {
      final matchesSearch =
          query.isEmpty ||
          _matches(user.name, query) ||
          _matches(user.email, query) ||
          _matches(user.phone, query) ||
          _matches(user.roles, query) ||
          _matches(user.status, query);
      final matchesRole =
          selectedRoleFilter == 'all' ||
          user.roles.toLowerCase() == selectedRoleFilter;

      return matchesSearch && matchesRole;
    }).toList();
  }

  bool _matches(String value, String query) {
    return value.toLowerCase().contains(query);
  }
}
