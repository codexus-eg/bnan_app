import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubscriptionsCubit extends Cubit<StudentSubscriptionsState> {
  StudentSubscriptionsCubit(this.repo)
    : super(const StudentSubscriptionsLoading());
  final StudentSubscriptionsRepo repo;
  bool _loading = false;
  final Set<String> _locallyPendingRenewals = {};

  bool isRenewalPending(String subscriptionId) =>
      _locallyPendingRenewals.contains(subscriptionId);

  void markRenewalPending(String subscriptionId) {
    final current = state;
    if (current is! StudentSubscriptionsSuccess ||
        !current.student.subscriptions.any(
          (item) => item.id == subscriptionId,
        ) ||
        !_locallyPendingRenewals.add(subscriptionId)) {
      return;
    }
    emit(StudentSubscriptionsSuccess(current.student));
  }

  Future<void> load() => _load(homeOnly: false);
  Future<void> loadHome() => _load(homeOnly: true);

  Future<void> _load({required bool homeOnly}) async {
    if (_loading || isClosed) return;
    _loading = true;
    if (state is! StudentSubscriptionsSuccess) {
      emit(const StudentSubscriptionsLoading());
    }
    try {
      final result = homeOnly
          ? await repo.getHomeSubscriptions()
          : await repo.getSubscriptions();
      if (isClosed) return;
      result.fold(
        (failure) => emit(StudentSubscriptionsFailure(failure.message)),
        (student) {
          for (final subscription in student.subscriptions) {
            if (subscription.hasPendingRenewal) {
              _locallyPendingRenewals.remove(subscription.id);
            }
          }
          emit(StudentSubscriptionsSuccess(student));
        },
      );
    } finally {
      _loading = false;
    }
  }
}
