import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class IdealTeacherAvatar extends StatelessWidget {
  const IdealTeacherAvatar({super.key, required this.name, this.url = ''});
  final String name, url;

  @override
  Widget build(BuildContext context) {
    final fallback = CustomAvatar(
      firstName: name,
      radius: 24,
      backgroundColor: ColorManager.blueE3,
    );
    if (url.isEmpty) return fallback;
    return ClipOval(
      child: Image.network(
        url,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
