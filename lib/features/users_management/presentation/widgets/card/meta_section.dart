import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/info_text.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/user_relationship_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class MetaSection extends StatelessWidget {
  const MetaSection({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final relationships = userRelationshipItems(s, user);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.relationships,
                style: StylesManager.styleBold10(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              const SizedBox(height: 4),
              ...relationships.map(
                (item) => ClassMetaRow(
                  label: '${item.label}: ',
                  value: item.value,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: InfoText(
            label: s.registrationDate,
            value: AppPickers.formatDateOnly(user.registrationDate),
          ),
        ),
      ],
    );
  }
}
