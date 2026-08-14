import 'dart:convert';

class NotificationNavigation {
  const NotificationNavigation({
    this.screen,
    this.target,
    this.params = const {},
  });

  final String? screen;
  final String? target;
  final Map<String, dynamic> params;

  factory NotificationNavigation.fromJson(dynamic value) {
    final json = value is Map
        ? Map<String, dynamic>.from(value)
        : <String, dynamic>{};
    return NotificationNavigation(
      screen: _text(json['screen']),
      target: _text(json['target']),
      params: decodeParams(json['params']),
    );
  }

  static Map<String, dynamic> decodeParams(dynamic value) {
    try {
      final decoded = value is String ? jsonDecode(value) : value;
      return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
    } catch (_) {
      return {};
    }
  }
}

String? _text(dynamic value) {
  final text = value?.toString().trim();
  return text?.isNotEmpty == true ? text : null;
}
