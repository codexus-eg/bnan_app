import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageFormCubit extends Cubit<PackageFormState> {
  PackageFormCubit() : super(const PackageFormState());

  void initialize(PackageModel? package) {
    emit(
      PackageFormState(
        curriculumId: package?.curriculum,
        packageId: package?.id,
        packageType: _valueOrDefault(package?.type, 'hours'),
        currency: _valueOrDefault(package?.currency, 'SAR'),
        isPopular: package?.isPopular ?? false,
      ),
    );
  }

  void setCurriculum(String? id) {
    emit(
      PackageFormState(
        curriculumId: id,
        packageId: state.packageId,
        packageType: state.packageType,
        currency: state.currency,
        isPopular: state.isPopular,
      ),
    );
  }

  void setType(String type) {
    emit(_copy(packageType: type));
  }

  void setCurrency(String currency) {
    emit(_copy(currency: currency));
  }

  void setPopular(bool value) {
    emit(_copy(isPopular: value));
  }

  PackageFormState _copy({
    String? packageType,
    String? currency,
    bool? isPopular,
  }) {
    return PackageFormState(
      curriculumId: state.curriculumId,
      packageId: state.packageId,
      packageType: packageType ?? state.packageType,
      currency: currency ?? state.currency,
      isPopular: isPopular ?? state.isPopular,
    );
  }

  String _valueOrDefault(String? value, String fallback) {
    return value?.trim().isNotEmpty == true ? value! : fallback;
  }
}
