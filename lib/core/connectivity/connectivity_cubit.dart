import 'dart:async';

import 'package:bnan_app/core/connectivity/connectivity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(const ConnectivityInitial());

  StreamSubscription<InternetStatus>? _subscription;
  Future<void>? _pendingCheck;
  bool _completedInitialCheck = false;

  Future<void> startMonitoring() async {
    await _subscription?.cancel();
    _completedInitialCheck = false;
    _subscription = InternetConnection().onStatusChange.listen(_setStatus);
    await checkConnection();
  }

  Future<void> checkConnection() {
    return _pendingCheck ??= _runCheck().whenComplete(() {
      _pendingCheck = null;
    });
  }

  Future<void> _runCheck() async {
    if (!isClosed) emit(const ConnectivityChecking());
    var connected = false;
    try {
      connected = await InternetConnection().hasInternetAccess;
    } catch (_) {
      connected = false;
    }
    if (!isClosed) {
      _completedInitialCheck = true;
      emit(
        connected
            ? const ConnectivityConnected()
            : const ConnectivityDisconnected(),
      );
    }
  }

  void _setStatus(InternetStatus status) {
    if (isClosed || !_completedInitialCheck || state is ConnectivityChecking) {
      return;
    }
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
