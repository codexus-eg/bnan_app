import 'dart:async';

import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_actions.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_failure.dart';
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
  final scrollController = ScrollController();
  Timer? _searchDebounce;
  String selectedRoleFilter = 'all';

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController
      ..removeListener(_loadMore)
      ..dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<UsersManagementCubit>().applyFilters(
        search: searchController.text,
        role: selectedRoleFilter,
      );
    });
  }

  void _loadMore() {
    if (!mounted || !scrollController.hasClients) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      context.read<UsersManagementCubit>().loadMore();
    }
  }

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
            final firstPageFailure =
                state is GetUsersFailure && cubit.users.isEmpty;

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
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 4),
                          UsersRoleFilter(
                            selectedRole: selectedRoleFilter,
                            onChanged: (role) {
                              setState(() => selectedRoleFilter = role);
                              cubit.applyFilters(
                                search: searchController.text,
                                role: role,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: firstPageFailure
                      ? UsersManagementFailure(
                          message: state.message,
                          onRetry: () => cubit.refreshUsers(emitLoading: true),
                        )
                      : UsersManagementList(
                          controller: scrollController,
                          onRefresh: cubit.refreshUsers,
                          isLoading: isLoading,
                          users: cubit.users,
                          showEmpty: !isLoading && cubit.users.isEmpty,
                          isLoadingMore: state is GetUsersLoadingMore,
                          loadMoreError: state is GetUsersLoadMoreFailure
                              ? state.message
                              : null,
                          onRetryLoadMore: cubit.loadMore,
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
    } else if (state is UsersActionFailure &&
        state.action != UsersManagementAction.create) {
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
}
