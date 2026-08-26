class GulfPaymentPollingPolicy {
  const GulfPaymentPollingPolicy();

  static const Duration fastWindow = Duration(seconds: 30);
  static const Duration maxDuration = Duration(minutes: 2);
  static const Duration fastInterval = Duration(seconds: 3);
  static const Duration slowInterval = Duration(seconds: 5);

  Duration? nextDelay(Duration elapsed) {
    if (elapsed >= maxDuration) return null;
    final interval = elapsed < fastWindow ? fastInterval : slowInterval;
    final remaining = maxDuration - elapsed;
    return interval <= remaining ? interval : remaining;
  }
}
