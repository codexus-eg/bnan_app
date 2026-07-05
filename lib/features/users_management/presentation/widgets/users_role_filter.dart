import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UsersRoleFilter extends StatelessWidget {
  const UsersRoleFilter({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  final String selectedRole;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showRoles(context),
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        ImageManager.usersManagementFilterIcon,
        height: 24,
        width: 24,
      ),
    );
  }

  void _showRoles(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorManager.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _items(context).entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(sheetContext);
                  onChanged(entry.key);
                },
                child: _roleChip(context, entry.value, entry.key),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _roleChip(BuildContext context, String label, String role) {
    final isSelected = selectedRole == role;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? ColorManager.greyF8F9 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Customship(
        label,
        style: isSelected ? StylesManager.styleBold14(context) : null,
      ),
    );
  }

  Map<String, String> _items(BuildContext context) {
    final s = S.of(context);
    return {
      'all': s.all,
      'student': s.student,
      'teacher': s.teacher,
      'parent': s.parentRole,
      'supervisor': s.supervisor,
    };
  }
}
