import 'package:bnan_app/features/notifications/data/models/notification_preferences.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesState {
  const PreferencesState({this.value, this.loading = false, this.error});
  final NotificationPreferences? value;
  final bool loading;
  final String? error;
}

class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(this._repo) : super(const PreferencesState());
  final NotificationsRepo _repo;

  Future<void> load() async {
    if (isClosed) return;
    emit(const PreferencesState(loading: true));
    final result = await _repo.getPreferences();
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(PreferencesState(error: failure.message));
      },
      (value) {
        if (isClosed) return;
        emit(PreferencesState(value: value));
      },
    );
  }

  Future<void> update(String group, String key, bool enabled) async {
    if (isClosed) return;
    final current = state.value;
    if (current == null) return;
    final optimistic = current.update(group, key, enabled);
    emit(PreferencesState(value: optimistic, loading: true));
    final result = await _repo.updatePreferences(optimistic);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(PreferencesState(value: current, error: failure.message));
      },
      (value) {
        if (isClosed) return;
        emit(PreferencesState(value: value));
      },
    );
  }
}
