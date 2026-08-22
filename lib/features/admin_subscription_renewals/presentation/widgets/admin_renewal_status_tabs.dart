import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_labels.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminRenewalStatusTabs extends StatelessWidget {
  const AdminRenewalStatusTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final AdminRenewalStatus selected;
  final ValueChanged<AdminRenewalStatus> onChanged;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
    child: Row(
      children: AdminRenewalStatus.values.map((status) {
        final active = status == selected;
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => onChanged(status),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: active
                    ? ColorManager.mainColor14
                    : ColorManager.greyF8F9,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                adminRenewalStatusLabel(S.of(context), status),
                style: StylesManager.styleBold12(context).copyWith(
                  color: active ? ColorManager.white : ColorManager.mainColor14,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
