import 'package:bnan_app/core/helper/file_url_launcher.dart';

class NotificationTextSpanPart {
  const NotificationTextSpanPart({
    required this.text,
    this.isUrl = false,
  });

  final String text;
  final bool isUrl;
}

class NotificationUrlParser {
  const NotificationUrlParser._();

  static final RegExp _rawUrlRegex = RegExp(
    r'https?:\/\/[^\s]+',
    caseSensitive: false,
  );

  static final RegExp _trailingPunctuationRegex = RegExp(
    r'[\.,،؛؟!?:;)"\]}>«»”’]+$',
  );

  static List<NotificationTextSpanPart> parse(String text) {
    if (text.isEmpty) return const [];
    final matches = _rawUrlRegex.allMatches(text);
    if (matches.isEmpty) {
      return [NotificationTextSpanPart(text: text)];
    }

    final parts = <NotificationTextSpanPart>[];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        parts.add(NotificationTextSpanPart(
          text: text.substring(currentIndex, match.start),
        ));
      }

      var rawUrl = match.group(0)!;
      var trailing = '';

      while (rawUrl.isNotEmpty) {
        final punctMatch = _trailingPunctuationRegex.firstMatch(rawUrl);
        if (punctMatch == null) break;

        final char = punctMatch.group(0)!;
        if (char == ')' && _hasBalancedParens(rawUrl)) break;

        trailing = char + trailing;
        rawUrl = rawUrl.substring(0, rawUrl.length - char.length);
      }

      if (FileUrlLauncher.isValidWebUrl(rawUrl)) {
        parts.add(NotificationTextSpanPart(text: rawUrl, isUrl: true));
        if (trailing.isNotEmpty) {
          parts.add(NotificationTextSpanPart(text: trailing));
        }
      } else {
        parts.add(NotificationTextSpanPart(text: match.group(0)!));
      }

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      parts.add(NotificationTextSpanPart(text: text.substring(currentIndex)));
    }

    return parts;
  }

  static bool _hasBalancedParens(String url) {
    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < url.length; i++) {
      if (url[i] == '(') openCount++;
      if (url[i] == ')') closeCount++;
    }
    return openCount == closeCount;
  }
}
