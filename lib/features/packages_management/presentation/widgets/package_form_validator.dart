import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_state.dart';

class PackageFormValidator {
  const PackageFormValidator._();

  static String? validate({
    required PackageFormControllers controllers,
    required PackageFormState state,
  }) {
    if (state.curriculumId == null || state.curriculumId!.isEmpty) {
      return 'curriculum';
    }

    if (controllers.name.text.trim().isEmpty) {
      return 'name';
    }

    final duration = int.tryParse(controllers.duration.text.trim());
    if (duration == null || duration <= 0) {
      return 'duration';
    }

    final oldPrice = num.tryParse(controllers.oldPrice.text.trim());
    if (oldPrice == null || oldPrice < 0) {
      return 'oldPrice';
    }

    final newPrice = num.tryParse(controllers.newPrice.text.trim());
    if (newPrice == null || newPrice < 0) {
      return 'newPrice';
    }

    if (newPrice > oldPrice) {
      return 'priceGreaterThanOldPrice';
    }

    if (state.currency.trim().isEmpty) {
      return 'currency';
    }

    return null;
  }
}