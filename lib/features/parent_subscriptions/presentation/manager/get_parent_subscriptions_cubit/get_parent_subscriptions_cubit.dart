import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_error_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/diagnostics/gulf_renewal_trace.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class GetParentSubscriptionsCubit extends Cubit<GetParentSubscriptionsState> {
  GetParentSubscriptionsCubit(this.repo)
    : super(const GetParentSubscriptionsInitial());
  final ParentSubscriptionsRepo repo;
  bool _loading = false;
  final Set<String> _locallyPendingRenewals = {};

  bool isRenewalPending(String studentId, String subscriptionId) =>
      _locallyPendingRenewals.contains('$studentId:$subscriptionId');

  void markRenewalPending(String studentId, String subscriptionId) {
    final current = state;
    if (current is! GetParentSubscriptionsSuccess ||
        !current.children.any(
          (child) =>
              child.studentId == studentId &&
              child.subscriptions.any((item) => item.id == subscriptionId),
        ) ||
        !_locallyPendingRenewals.add('$studentId:$subscriptionId')) {
      return;
    }
    emit(
      GetParentSubscriptionsSuccess(
        current.children,
        selectedChildId: current.selectedChildId,
      ),
    );
  }

  Future<void> load() async {
    if (_loading || isClosed) return;
    _loading = true;
    GulfRenewalTrace.log('parent subscription refresh started');
    final previous = state is GetParentSubscriptionsSuccess
        ? (state as GetParentSubscriptionsSuccess).selectedChildId
        : null;
    if (state is! GetParentSubscriptionsSuccess) {
      emit(const GetParentSubscriptionsLoading());
    }
    try {
      final result = await repo.getSubscriptions();
      if (isClosed) return;
      result.fold((failure) {
        if (isClosed) return;
        _log('final state emitted: failure');
        emit(
          GetParentSubscriptionsFailure(
            mapParentFlowFailure(failure, fallback: S.current.errorUnknown),
          ),
        );
      }, (response) => _emitSuccess(response, previous));
    } finally {
      _loading = false;
      GulfRenewalTrace.log('parent subscription refresh finished');
    }
  }

  void _emitSuccess(ParentSubscriptionsResponse response, String? previous) {
    if (isClosed) return;
    for (final child in response.children) {
      for (final subscription in child.subscriptions) {
        if (subscription.hasPendingRenewal) {
          _locallyPendingRenewals.remove(
            '${child.studentId}:${subscription.id}',
          );
        }
      }
    }
    final firstSubscribed = response.children
        .where((child) => child.subscriptions.isNotEmpty)
        .firstOrNull;
    final selected = response.children.any((item) => item.studentId == previous)
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
