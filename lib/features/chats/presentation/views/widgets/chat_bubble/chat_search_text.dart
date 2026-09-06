import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class ChatSearchText extends StatelessWidget {
  const ChatSearchText({
    super.key,
    required this.text,
    required this.query,
    required this.style,
  });
  final String text;
  final String query;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(
        text,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: style,
      );
    }
    final matches = RegExp(
      RegExp.escape(query.trim()),
      caseSensitive: false,
      unicode: true,
    ).allMatches(text);
    final spans = <TextSpan>[];
    var end = 0;
    for (final match in matches) {
      spans.add(TextSpan(text: text.substring(end, match.start)));
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: const TextStyle(
            backgroundColor: ColorManager.orangeE6,
            color: ColorManager.black,
          ),
        ),
      );
      end = match.end;
    }
    spans.add(TextSpan(text: text.substring(end)));
    return Text.rich(
      TextSpan(children: spans),
      style: style,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
