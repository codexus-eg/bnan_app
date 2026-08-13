import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/packages_management/data/models/add_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/models/update_package_request_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_state.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_state.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_body.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_dialog_layout.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageFormDialog extends StatefulWidget {
  const PackageFormDialog({
    super.key,
    required this.curriculums,
    required this.labels,
    required this.registrationModes,
    required this.onSuccess,
    this.package,
  });

  final List<String> curriculums;
  final Map<String, String> labels;
  final Map<String, String?> registrationModes;
  final VoidCallback onSuccess;
  final PackageModel? package;

  bool get isEdit => package != null;

  @override
  State<PackageFormDialog> createState() => _PackageFormDialogState();
}

class _PackageFormDialogState extends State<PackageFormDialog> {
  final controllers = PackageFormControllers();
  String? validationError;
  @override
  void initState() {
    super.initState();
    context.read<PackageFormCubit>().initialize(
      widget.package,
      widget.registrationModes,
    );
    final package = widget.package;
    if (package != null) controllers.fillFromPackage(package);
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackageActionsCubit, PackageActionsState>(
      listener: _listen,
      builder: (context, actionState) {
        final loading =
            actionState is CreatePackageLoading ||
            actionState is UpdatePackageLoading;

        return BlocBuilder<PackageFormCubit, PackageFormState>(
          builder: (context, formState) => PackageFormDialogLayout(
            title: _title,
            body: _fields(formState, loading),
          ),
        );
      },
    );
  }

  String get _title {
    return widget.isEdit
        ? S.of(context).editPackage
        : S.of(context).addNewPackage;
  }

  Widget _fields(PackageFormState state, bool loading) {
    final cubit = context.read<PackageFormCubit>();

    return PackageFormBody(
      controllers: controllers,
      curriculums: widget.curriculums,
      labels: widget.labels,
      curriculumId: state.curriculumId,
      packageType: state.packageType,
      accessScope: state.accessScope,
      canSelectSingleSubject: state.canSelectSingleSubject,
      showMonthly: !state.isGulf,
      currency: state.currency,
      isPopular: state.isPopular,
      isLoading: loading,
      onCurriculumChanged: (id) =>
          cubit.setCurriculum(id, widget.registrationModes[id]),
      onTypeChanged: cubit.setType,
      onScopeChanged: cubit.setAccessScope,
      onCurrencyChanged: (value) {
        if (value != null) cubit.setCurrency(value);
      },
      onPopularChanged: cubit.setPopular,
      onSave: loading ? null : () => _submit(state),
      errorMessage: validationError,
    );
  }

  void _listen(BuildContext context, PackageActionsState state) {
    if (state is CreatePackageSuccess || state is UpdatePackageSuccess) {
      setState(() {
        validationError = null;
      });

      final message = state is CreatePackageSuccess
          ? S.of(context).packageCreatedSuccessfully
          : S.of(context).packageUpdatedSuccessfully;

      showCustomSnackBar(context, message, true);

      widget.onSuccess();
      Navigator.pop(context);
    }

    if (state is CreatePackageFailure) {
      setState(() {
        validationError = state.message;
      });
    }

    if (state is UpdatePackageFailure) {
      setState(() {
        validationError = state.message;
      });
    }
  }

  void _submit(PackageFormState state) {
    final error = _validate(state);
    if (error != null) {
      setState(() {
        validationError = _validationMessage(error);
      });
      return;
    }

    setState(() {
      validationError = null;
    });

    final actionsCubit = context.read<PackageActionsCubit>();
    if (widget.package == null) {
      actionsCubit.createPackage(_addRequest(state));
      return;
    }

    final packageId = state.packageId;
    if (packageId == null || packageId.isEmpty) {
      setState(() {
        validationError = S.of(context).invalidPackage;
      });
      return;
    }

    actionsCubit.updatePackage(
      packageId: packageId,
      model: _updateRequest(state),
    );
  }

  String? _validate(PackageFormState state) {
    final duration = int.tryParse(controllers.duration.text.trim());
    final oldPrice = num.tryParse(controllers.oldPrice.text.trim());
    final newPrice = num.tryParse(controllers.newPrice.text.trim());

    if (state.curriculumId?.isEmpty ?? true) return 'curriculum';
    if (state.isGulf && state.packageType != 'hours') return 'packageType';
    if (controllers.name.text.trim().isEmpty) return 'name';
    if (duration == null || duration <= 0) return 'duration';
    if (oldPrice == null || oldPrice < 0) return 'oldPrice';
    if (newPrice == null || newPrice < 0) return 'newPrice';
    if (newPrice > oldPrice) return 'priceGreaterThanOldPrice';
    if (state.currency.trim().isEmpty) return 'currency';
    return null;
  }

  String _validationMessage(String key) {
    switch (key) {
      case 'curriculum':
        return S.of(context).selectCurriculumFirst;
      case 'name':
        return S.of(context).packageNameRequired;
      case 'duration':
        return S.of(context).packageDurationInvalid;
      case 'oldPrice':
        return S.of(context).oldPriceInvalid;
      case 'newPrice':
        return S.of(context).newPriceInvalid;
      case 'priceGreaterThanOldPrice':
        return S.of(context).newPriceMustBeLessThanOldPrice;
      case 'currency':
        return S.of(context).currencyRequired;
      case 'packageType':
        return S.of(context).invalidPackage;
      default:
        return S.of(context).invalidData;
    }
  }

  AddPackageRequestModel _addRequest(PackageFormState state) {
    final duration = int.parse(controllers.duration.text.trim());
    final type = state.effectivePackageType;

    return AddPackageRequestModel(
      name: controllers.name.text.trim(),
      curriculum: state.curriculumId!,
      type: type,
      accessScope: state.accessScope,
      hours: type == 'hours' ? duration : null,
      months: type == 'monthly' ? duration : null,
      oldPrice: num.parse(controllers.oldPrice.text.trim()),
      price: num.parse(controllers.newPrice.text.trim()),
      currency: state.currency,
      description: controllers.description.text.trim(),
      discountTitle: controllers.discountTitle.text.trim(),
      isPopular: state.isPopular,
    );
  }

  UpdatePackageRequestModel _updateRequest(PackageFormState state) {
    final duration = int.parse(controllers.duration.text.trim());
    final type = state.effectivePackageType;

    return UpdatePackageRequestModel(
      name: controllers.name.text.trim(),
      curriculum: state.curriculumId,
      type: type,
      accessScope: state.accessScope,
      hours: type == 'hours' ? duration : null,
      months: type == 'monthly' ? duration : null,
      oldPrice: num.parse(controllers.oldPrice.text.trim()),
      price: num.parse(controllers.newPrice.text.trim()),
      currency: state.currency,
      description: controllers.description.text.trim(),
      discountTitle: controllers.discountTitle.text.trim(),
      isPopular: state.isPopular,
    );
  }
}
