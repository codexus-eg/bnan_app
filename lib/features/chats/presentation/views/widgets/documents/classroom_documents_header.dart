import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomDocumentsHeader extends StatelessWidget {
  const ClassroomDocumentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorManager.mainColor14,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              IconButton(
                onPressed: () => MyNavigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: ColorManager.white),
              ),
              Expanded(
                child: Text(
                  S.of(context).allDocuments,
                  style: StylesManager.styleBold18(
                    context,
                  ).copyWith(color: ColorManager.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
