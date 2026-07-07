import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';


class CurriculumManagementBody extends StatelessWidget {
  const CurriculumManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: AddNewTopicButton(
            padding: EdgeInsetsDirectional.only(
              start: 17.5,
              end: 24.5,
              top: 8,
              bottom: 8,
            ),
            title: s.addNewCurriculum,
            path: ImageManager.plus,
            onTap: (){},
          ),
        ),
        // Expanded(
        //   child: CurriculumList(
        //     curriculums: curriculums,
            
        //   ),
        // ),
      ],
    );
  }
}
