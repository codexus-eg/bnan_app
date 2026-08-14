class NotificationPreferences {
  const NotificationPreferences({
    required this.categories,
    required this.channels,
    required this.language,
  });
  final Map<String, bool> categories, channels;
  final String language;

  factory NotificationPreferences.fromJson(dynamic response) {
    final root = response is Map
        ? Map<String, dynamic>.from(response)
        : <String, dynamic>{};
    final data = root['data'] is Map
        ? Map<String, dynamic>.from(root['data'])
        : root;
    return NotificationPreferences(
      categories: _boolMap(data['categories']),
      channels: _boolMap(data['channels']),
      language: data['language']?.toString() ?? 'ar',
    );
  }

  NotificationPreferences update(String group, String key, bool value) =>
      NotificationPreferences(
        categories: {...categories, if (group == 'categories') key: value},
        channels: {...channels, if (group == 'channels') key: value},
        language: language,
      );

  Map<String, dynamic> toJson() => {
    'categories': categories,
    'channels': channels,
    'language': language,
  };
}

Map<String, bool> _boolMap(dynamic value) => value is Map
    ? value.map((key, value) => MapEntry(key.toString(), value == true))
    : {};
