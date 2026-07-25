import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_mapper.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_state.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_validator.dart';

class PackageFormSubmitter {
  const PackageFormSubmitter._();

  static String? submit({
    required PackageActionsCubit cubit,
    required PackageFormControllers controllers,
    required PackageFormState formState,
    PackageModel? package,
  }) {
    final error = PackageFormValidator.validate(
      controllers: controllers,
      state: formState,
    );

    if (error != null) return error;

    final curriculumId = formState.curriculumId!;

    if (package == null) {
      cubit.createPackage(
        PackageFormMapper.toAddModel(
          controllers: controllers,
          curriculumId: curriculumId,
          type: formState.packageType,
          currency: formState.currency,
          isPopular: formState.isPopular,
        ),
      );

      return null;
    }

    final packageId = package.id;

    if (packageId == null || packageId.isEmpty) {
      return 'packageId';
    }

    cubit.updatePackage(
      packageId: packageId,
      model: PackageFormMapper.toUpdateModel(
        controllers: controllers,
        curriculumId: curriculumId,
        type: formState.packageType,
        currency: formState.currency,
        isPopular: formState.isPopular,
      ),
    );

    return null;
  }
}
