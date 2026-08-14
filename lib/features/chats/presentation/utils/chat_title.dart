import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

String resolveChatTitle(BuildContext context, String? roomName) {
  final name = roomName?.trim();
  return name?.isNotEmpty == true ? name! : S.of(context).chatTitleFallback;
}
