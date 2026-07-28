import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart'
    as registration_models;
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_state.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_empty.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_failure.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationRequestsBlocBuilder extends StatelessWidget {
  const RegistrationRequestsBlocBuilder({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetRegistrationRequestsCubit,
      GetRegistrationRequestsState
    >(
      builder: (context, state) {
        final cubit = context.read<GetRegistrationRequestsCubit>();
        Future<void> refresh() => cubit.getRegistrationRequests(refresh: true);

        if (state is GetRegistrationRequestsFailure) {
          return RegistrationRequestsFailure(
            message: state.errorMessage,
            onRetry: refresh,
          );
        }

        final isLoading =
            state is GetRegistrationRequestsInitial ||
            state is GetRegistrationRequestsLoading;
        if (isLoading) {
          return AppSkeletonizer(
            isLoading: true,
            child: RegistrationRequestsList(
              controller: controller,
              requests: registration_models.requests.take(3).toList(),
              onRefresh: refresh,
            ),
          );
        }

        final currentRequests = _requestsFrom(state);
        if (currentRequests.isEmpty) {
          return RegistrationRequestsEmpty(onRefresh: refresh);
        }

        return RegistrationRequestsList(
          controller: controller,
          requests: currentRequests,
          onRefresh: refresh,
          isLoadingMore: state is GetRegistrationRequestsLoadingMore,
          loadMoreError: state is GetRegistrationRequestsLoadMoreFailure
              ? state.errorMessage
              : null,
          onRetryLoadMore: cubit.loadMore,
        );
      },
    );
  }

  List<registration_models.RegistrationRequestModel> _requestsFrom(
    GetRegistrationRequestsState state,
  ) {
    if (state is GetRegistrationRequestsSuccess) return state.requests;
    if (state is GetRegistrationRequestsLoadingMore) return state.requests;
    if (state is GetRegistrationRequestsLoadMoreFailure) {
      return state.requests;
    }
    return const [];
  }
}
