import 'dart:async';

import 'package:bnan_app/core/connectivity/connectivity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(const ConnectivityConnected());

  final InternetConnection _connection = InternetConnection();
  StreamSubscription<InternetStatus>? _subscription;
  Future<void>? _pendingCheck;
  bool _completedInitialCheck = false;
  bool _monitoringStarted = false;

  Future<void> startMonitoring() async {
    if (_monitoringStarted) return;
    _monitoringStarted = true;
    _completedInitialCheck = false;
    await checkConnection();
    if (isClosed) return;
    _subscription = _connection.onStatusChange.listen(_setStatus);
  }

  Future<void> checkConnection() {
    return _pendingCheck ??= _runCheck().whenComplete(() {
      _pendingCheck = null;
    });
  }

  Future<void> _runCheck() async {
    try {
      final connected = await _connection.hasInternetAccess;
      if (isClosed) return;
      _completedInitialCheck = true;
      if ((connected && state is ConnectivityConnected) ||
          (!connected && state is ConnectivityDisconnected)) {
        return;
      }
      emit(
        connected
            ? const ConnectivityConnected()
            : const ConnectivityDisconnected(),
      );
    } catch (_) {
      _completedInitialCheck = true;
    }
  }

  void _setStatus(InternetStatus status) {
    if (isClosed || !_completedInitialCheck) return;
    final connected = status == InternetStatus.connected;
    if ((connected && state is ConnectivityConnected) ||
        (!connected && state is ConnectivityDisconnected)) {
      return;
    }
    emit(
      connected
          ? const ConnectivityConnected()
          : const ConnectivityDisconnected(),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
