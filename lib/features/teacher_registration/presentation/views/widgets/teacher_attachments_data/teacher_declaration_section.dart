import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/teacher_terms_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherDeclarationSection extends StatelessWidget {
  const TeacherDeclarationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, state) {
        final cubit = TeacherRegistrationCubit.get(context);
        final style = StylesManager.styleBold14(
          context,
        ).copyWith(color: ColorManager.mainColor14);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorManager.blueE3),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () =>
                    cubit.changeDeclarationAccepted(!cubit.declarationAccepted),
                child: SelectionCircle(isSelected: cubit.declarationAccepted),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text(S.of(context).termsAgreementPrefix, style: style),
                    InkWell(
                      onTap: () => _openTerms(context, cubit),
                      child: Text(
                        S.of(context).teacherTermsAndConditions,
                        style: style.copyWith(
                          color: ColorManager.secondaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorManager.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openTerms(
    BuildContext context,
    TeacherRegistrationCubit cubit,
  ) async {
    final result = await cubit.getTeacherTerms();
    if (!context.mounted) return;
    result.fold(
      (failure) => showCustomSnackBar(context, failure.message, false),
      (terms) => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => TeacherTermsView(terms: terms))),
    );
  }
}
