import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:padding?? const EdgeInsetsDirectional.all(8),
      margin: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.2, 1.0],
          colors: [
            ColorManager.mainColor14.withAlpha((255 * .8).round()),
            ColorManager.mainColor14,
          ],
        ),
      ),
      child: child,
    );
  }
}
