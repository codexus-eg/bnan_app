import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteLessonButton extends StatelessWidget {
  const DeleteLessonButton({super.key, this.onPressed, this.isLoading = false});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final label = S.of(context).delete;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: const Key('deleteLessonIcon'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(12),
            child: Opacity(
              opacity: isLoading ? .5 : 1,
              child: SvgPicture.asset(
                ImageManager.trash,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
