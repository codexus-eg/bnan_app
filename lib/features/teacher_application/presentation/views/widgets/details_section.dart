import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_fields_grid.dart';
import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({super.key, required this.title, required this.fields});

  final String title;
  final List<DetailsFieldData> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        const SizedBox(height: 8),
        DetailsFieldsGrid(fields: fields),
      ],
    );
  }
}
