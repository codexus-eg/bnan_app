import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubscriptionsCubit extends Cubit<StudentSubscriptionsState> {
  StudentSubscriptionsCubit(this.repo)
    : super(const StudentSubscriptionsLoading());
  final StudentSubscriptionsRepo repo;
  bool _loading = false;

  Future<void> load() async {
    if (_loading || isClosed) return;
    _loading = true;
    emit(const StudentSubscriptionsLoading());
    final result = await repo.getSubscriptions();
    if (isClosed) {
      _loading = false;
      return;
    }
    result.fold(
      (failure) => emit(StudentSubscriptionsFailure(failure.message)),
      (student) => emit(StudentSubscriptionsSuccess(student)),
    );
    _loading = false;
  }
}
