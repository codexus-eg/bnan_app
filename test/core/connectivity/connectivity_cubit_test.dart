import 'dart:async';

import 'package:bnan_app/core/connectivity/connectivity_cubit.dart';
import 'package:bnan_app/core/connectivity/connectivity_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() {
  late StreamController<InternetStatus> changes;
  late List<bool> results;
  late int listeners;
  late ConnectivityCubit cubit;

  setUp(() {
    results = [];
    listeners = 0;
    changes = StreamController<InternetStatus>.broadcast(
      onListen: () => listeners++,
    );
    cubit = ConnectivityCubit(
      checkInternet: () async => results.removeAt(0),
      statusChanges: changes.stream,
    );
  });

  tearDown(() async {
    await cubit.close();
    await changes.close();
  });

  test('starts checking and stays online when internet is reachable', () async {
    expect(cubit.state, isA<ConnectivityChecking>());
    results.add(true);
    await cubit.startMonitoring();
    expect(cubit.state, isA<ConnectivityConnected>());
  });

  test(
    'shows disconnected only after the initial reachability check',
    () async {
      results.add(false);
      await cubit.startMonitoring();
      expect(cubit.state, isA<ConnectivityDisconnected>());
    },
  );

  test(
    'tracks losing and restoring internet without recreating cubit',
    () async {
      results.add(true);
      await cubit.startMonitoring();
      results.add(false);
      final disconnected = cubit.stream.firstWhere(
        (state) => state is ConnectivityDisconnected,
      );
      changes.add(InternetStatus.disconnected);
      await disconnected;
      expect(cubit.state, isA<ConnectivityDisconnected>());
      results.add(true);
      final connected = cubit.stream.firstWhere(
        (state) => state is ConnectivityConnected,
      );
      changes.add(InternetStatus.connected);
      await connected;
      expect(cubit.state, isA<ConnectivityConnected>());
    },
  );

  test('startMonitoring installs only one listener', () async {
    results.add(true);
    await cubit.startMonitoring();
    await cubit.startMonitoring();
    expect(listeners, 1);
  });
}
