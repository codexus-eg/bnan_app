import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_info_field.dart';
import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:flutter/material.dart';

class DetailsFieldsGrid extends StatelessWidget {
  const DetailsFieldsGrid({super.key, required this.fields});

  final List<DetailsFieldData> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < fields.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: DetailsInfoField(
                      label: fields[i].label,
                      value: fields[i].value,
                    ),
                  ),
                  const SizedBox(width: 21),
                  Expanded(
                    child: i + 1 < fields.length
                        ? DetailsInfoField(
                            label: fields[i + 1].label,
                            value: fields[i + 1].value,
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
