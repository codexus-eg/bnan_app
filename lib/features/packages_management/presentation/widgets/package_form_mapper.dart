import 'package:bnan_app/features/packages_management/data/models/add_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/update_package_request_model.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';

class PackageFormMapper {
  const PackageFormMapper._();

  static AddPackageRequestModel toAddModel({
    required PackageFormControllers controllers,
    required String curriculumId,
    required String type,
    required String currency,
    required bool isPopular,
  }) {
    final duration = int.tryParse(controllers.duration.text.trim());

    return AddPackageRequestModel(
      name: controllers.name.text.trim(),
      curriculum: curriculumId,
      type: type,
      hours: type == 'hours' ? duration : null,
      months: type == 'monthly' ? duration : null,
      oldPrice: num.tryParse(controllers.oldPrice.text.trim()) ?? 0,
      price: num.tryParse(controllers.newPrice.text.trim()) ?? 0,
      currency: currency,
      description: controllers.description.text.trim(),
      discountTitle: controllers.discountTitle.text.trim(),
      isPopular: isPopular,
    );
  }

  static UpdatePackageRequestModel toUpdateModel({
    required PackageFormControllers controllers,
    required String curriculumId,
    required String type,
    required String currency,
    required bool isPopular,
  }) {
    final duration = int.tryParse(controllers.duration.text.trim());

    return UpdatePackageRequestModel(
      name: controllers.name.text.trim(),
      curriculum: curriculumId,
      type: type,
      hours: type == 'hours' ? duration : null,
      months: type == 'monthly' ? duration : null,
      oldPrice: num.tryParse(controllers.oldPrice.text.trim()),
      price: num.tryParse(controllers.newPrice.text.trim()),
      currency: currency,
      description: controllers.description.text.trim(),
      discountTitle: controllers.discountTitle.text.trim(),
      isPopular: isPopular,
    );
  }
}