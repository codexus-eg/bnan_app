import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: MediaQuery.of(context).size.height * (175 / 812),
            color: ColorManager.greyF8F9,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}
