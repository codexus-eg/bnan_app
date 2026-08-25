import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class UnreadBadgeDot extends StatelessWidget {
  const UnreadBadgeDot({super.key, required this.child, required this.show});

  final Widget child;
  final bool show;

  @override
  Widget build(BuildContext context) {
    if (!show) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: -2,
          end: -3,
          child: Container(
            key: const Key('unreadBadgeDot'),
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: ColorManager.redD8,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
