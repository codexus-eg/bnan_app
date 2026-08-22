class AttachmentFile {
  const AttachmentFile({required this.source, required this.name});

  factory AttachmentFile.fromJson(dynamic value) {
    if (value is String) return _fromValues(value, null);
    if (value is! Map) return const AttachmentFile(source: '', name: '');
    final map = Map<String, dynamic>.from(value);
    final source = _first(map, const ['url', 'path', 'location', 'src']);
    final name = _first(map, const [
      'name',
      'fileName',
      'filename',
      'originalName',
      'originalFilename',
    ]);
    return _fromValues(source, name);
  }

  final String source;
  final String name;

  static AttachmentFile _fromValues(String source, String? explicitName) {
    final value = source.trim();
    final requestedName = explicitName?.trim() ?? '';
    if (requestedName.isNotEmpty) {
      return AttachmentFile(source: value, name: _decoded(requestedName));
    }
    final segments = Uri.tryParse(value)?.pathSegments;
    final inferred = segments?.isNotEmpty == true ? segments!.last : '';
    return AttachmentFile(source: value, name: inferred);
  }

  static String _decoded(String value) {
    try {
      return Uri.decodeComponent(value);
    } on FormatException {
      return value;
    }
  }

  static String _first(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }
}
