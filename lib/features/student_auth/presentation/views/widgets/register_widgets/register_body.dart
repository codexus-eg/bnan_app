import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/register_widgets/register_account_types_list.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/shared_widgets/auth_header.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/shared_widgets/bnan_footer.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  AuthHeader(
                    title: S.of(context).createNewAccount,
                    subtitle: S.of(context).chooseAccountType,
                    subtitleStyle: StylesManager.styleBold14(context).copyWith(
                      color: ColorManager.greyA8AF
                    ),
                  ),
                  const SizedBox(height: 16),
                  const RegisterAccountTypesList(),
                  const Spacer(),
                  const BnanFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}