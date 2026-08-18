import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/saved_account_store.dart';
import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SavedAccountCard extends StatelessWidget {
  const SavedAccountCard({
    super.key,
    required this.account,
    required this.loading,
    required this.onTap,
    required this.onRemove,
  });
  final SavedAccount account;
  final bool loading;
  final VoidCallback onTap, onRemove;

  @override
  Widget build(BuildContext context) => Material(
    color: ColorManager.greyF8F9,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: ColorManager.greyE8E9),
      borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: loading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CustomAvatar(
              firstName: account.name,
              radius: 24,
              backgroundColor: ColorManager.blueE3,
            ),
            const SizedBox(width: 12),
            Expanded(child: _details(context)),
            if (loading)
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    ),
  );

  Widget _details(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        account.name.isEmpty ? account.identifier : account.name,
        style: StylesManager.styleBold16(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
      const SizedBox(height: 4),
      Text(_roleLabel(context), style: StylesManager.styleRegular12(context)),
      if (account.identifier.isNotEmpty)
        Text(account.identifier, style: StylesManager.styleRegular12(context)),
      TextButton.icon(
        onPressed: loading ? null : onRemove,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          foregroundColor: ColorManager.redD8,
        ),
        icon: const Icon(Icons.delete_outline, size: 16),
        label: Text(S.of(context).removeAccountFromDevice),
      ),
    ],
  );

  String _roleLabel(BuildContext context) {
    final s = S.of(context);
    return switch (UserRole.fromValue(account.role)) {
      UserRole.student => s.student,
      UserRole.teacher => s.teacher,
      UserRole.parent => s.parentGuardian,
      UserRole.supervisor => s.supervisor,
      UserRole.admin => s.admin,
      null => account.role,
    };
  }
}
