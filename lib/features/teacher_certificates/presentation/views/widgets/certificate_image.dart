import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CertificateImage extends StatelessWidget {
  const CertificateImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: Image.asset(
        imageUrl,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * (198 / 812),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 198,
            alignment: Alignment.center,
            color: ColorManager.greyF8F9,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}
