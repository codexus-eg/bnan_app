import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
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

        return InkWell(
          onTap: () {
            cubit.changeDeclarationAccepted(!cubit.declarationAccepted);
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorManager.blueE3),
            ),
            child: Row(
              children: [
                SelectionCircle(isSelected: cubit.declarationAccepted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    S.of(context).teacherDeclarationAgreement,
                    style: StylesManager.styleBold14(
                      context,
                    ).copyWith(color: ColorManager.mainColor14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
