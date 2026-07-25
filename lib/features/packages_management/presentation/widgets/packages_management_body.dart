import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/add_package_button.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/packages_curriculum_dropdown.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/packages_management_grid_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackagesManagementBody extends StatefulWidget {
  const PackagesManagementBody({super.key});

  @override
  State<PackagesManagementBody> createState() => _PackagesManagementBodyState();
}

class _PackagesManagementBodyState extends State<PackagesManagementBody> {
  String? selectedCurriculumId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomAppbar(
            headerText: S.of(context).packagesManagement,
            iconNeeded: false,
          ),
         const AddPackageButton(),
          const SizedBox(height: 16),
          PackagesCurriculumDropdown(
            value: selectedCurriculumId,
            onChanged: (value) {
              setState(() {
                selectedCurriculumId = value;
              });
              if (value == null) {
                context.read<GetPackagesCubit>().getPackages();
                return;
              }
              context.read<GetPackagesCubit>().getPackagesByCurriculum(value);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PackagesManagementGridSection(
              curriculumId: selectedCurriculumId ?? '',
              curriculumName: '',
            ),
          ),
        ],
      ),
    );
  }
}
