import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPackageButton extends StatelessWidget {
  const AddPackageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final curriculums = state.curriculums;

        final curriculumIds = curriculums.map((e) => e.id.toString()).toList();

        final labels = {
          for (final curriculum in curriculums)
            curriculum.id.toString(): curriculum.name,
        };
        final registrationModes = {
          for (final curriculum in curriculums)
            curriculum.id.toString(): curriculum.registrationMode,
        };

        return AddNewTopicButton(
          title: S.of(context).addNewPackage,
          path: ImageManager.plus,
          padding: const EdgeInsetsDirectional.only(
            start: 18,
            end: 25,
            top: 8,
            bottom: 8,
          ),
          onTap: () {
            final actionsCubit = context.read<PackageActionsCubit>();

            showDialog(
              context: context,
              builder: (_) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: actionsCubit),
                    BlocProvider(create: (_) => getIt<PackageFormCubit>()),
                  ],
                  child: PackageFormDialog(
                    curriculums: curriculumIds,
                    labels: labels,
                    registrationModes: registrationModes,
                    onSuccess: () {
                      context.read<GetPackagesCubit>().getPackages();
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
