import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curriculum_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculaList extends StatelessWidget {
  const CurriculaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurriculumCard(
          title: S.of(context).saudiCurriculum,
          description: S.of(context).saudiCurriculumDesc,
          flag: ImageManager.saudiIcon,
          onTap: () {
            MyNavigator.goTo(context, Routes.subscription);
          },
        ),
        const SizedBox(height: 18),
        CurriculumCard(
          title: S.of(context).egyptianCurriculum,
          description: S.of(context).egyptianCurriculumDesc,
          flag: ImageManager.egyptIcon,
          onTap: () {
            MyNavigator.goTo(context, Routes.subscription);
          },
        ),
        const SizedBox(height: 18),
        CurriculumCard(
          title: S.of(context).qatariCurriculum,
          description: S.of(context).qatariCurriculumDesc,
          flag: ImageManager.qatarIcon,
          onTap: () {
            MyNavigator.goTo(context, Routes.subscription);
          },
        ),
      ],
    );
  }
}
