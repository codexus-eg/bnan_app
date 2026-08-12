class SimpleResponseModel {
  const SimpleResponseModel({
    required this.success,
    required this.message,
    this.status,
    this.token = '',
    this.refreshToken = '',
  });

  final bool success;
  final String message;
  final String? status;
  final String token;
  final String refreshToken;

  factory SimpleResponseModel.fromJson(Map<String, dynamic> json) {
    return SimpleResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      status: json['status']?.toString(),
      token: (json['token'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
    );
  }

  bool get isError => status == 'error';
  bool get hasTokenPair => token.isNotEmpty && refreshToken.isNotEmpty;
}
