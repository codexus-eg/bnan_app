import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/delete_discount_code_dialog.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_code_badges.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_code_form_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscountCodeCard extends StatelessWidget {
  const DiscountCodeCard({super.key, required this.code, this.enabled = true});
  final DiscountCodeModel code;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: Border.all(color: ColorManager.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  code.code,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor15),
                ),
              ),
              _action(ImageManager.usersManagementEditIcon, () {
                showDiscountCodeForm(context, code: code);
              }),
              const SizedBox(width: 12),
              _action(ImageManager.trash, () {
                showDeleteDiscountCodeDialog(context, code.id);
              }, color: ColorManager.redBA),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              DiscountCodeBadge(
                text: '${code.percentage}%',
                color: ColorManager.mainColor14,
              ),
              DiscountCodeBadge(
                text: code.type == DiscountCodeType.dateRange
                    ? s.dateRangeDiscount
                    : s.childrenDiscount,
                color: ColorManager.orangeED,
              ),
              DiscountCodeBadge(
                text: code.isActive ? s.active : s.inactive,
                color: code.isActive
                    ? ColorManager.mainColor14
                    : ColorManager.greyA8AF,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_details(context), style: StylesManager.styleRegular14(context)),
        ],
      ),
    );
  }

  Widget _action(String asset, VoidCallback onTap, {Color? color}) => InkWell(
    onTap: enabled ? onTap : null,
    child: SvgPicture.asset(
      asset,
      width: 18,
      height: 18,
      colorFilter: ColorFilter.mode(
        color ?? ColorManager.greyA8AF,
        BlendMode.srcIn,
      ),
    ),
  );

  String _details(BuildContext context) {
    final s = S.of(context);
    if (code.type == DiscountCodeType.children) {
      return '${s.childrenCount}: ${code.childrenCount ?? '-'}';
    }
    final locale = MaterialLocalizations.of(context);
    final start = code.startsAt == null
        ? '-'
        : locale.formatShortDate(code.startsAt!.toLocal());
    final end = code.endsAt == null
        ? '-'
        : locale.formatShortDate(code.endsAt!.toLocal());
    return '${s.startDate}: $start  •  ${s.endDate}: $end';
  }
}
