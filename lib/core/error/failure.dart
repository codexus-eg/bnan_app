class Failure {
  final String message;
  final bool responseReceived;
  final int? statusCode;
  final String? code;

  Failure({
    required this.message,
    this.responseReceived = true,
    this.statusCode,
    this.code,
  });

  @override
  String toString() => message;
}
