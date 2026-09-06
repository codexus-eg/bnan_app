import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassroomSupervisorDropdown extends StatelessWidget {
  const AddClassroomSupervisorDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.supervisors,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<SupervisorModel> supervisors;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final items = supervisors.map((item) => item.id).toList();
    final selectedValue = items.contains(value) ? value : null;

    return CustomDropdownFormField(
      label: s.theSupervisor,
      value: selectedValue,
      hint: hint,
      items: items,
      itemsLabels: {
        for (final item in supervisors)
          item.id: item.user?.fullName.trim().isNotEmpty == true
              ? item.user!.fullName
              : item.id,
      },
      isRequired: true,
      backgroundColor: ColorManager.white,
      validator: (val) => val?.isNotEmpty == true ? null : s.supervisorRequired,
      onChanged: onChanged,
    );
  }
}
