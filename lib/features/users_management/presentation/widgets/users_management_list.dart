import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/user_card.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_list_footer.dart';
import 'package:flutter/material.dart';

class UsersManagementList extends StatelessWidget {
  const UsersManagementList({
    super.key,
    required this.isLoading,
    required this.users,
    required this.showEmpty,
    required this.controller,
    required this.onRefresh,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.onRetryLoadMore,
  });

  final bool isLoading;
  final List<UserItem> users;
  final bool showEmpty;
  final ScrollController controller;
  final Future<void> Function() onRefresh;
  final bool isLoadingMore;
  final String? loadMoreError;
  final Future<void> Function()? onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    if (showEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: const NoDataWidget(),
              ),
            ],
          ),
        ),
      );
    }

    final visibleUsers = isLoading && users.isEmpty
        ? usersManagementSkeletonMock
        : users;
    final hasFooter = isLoadingMore || loadMoreError != null;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: AppSkeletonizer(
        isLoading: isLoading,
        child: ListView.separated(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
          itemBuilder: (context, index) {
            if (index == visibleUsers.length) {
              return UsersManagementListFooter(
                isLoading: isLoadingMore,
                errorMessage: loadMoreError,
                onRetry: onRetryLoadMore,
              );
            }
            return UserCard(user: visibleUsers[index]);
          },
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemCount: visibleUsers.length + (hasFooter ? 1 : 0),
        ),
      ),
    );
  }
}
