class ChatFormatters {
  const ChatFormatters._();

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '00:00';
    }

    final localDateTime = dateTime.toLocal();

    final hour = localDateTime.hour.toString().padLeft(2, '0');

    final minute = localDateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
