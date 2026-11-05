import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassroomKindToggle extends StatelessWidget {
  const AddClassroomKindToggle({super.key, required this.isShared, required this.onChanged});
  final bool isShared;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        Expanded(child: _btn(context, s.standardClassroom, !isShared, () => onChanged(false))),
        const SizedBox(width: 8),
        Expanded(child: _btn(context, s.sharedClassroom, isShared, () => onChanged(true))),
      ],
    );
  }

  Widget _btn(BuildContext ctx, String text, bool sel, VoidCallback tap) => InkWell(
    onTap: tap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: sel ? ColorManager.blue3A : ColorManager.greyD9D9.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: sel ? ColorManager.blue3A : ColorManager.greyD9D9),
      ),
      child: Text(text, style: StylesManager.styleBold12(ctx).copyWith(color: sel ? ColorManager.white : ColorManager.mainColor14)),
    ),
  );
}
