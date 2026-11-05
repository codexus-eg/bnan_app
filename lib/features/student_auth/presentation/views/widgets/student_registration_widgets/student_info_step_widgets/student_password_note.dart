import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentPasswordNote extends StatelessWidget {
  const StudentPasswordNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        S.of(context).passwordWillBeUsed,
        style: StylesManager.styleBold12(
          context,
        ).copyWith(color: ColorManager.grey7D7D),
      ),
    );
  }
}
