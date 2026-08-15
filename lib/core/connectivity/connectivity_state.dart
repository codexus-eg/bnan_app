class ConnectivityState {
  const ConnectivityState({this.isConnected = true, this.isChecking = false});

  final bool isConnected;
  final bool isChecking;

  ConnectivityState copyWith({bool? isConnected, bool? isChecking}) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}
