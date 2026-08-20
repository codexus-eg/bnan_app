import 'package:bnan_app/core/constants/tamara_default_address.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo, this.gulfParentAuthRepo)
    : super(const RegisterInitial());

  final AuthRepo authRepo;
  final GulfParentAuthRepo gulfParentAuthRepo;

  static RegisterCubit get(context) => BlocProvider.of(context);

  static const int firstStep = 1;
  int get lastStep => 4;
  String curriculumId = '';
  String curriculumName = '';
  String packageId = '';
  String packageName = '';
  String packagePrice = '';
  String packageCurrency = '';
  String? registrationMode;
  bool isSingleSubjectPackage = false;
  String? selectedCurriculumName;

  final parentFormKey = GlobalKey<FormState>();
  final studentFormKey = GlobalKey<FormState>();

  final parentEmailController = TextEditingController();
  final parentPasswordController = TextEditingController();
  final studentPasswordController = TextEditingController();
  final studentNameController = TextEditingController();
  final studentEmailController = TextEditingController();
  final discountCodeController = TextEditingController();

  String? selectedGradeId;
  String? selectedGradeName;

  List<String> selectedSubjectIds = [];
  void setRegisterFlowArgs(RegisterFlowArgsModel args) {
    curriculumId = args.curriculumId;
    curriculumName = args.curriculumName;
    packageId = args.packageId;
    packageName = args.packageName;
    packagePrice = args.packagePrice;
    packageCurrency = args.packageCurrency;
    registrationMode = args.registrationMode;
    isSingleSubjectPackage = args.isSingleSubject;
  }

  bool get isGulf => registrationMode == 'gulf';
  bool get requiresSubjectSelection => isGulf || isSingleSubjectPackage;
  bool _authenticating = false;
  bool _submitting = false;
  void setGrade({required String id, required String name}) {
    selectedGradeId = id;
    selectedGradeName = name;
    selectedSubjectIds.clear();

    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void toggleSubject(String subjectId) {
    if (isSingleSubjectPackage) {
      selectedSubjectIds = selectedSubjectIds.contains(subjectId)
          ? []
          : [subjectId];
      emit(RegisterStepChanged(currentStep: state.currentStep));
      return;
    }
    if (selectedSubjectIds.contains(subjectId)) {
      selectedSubjectIds.remove(subjectId);
    } else {
      selectedSubjectIds.add(subjectId);
    }

    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void setAllSubjectIds(Iterable<String> subjectIds) {
    if (requiresSubjectSelection) return;
    selectedSubjectIds = subjectIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void setPackageId(String id) {
    packageId = id;
  }

  void setCurriculumId(String id) {
    curriculumId = id;
  }

  void setCurriculum({required String id, required String name}) {
    curriculumId = id;
    selectedCurriculumName = name;
    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void nextStep() {
    if (state.currentStep < lastStep) {
      emit(RegisterStepChanged(currentStep: state.currentStep + 1));
    }
  }

  bool validateStudent() {
    final validForm = studentFormKey.currentState?.validate() ?? false;
    final validSubjects = !requiresSubjectSelection
        ? true
        : isSingleSubjectPackage
        ? selectedSubjectIds.length == 1
        : selectedSubjectIds.isNotEmpty;
    return validForm && selectedGradeId != null && validSubjects;
  }

  RegisterRequestModel? buildRegisterRequest() {
    final subjectCount = selectedSubjectIds.length;
    final validSubjects = !requiresSubjectSelection
        ? true
        : isSingleSubjectPackage
        ? subjectCount == 1
        : subjectCount > 0;
    if (selectedGradeId == null || !validSubjects) return null;
    return RegisterRequestModel(
      parent: RegisterParentModel(
        email: parentEmailController.text.trim(),
        password: parentPasswordController.text,
      ),
      student: RegisterStudentModel(
        fullName: studentNameController.text.trim(),
        email: studentEmailController.text.trim(),
        password: studentPasswordController.text,
        grade: selectedGradeId!,
        subjects: List.unmodifiable(selectedSubjectIds),
      ),
      curriculum: curriculumId,
      packageId: packageId,
    );
  }

  Future<void> authenticateParentAndContinue() async {
    if (_authenticating) return;
    if (!(parentFormKey.currentState?.validate() ?? false)) return;
    _authenticating = true;
    emit(RegisterLoading(currentStep: state.currentStep));
    try {
      final result = await gulfParentAuthRepo.authenticate(
        RegisterParentModel(
          email: parentEmailController.text,
          password: parentPasswordController.text,
        ),
      );
      if (isClosed) return;
      result.fold(
        (failure) => emit(
          RegisterFailure(
            errorMessage: failure.message,
            currentStep: state.currentStep,
          ),
        ),
        (_) => nextStep(),
      );
    } finally {
      _authenticating = false;
    }
  }

  TamaraCheckoutRequest? buildTamaraRequest({bool validateForm = true}) {
    if ((validateForm && !(studentFormKey.currentState?.validate() ?? false)) ||
        selectedGradeId == null ||
        selectedSubjectIds.isEmpty ||
        curriculumId.isEmpty ||
        packageId.isEmpty) {
      return null;
    }
    return TamaraCheckoutRequest(
      parentEmail: parentEmailController.text,
      parentPassword: parentPasswordController.text,
      student: RegisterStudentModel(
        fullName: studentNameController.text.trim(),
        email: studentEmailController.text.trim(),
        password: studentPasswordController.text,
        grade: selectedGradeId!,
        subjects: List.unmodifiable(selectedSubjectIds),
      ),
      curriculumId: curriculumId,
      packageId: packageId,
      discountCode: discountCodeController.text.trim().isEmpty
          ? null
          : discountCodeController.text.trim(),
      address: const PaymentAddress(
        city: TamaraDefaultAddress.city,
        region: TamaraDefaultAddress.region,
        line1: TamaraDefaultAddress.line1,
        line2: TamaraDefaultAddress.line2,
      ),
    );
  }

  void previousStep() {
    if (state.currentStep > firstStep) {
      emit(RegisterStepChanged(currentStep: state.currentStep - 1));
    }
  }

  Future<void> register({required RegisterRequestModel request}) async {
    if (_submitting) return;
    _submitting = true;
    final currentStep = state.currentStep;
    emit(RegisterLoading(currentStep: currentStep));
    try {
      final result = await authRepo.register(request: request);
      if (isClosed) return;
      result.fold(
        (failure) => emit(
          RegisterFailure(
            errorMessage: failure.message,
            currentStep: currentStep,
          ),
        ),
        (response) => emit(
          RegisterSuccess(user: response.user, currentStep: currentStep),
        ),
      );
    } finally {
      _submitting = false;
    }
  }

  @override
  Future<void> close() {
    parentEmailController.dispose();
    parentPasswordController.dispose();
    studentPasswordController.dispose();
    studentNameController.dispose();
    studentEmailController.dispose();
    discountCodeController.dispose();
    return super.close();
  }
}
