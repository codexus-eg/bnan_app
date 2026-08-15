import 'dart:async';

import 'package:bnan_app/core/connectivity/connectivity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(const ConnectivityState());

  StreamSubscription<InternetStatus>? _subscription;
  Future<void>? _pendingCheck;

  Future<void> startMonitoring() async {
    await _subscription?.cancel();
    _subscription = InternetConnection().onStatusChange.listen(_setStatus);
    await checkConnection();
  }

  Future<void> checkConnection() {
    return _pendingCheck ??= _runCheck().whenComplete(() {
      _pendingCheck = null;
    });
  }

  Future<void> _runCheck() async {
    if (!isClosed) emit(state.copyWith(isChecking: true));
    var connected = false;
    try {
      connected = await InternetConnection().hasInternetAccess;
    } catch (_) {
      connected = false;
    }
    if (!isClosed) {
      emit(ConnectivityState(isConnected: connected));
    }
  }

  void _setStatus(InternetStatus status) {
    if (isClosed) return;
    final connected = status == InternetStatus.connected;
    if (state.isConnected == connected && !state.isChecking) return;
    emit(ConnectivityState(isConnected: connected));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
