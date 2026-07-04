import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.image,
    required this.title,
    this.width = 170,
    this.imageHeight = 150,
  });

  final String image;
  final String title;
  final double width;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: imageHeight, fit: BoxFit.contain),
            const SizedBox(height: 30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold20(
                context,
              ).copyWith(color: ColorManager.grey7D7D),
            ),
          ],
        ),
      ),
    );
  }
}
