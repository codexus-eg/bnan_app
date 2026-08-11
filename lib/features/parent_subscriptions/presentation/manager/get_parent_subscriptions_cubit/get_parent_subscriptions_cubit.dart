import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_error_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class GetParentSubscriptionsCubit extends Cubit<GetParentSubscriptionsState> {
  GetParentSubscriptionsCubit(this.repo)
    : super(const GetParentSubscriptionsInitial());
  final ParentSubscriptionsRepo repo;

  Future<void> load() async {
    final previous = state is GetParentSubscriptionsSuccess
        ? (state as GetParentSubscriptionsSuccess).selectedChildId
        : null;
    emit(const GetParentSubscriptionsLoading());
    final result = await repo.getSubscriptions();
    if (isClosed) return;
    result.fold(
      (failure) {
        _log('final state emitted: failure');
        emit(
          GetParentSubscriptionsFailure(
            mapParentFlowFailure(failure, fallback: S.current.errorUnknown),
          ),
        );
      },
      (response) {
        final firstSubscribed = response.children
            .where((child) => child.subscriptions.isNotEmpty)
            .firstOrNull;
        final selected =
            response.children.any((item) => item.studentId == previous)
            ? previous
            : firstSubscribed?.studentId ??
                  response.children.firstOrNull?.studentId;
        final count = response.children.fold<int>(
          0,
          (total, child) => total + child.subscriptions.length,
        );
        _log('final state emitted: success; subscriptions=$count');
        emit(
          GetParentSubscriptionsSuccess(
            response.children,
            selectedChildId: selected,
          ),
        );
      },
    );
  }

  void selectChild(String id) {
    final current = state;
    if (current is! GetParentSubscriptionsSuccess ||
        !current.children.any((item) => item.studentId == id)) {
      return;
    }
    emit(GetParentSubscriptionsSuccess(current.children, selectedChildId: id));
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[ParentSubscriptionsCubit] $message');
  }
}
