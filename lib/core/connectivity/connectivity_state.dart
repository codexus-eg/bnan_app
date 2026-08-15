sealed class ConnectivityState {
  const ConnectivityState();
}

final class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial();
}

final class ConnectivityChecking extends ConnectivityState {
  const ConnectivityChecking();
}

final class ConnectivityConnected extends ConnectivityState {
  const ConnectivityConnected();
}

final class ConnectivityDisconnected extends ConnectivityState {
  const ConnectivityDisconnected();
}
