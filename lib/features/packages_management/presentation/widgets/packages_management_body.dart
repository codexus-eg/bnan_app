import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/add_package_button.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/delete_package_dialog.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_admin_actions.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_dialog.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/packages_curriculum_dropdown.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

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
          AddPackageButton(
            curriculums: const [
              '6a5fcada03319aba30452a89',
              '6a5fcada03319aba30452a90',
              '6a5fcada03319aba30452a91',
            ],
            labels: const {
              '6a5fcada03319aba30452a89': 'المنهج المصري',
              '6a5fcada03319aba30452a90': 'المنهج السعودي',
              '6a5fcada03319aba30452a91': 'المنهج الإماراتي',
            },
          ),
          const SizedBox(height: 16),
          PackagesCurriculumDropdown(
            value: selectedCurriculumId,
            onChanged: (value) {
              setState(() {
                selectedCurriculumId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: SubscriptionGrid(
                curriculumId: '6a5fcada03319aba30452a89',
                curriculumName: 'Egyptian',
                isSliver: false,
                bottomWidget: (plan) {
                  return PackageAdminActions(
                    plan: plan,
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: DeletePackageDialog(
                              packageId: '',
                              isLoading: false,
                              onPressed: () {
                                // delete package
                              },
                            ),
                          );
                        },
                      );
                    },
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (_) => PackageFormDialog(
                          curriculums: [''],
                          labels: {'': ""},
                          isEdit: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
