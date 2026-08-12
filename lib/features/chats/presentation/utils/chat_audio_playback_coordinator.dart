class ChatAudioPlaybackCoordinator {
  Object? _owner;
  Future<void> Function()? _stopCurrent;

  Future<void> activate(
    Object owner,
    Future<void> Function() stopCurrent,
  ) async {
    if (identical(owner, _owner)) return;
    await _stopCurrent?.call();
    _owner = owner;
    _stopCurrent = stopCurrent;
  }

  void release(Object owner) {
    if (!identical(owner, _owner)) return;
    _owner = null;
    _stopCurrent = null;
  }
}

final chatAudioPlaybackCoordinator = ChatAudioPlaybackCoordinator();
