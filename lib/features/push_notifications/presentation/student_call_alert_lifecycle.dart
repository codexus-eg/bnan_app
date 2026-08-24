import 'dart:async';

enum StudentCallAlertStatus { ringing, rejected, noAnswer }

class StudentCallAlertLifecycle {
  StudentCallAlertLifecycle({this.duration = const Duration(seconds: 15)});

  final Duration duration;
  Timer? _timer;
  String? _activeCallId;
  StudentCallAlertStatus? _status;

  StudentCallAlertStatus? get status => _status;
  String? get activeCallId => _activeCallId;

  bool start(String callId, Future<void> Function() onTimeout) {
    if (_status == StudentCallAlertStatus.ringing) return false;
    _activeCallId = callId.trim().isEmpty ? null : callId.trim();
    _status = StudentCallAlertStatus.ringing;
    _timer = Timer(duration, () {
      _activeCallId = null;
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
    _status = null;
  }

  void _finish(StudentCallAlertStatus status) {
    _timer?.cancel();
    _timer = null;
    _activeCallId = null;
    _status = status;
  }
}
