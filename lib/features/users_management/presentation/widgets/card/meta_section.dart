import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/info_text.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class MetaSection extends StatelessWidget {
  const MetaSection({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${s.parent}: ',
                      style: StylesManager.styleMedium10(
                        context,
                      )
                    ),
                    TextSpan(
                      text: '${user.parentName}\n',
                      style: StylesManager.styleRegular10(
                        context,
                      ).copyWith(color: ColorManager.greyA8AF),
                    ),
                    TextSpan(
                      text: '${s.classes}: ',
                     style: StylesManager.styleMedium10(
                        context,
                      )
                    ),
                    TextSpan(
                      text: user.classes,
                      style: StylesManager.styleRegular10(
                        context,
                      ).copyWith(color: ColorManager.greyA8AF),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: InfoText(
            label: s.registrationDate,
            value: user.registrationDate,
          ),
        ),
      ],
    );
  }
}
