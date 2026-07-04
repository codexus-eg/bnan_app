import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteIconButton extends StatelessWidget {
  const DeleteIconButton({super.key, required this.onTap, this.size = 22});

  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(4),
        child: SvgPicture.asset(
          ImageManager.trash,
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            ColorManager.redD8,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
