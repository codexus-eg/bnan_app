import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/curriculum_load_error.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserCurriculumField extends StatelessWidget {
  const AddUserCurriculumField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final s = S.of(context);
        final items = state.curriculums.map((item) => item.id).toList();
        final hint = state.isLoadingCurriculums
            ? s.loading
            : items.isEmpty
            ? s.noCurriculumsAvailable
            : s.selectCurriculum;
        return Column(
          children: [
            CustomDropdownFormField(
              label: s.curriculum,
              value: value,
              hint: hint,
              isRequired: true,
              backgroundColor: ColorManager.white,
              items: state.isLoadingCurriculums ? const [] : items,
              itemsLabels: {
                for (final item in state.curriculums) item.id: item.name,
              },
              validator: (value) =>
                  MyValidator.requiredValidator(value, s.selectCurriculumFirst),
              onChanged: onChanged,
            ),
            if (state.errorMessage != null)
              CurriculumLoadError(message: state.errorMessage!),
          ],
        );
      },
    );
  }
}
