import 'dart:io';

import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurriculumImagePickerField extends StatelessWidget {
  const CurriculumImagePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.onTap,
    this.file,
    this.currentImageUrl,
  });

  final String label;
  final String hint;
  final File? file;
  final String? currentImageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fileName = file?.path.split(Platform.pathSeparator).last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor15),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _CurriculumIconPreview(file: file, url: currentImageUrl),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName ?? hint,
                    style: StylesManager.styleRegular16(context).copyWith(
                      color: fileName == null
                          ? ColorManager.greyA8AF
                          : ColorManager.mainColor15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CurriculumIconPreview extends StatelessWidget {
  const _CurriculumIconPreview({this.file, this.url});

  final File? file;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final image = file != null
        ? Image.file(file!, fit: BoxFit.cover)
        : url?.trim().isNotEmpty == true
        ? Image.network(url!, fit: BoxFit.cover, errorBuilder: _errorBuilder)
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(width: 32, height: 32, child: image ?? _fallback()),
    );
  }

  Widget _errorBuilder(BuildContext _, Object __, StackTrace? ___) =>
      _fallback();

  Widget _fallback() => Padding(
    padding: const EdgeInsets.all(6),
    child: SvgPicture.asset(
      ImageManager.upload,
      colorFilter: const ColorFilter.mode(
        ColorManager.greyA8AF,
        BlendMode.srcIn,
      ),
    ),
  );
}
