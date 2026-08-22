import 'dart:async';

import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback_banner.dart';
import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback_type.dart';
import 'package:flutter/material.dart';

export 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback_type.dart';

class AppTopFeedbackHandle {
  const AppTopFeedbackHandle._(this.id);
  final int id;
}

class AppTopFeedback {
  AppTopFeedback._();

  static const successDuration = Duration(seconds: 3);
  static const messageDuration = Duration(seconds: 4);
  static final List<_PendingFeedback> _queue = [];
  static _ActiveFeedback? _active;
  static int _nextId = 0;

  static AppTopFeedbackHandle show(
    BuildContext context, {
    OverlayState? overlay,
    required AppTopFeedbackType type,
    required String title,
    String? body,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onTap,
    String? dedupKey,
    bool showClose = true,
  }) {
    final handle = AppTopFeedbackHandle._(++_nextId);
    final targetOverlay =
        overlay ?? Overlay.maybeOf(context, rootOverlay: true);
    if (targetOverlay == null) return handle;
    final item = _FeedbackItem(
      handle: handle,
      type: type,
      title: title,
      body: body,
      actionLabel: actionLabel,
      onAction: onAction,
      onTap: onTap,
      dedupKey: dedupKey,
      showClose: showClose,
    );
    if (_active != null &&
        type == AppTopFeedbackType.notification &&
        _active?.item.type != AppTopFeedbackType.notification) {
      _enqueue(targetOverlay, item);
    } else {
      _removeActive();
      _display(targetOverlay, item);
    }
    return handle;
  }

  static void replace(
    BuildContext context,
    AppTopFeedbackHandle handle, {
    required AppTopFeedbackType type,
    required String title,
    String? body,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (_active?.item.handle.id != handle.id) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _removeActive();
    _display(
      overlay,
      _FeedbackItem(
        handle: handle,
        type: type,
        title: title,
        body: body,
        actionLabel: actionLabel,
        onAction: onAction,
        showClose: true,
      ),
    );
  }

  static void dismiss(AppTopFeedbackHandle handle) {
    if (_active?.item.handle.id == handle.id) {
      final state = _active?.key.currentState;
      if (state == null) {
        _finish(handle.id);
      } else {
        unawaited(state.dismiss());
      }
      return;
    }
    _queue.removeWhere((item) => item.item.handle.id == handle.id);
  }

  static void _enqueue(OverlayState overlay, _FeedbackItem item) {
    if (item.dedupKey != null) {
      _queue.removeWhere((value) => value.item.dedupKey == item.dedupKey);
    }
    _queue.add(_PendingFeedback(overlay, item));
    if (_queue.length > 3) _queue.removeAt(0);
  }

  static void _display(OverlayState overlay, _FeedbackItem item) {
    final key = GlobalKey<AppTopFeedbackBannerState>();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => PositionedDirectional(
        top: 0,
        start: 0,
        end: 0,
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: AppTopFeedbackBanner(
            key: key,
            type: item.type,
            title: item.title,
            body: item.body,
            actionLabel: item.actionLabel,
            onAction: item.onAction,
            onTap: item.onTap,
            showClose: item.showClose,
            onDismissed: () => _finish(item.handle.id),
          ),
        ),
      ),
    );
    final duration = _duration(item.type);
    final timer = duration == null
        ? null
        : Timer(duration, () {
            final state = key.currentState;
            if (state == null) {
              _finish(item.handle.id);
            } else {
              unawaited(state.dismiss());
            }
          });
    _active = _ActiveFeedback(item, entry, key, timer);
    overlay.insert(entry);
  }

  static Duration? _duration(AppTopFeedbackType type) => switch (type) {
    AppTopFeedbackType.loading => null,
    AppTopFeedbackType.success => successDuration,
    _ => messageDuration,
  };

  static void _finish(int id) {
    if (_active?.item.handle.id != id) return;
    _removeActive();
    if (_queue.isEmpty) return;
    final next = _queue.removeAt(0);
    if (next.overlay.mounted) _display(next.overlay, next.item);
  }

  static void _removeActive() {
    final active = _active;
    _active = null;
    active?.timer?.cancel();
    if (active?.entry.mounted == true) active!.entry.remove();
  }
}

class _FeedbackItem {
  const _FeedbackItem({
    required this.handle,
    required this.type,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
    this.onTap,
    this.dedupKey,
    required this.showClose,
  });
  final AppTopFeedbackHandle handle;
  final AppTopFeedbackType type;
  final String title;
  final String? body, actionLabel, dedupKey;
  final VoidCallback? onAction, onTap;
  final bool showClose;
}

class _ActiveFeedback {
  const _ActiveFeedback(this.item, this.entry, this.key, this.timer);
  final _FeedbackItem item;
  final OverlayEntry entry;
  final GlobalKey<AppTopFeedbackBannerState> key;
  final Timer? timer;
}

class _PendingFeedback {
  const _PendingFeedback(this.overlay, this.item);
  final OverlayState overlay;
  final _FeedbackItem item;
}
