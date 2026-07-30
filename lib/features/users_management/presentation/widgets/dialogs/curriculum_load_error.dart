import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialog_error_message.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumLoadError extends StatelessWidget {
  const CurriculumLoadError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DialogErrorMessage(message: message),
        const SizedBox(height: 8),
        SizedBox(
          width: 140,
          child: CustomAppButton(
            text: S.of(context).retry,
            height: 36,
            onPressed: context.read<AcademicLookupsCubit>().loadCurriculums,
          ),
        ),
      ],
    );
  }
}
