part of 'chat_messages_list.dart';

class _ChatMessagesScrollController {
  static const _nearBottomThreshold = 100.0;
  static const _animationDuration = Duration(milliseconds: 220);

  _ChatMessagesScrollController({this.onInitialPositioned}) {
    controller.addListener(_markReadAtBottom);
  }

  final VoidCallback? onInitialPositioned;
  final controller = ScrollController();
  bool _initialPositioned = false;
  bool _disposed = false;

  void initialize(bool isLoading, List<ChatMessageModel> messages) {
    if (!isLoading) _positionInitially(messages);
  }

  void claimInitialPosition() => _initialPositioned = true;

  void update({
    required bool wasLoading,
    required bool isLoading,
    required List<ChatMessageModel> oldMessages,
    required List<ChatMessageModel> newMessages,
  }) {
    if (isLoading) return;
    if (!_initialPositioned) {
      _positionInitially(newMessages);
      return;
    }
    if (wasLoading || !_hasNewLastMessage(oldMessages, newMessages)) return;

    final shouldScroll = oldMessages.isEmpty || _isNearBottom;
    if (shouldScroll) _scheduleScroll(animated: true);
  }

  void _positionInitially(List<ChatMessageModel> messages) {
    _initialPositioned = true;
    if (messages.isNotEmpty) _scheduleScroll(animated: false);
  }

  bool _hasNewLastMessage(
    List<ChatMessageModel> oldMessages,
    List<ChatMessageModel> newMessages,
  ) {
    if (newMessages.isEmpty) return false;
    if (newMessages.length > oldMessages.length) return true;
    final newLastId = newMessages.last.id;
    if (oldMessages.isEmpty) return true;
    if (newLastId == oldMessages.last.id) return false;
    return !oldMessages.any((message) => message.id == newLastId);
  }

  bool get _isNearBottom {
    if (!controller.hasClients) return true;
    return controller.position.maxScrollExtent - controller.offset <=
        _nearBottomThreshold;
  }

  void _markReadAtBottom() {
    if (_initialPositioned && _isNearBottom) onInitialPositioned?.call();
  }

  void _scheduleScroll({required bool animated}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_disposed || !controller.hasClients) return;
      final target = controller.position.maxScrollExtent;
      if (animated) {
        controller.animateTo(
          target,
          duration: _animationDuration,
          curve: Curves.easeOut,
        );
      } else {
        controller.jumpTo(target);
      }
      if (!animated) onInitialPositioned?.call();
    });
  }

  void dispose() {
    _disposed = true;
    controller.dispose();
  }
}
