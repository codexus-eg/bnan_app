import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageFormCubit extends Cubit<PackageFormState> {
  PackageFormCubit() : super(const PackageFormState());

  void initialize(
    PackageModel? package,
    Map<String, String?> registrationModes,
  ) {
    final registrationMode = registrationModes[package?.curriculum];
    final isGulf = registrationMode?.trim().toLowerCase() == 'gulf';
    final isEgyptian = registrationMode?.trim().toLowerCase() == 'egyptian';
    final isSingleSubject =
        package?.accessScope == PackageAccessScope.singleSubject;
    emit(
      PackageFormState(
        curriculumId: package?.curriculum,
        packageId: package?.id,
        packageType: isGulf || isSingleSubject
            ? 'hours'
            : isEgyptian
            ? 'monthly'
            : _valueOrDefault(package?.type, 'hours'),
        accessScope: package?.accessScope ?? PackageAccessScope.allSubjects,
        registrationMode: registrationMode,
        currency: _valueOrDefault(package?.currency, 'SAR'),
        isPopular: package?.isPopular ?? false,
      ),
    );
  }

  void setCurriculum(String? id, String? registrationMode) {
    final isEgyptian = registrationMode?.trim().toLowerCase() == 'egyptian';
    final canKeepScope = isEgyptian;
    final isGulf = registrationMode?.trim().toLowerCase() == 'gulf';
    final accessScope = canKeepScope
        ? state.accessScope
        : PackageAccessScope.allSubjects;
    emit(
      PackageFormState(
        curriculumId: id,
        packageId: state.packageId,
        packageType: isGulf || accessScope == PackageAccessScope.singleSubject
            ? 'hours'
            : isEgyptian
            ? 'monthly'
            : state.packageType,
        accessScope: accessScope,
        registrationMode: registrationMode,
        currency: state.currency,
        isPopular: state.isPopular,
      ),
    );
  }

  void setType(String type) {
    if ((state.isGulf || state.isSingleSubject) && type == 'monthly' ||
        state.isEgyptianAllSubjects && type == 'hours') {
      return;
    }
    emit(_copy(packageType: type));
  }

  void setAccessScope(String scope) {
    if (scope == PackageAccessScope.singleSubject &&
        !state.canSelectSingleSubject) {
      return;
    }
    emit(
      _copy(
        accessScope: scope,
        packageType: scope == PackageAccessScope.singleSubject
            ? 'hours'
            : state.isEgyptian
            ? 'monthly'
            : null,
      ),
    );
  }

  void setCurrency(String currency) {
    emit(_copy(currency: currency));
  }

  void setPopular(bool value) {
    emit(_copy(isPopular: value));
  }

  PackageFormState _copy({
    String? packageType,
    String? accessScope,
    String? currency,
    bool? isPopular,
  }) {
    return PackageFormState(
      curriculumId: state.curriculumId,
      packageId: state.packageId,
      packageType: packageType ?? state.packageType,
      accessScope: accessScope ?? state.accessScope,
      registrationMode: state.registrationMode,
      currency: currency ?? state.currency,
      isPopular: isPopular ?? state.isPopular,
    );
  }

  String _valueOrDefault(String? value, String fallback) {
    return value?.trim().isNotEmpty == true ? value! : fallback;
  }
}
