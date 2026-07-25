import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PackageAdminActions extends StatelessWidget {
  const PackageAdminActions({
    super.key,
    required this.plan,
    required this.onDelete,
    required this.onEdit,
  });

  final PackageCardModel plan;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onEdit,
          child: SvgPicture.asset(
            ImageManager.usersManagementEditIcon,
            colorFilter: ColorFilter.mode(ColorManager.greyA8AF, BlendMode.srcIn),
            height: 16,
            width: 16,
          ),
        ),

        const SizedBox(width: 8),
        InkWell(
          onTap: onDelete,
          child: SvgPicture.asset(
            ImageManager.trash,
            colorFilter: ColorFilter.mode(ColorManager.redBA, BlendMode.srcIn),
            height: 16,
            width: 16,
          ),
        ),
      ],
    );
  }
}
