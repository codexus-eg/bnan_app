import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentSubjectsSearch extends StatelessWidget {
  const StudentSubjectsSearch({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      key: const Key('studentSubjectsSearch'),
      hintText: S.of(context).searchForSubject,
      onChanged: onChanged,
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.all(10),
        child: SvgPicture.asset(
          ImageManager.usersManagementSearchIcon,
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
