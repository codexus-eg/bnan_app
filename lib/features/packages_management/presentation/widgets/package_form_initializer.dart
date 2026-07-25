import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';

class PackageFormInitializer {
  const PackageFormInitializer._();

  static void fillControllers({
    required PackageFormControllers controllers,
    required PackageModel package,
  }) {
    controllers.name.text = package.name ?? '';

    controllers.duration.text = package.type == 'monthly'
        ? package.months?.toString() ?? ''
        : package.hours?.toString() ?? '';

    controllers.oldPrice.text = package.oldPrice?.toString() ?? '';
    controllers.newPrice.text = package.price?.toString() ?? '';
    controllers.discountTitle.text = package.discountTitle ?? '';
    controllers.description.text = package.description ?? '';
  }
}