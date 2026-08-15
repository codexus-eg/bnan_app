import 'package:bnan_app/core/localization/language_manager/language_manager.dart';
import 'package:bnan_app/core/localization/language_manager/language_state.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageDrawerItem extends StatelessWidget {
  const LanguageDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: context.read<LanguageCubit>().toggleLanguage,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 5),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorManager.blueE3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    color: ColorManager.mainColor14,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isArabic
                      ? S.of(context).languageEnglish
                      : S.of(context).languageArabic,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
