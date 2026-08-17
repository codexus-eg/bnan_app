import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/connectivity/connectivity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  factory ConnectivityCubit({
    Future<bool> Function()? checkInternet,
    Stream<InternetStatus>? statusChanges,
  }) {
    final connection = InternetConnection();
    return ConnectivityCubit._(
      checkInternet ?? _hasNetworkConnectivity,
      statusChanges ?? connection.onStatusChange,
    );
  }

  static Future<bool> _hasNetworkConnectivity() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        includeLinkLocal: true,
      );
      return interfaces.any((interface) => interface.addresses.isNotEmpty);
    } catch (_) {
      return true;
    }
  }

  ConnectivityCubit._(this._checkInternet, this._statusChanges)
    : super(const ConnectivityChecking());

  final Future<bool> Function() _checkInternet;
  final Stream<InternetStatus> _statusChanges;
  StreamSubscription<InternetStatus>? _subscription;
  Future<void>? _pendingCheck;
  ConnectivityState? _lastConfirmedState;
  bool _checkQueued = false;
  bool _monitoringStarted = false;

  Future<void> startMonitoring() async {
    if (_monitoringStarted) return;
    _monitoringStarted = true;
    _subscription = _statusChanges.listen((_) {
      unawaited(checkConnection(showChecking: false));
    });
    await checkConnection();
  }

  Future<void> checkConnection({bool showChecking = true}) async {
    if (isClosed) return;
    if (showChecking && state is! ConnectivityChecking) {
      emit(const ConnectivityChecking());
    }
    if (_pendingCheck != null) {
      _checkQueued = true;
      return _pendingCheck;
    }
    do {
      _checkQueued = false;
      _pendingCheck = _runCheck();
      await _pendingCheck;
      _pendingCheck = null;
    } while (_checkQueued && !isClosed);
  }

  Future<void> _runCheck() async {
    try {
      final connected = await _checkInternet();
      if (isClosed) return;
      if ((connected && state is ConnectivityConnected) ||
          (!connected && state is ConnectivityDisconnected)) {
        return;
      }
      final confirmed = connected
          ? const ConnectivityConnected()
          : const ConnectivityDisconnected();
      _lastConfirmedState = confirmed;
      emit(confirmed);
    } catch (_) {
      final confirmed = _lastConfirmedState;
      if (!isClosed && confirmed != null && state is ConnectivityChecking) {
        emit(confirmed);
      }
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
