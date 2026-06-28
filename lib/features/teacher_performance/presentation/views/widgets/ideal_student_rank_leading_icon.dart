import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IdealStudentRankLeadingIcon extends StatelessWidget {
  const IdealStudentRankLeadingIcon({super.key, required this.isFirst});

  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    if (!isFirst) return const SizedBox(width: 18);

    return SvgPicture.asset(
      ImageManager.crownSimple,
      height: 20,
      width: 20,
      fit: BoxFit.contain,
    );
  }
}
