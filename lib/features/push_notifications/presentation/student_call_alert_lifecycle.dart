import 'dart:async';

enum StudentCallAlertStatus { ringing, rejected, noAnswer }

class StudentCallAlertLifecycle {
  StudentCallAlertLifecycle({this.duration = const Duration(seconds: 60)});

  final Duration duration;
  Timer? _timer;
  String? _activeCallId;
  String? _finishedCallId;
  StudentCallAlertStatus? _status;

  StudentCallAlertStatus? get status => _status;
  String? get activeCallId => _activeCallId;

  bool start(String callId, Future<void> Function() onTimeout) {
    if (_status == StudentCallAlertStatus.ringing) return false;
    final normalizedId = callId.trim();
    if (normalizedId.isNotEmpty && normalizedId == _finishedCallId) {
      return false;
    }
    _activeCallId = normalizedId.isEmpty ? null : normalizedId;
    _status = StudentCallAlertStatus.ringing;
    _timer = Timer(duration, () {
      _activeCallId = null;
      _finishedCallId = normalizedId.isEmpty ? null : normalizedId;
      _status = StudentCallAlertStatus.noAnswer;
      unawaited(onTimeout());
    });
    return true;
  }

  void reject() {
    _finish(StudentCallAlertStatus.rejected);
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _activeCallId = null;
    _finishedCallId = null;
    _status = null;
  }

  void _finish(StudentCallAlertStatus status) {
    _finishedCallId = _activeCallId;
    _timer?.cancel();
    _timer = null;
    _activeCallId = null;
    _status = status;
  }
}
