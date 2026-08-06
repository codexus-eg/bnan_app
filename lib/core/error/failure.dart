class Failure {
  final String message;
  final bool responseReceived;
  final int? statusCode;

  Failure({
    required this.message,
    this.responseReceived = true,
    this.statusCode,
  });

  @override
  String toString() => message;
}
