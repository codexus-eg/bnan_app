import 'package:bnan_app/core/helper/package_display_formatter.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicPackageDropdown extends StatelessWidget {
  const AcademicPackageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();
    return BlocBuilder<GetPackagesCubit, GetPackagesState>(
      builder: (context, state) {
        final all = state is GetPackagesSuccess ? state.packages : <PackageModel>[];
        final packages = all.where((p) => p.isActive && (cubit.isGulf ? p.currency != 'EGP' : p.currency == 'EGP' || p.currency == null)).toList();
        final items = packages.map((p) => p.id ?? '').where((id) => id.isNotEmpty).toList();
        final labels = {for (final p in packages) if (p.id != null) p.id!: PackageDisplayFormatter.name(context, p.name ?? '')};
        return CustomDropdown(
          label: S.of(context).packageFormName,
          value: items.contains(cubit.packageId) ? cubit.packageId : null,
          hint: S.of(context).selectPackage,
          items: items,
          itemsLabels: labels,
          isRequired: true,
          enabled: cubit.curriculumId.isNotEmpty,
          onChanged: (id) => _onSelect(context, cubit, packages, id),
        );
      },
    );
  }

  void _onSelect(BuildContext context, RegisterCubit cubit, List<PackageModel> packages, String? id) {
    if (id == null) return;
    context.read<TamaraPaymentCubit>().invalidateAmountSummary();
    context.read<DiscountPreviewCubit>().invalidate();
    cubit.selectPackage(packages.firstWhere((p) => p.id == id));
    final state = context.read<GetCurriculmSubjectsCubit>().state;
    if (state is GetSubjectsSuccess) cubit.setAllSubjectIds(state.subjects.map((s) => s.id));
  }
}
