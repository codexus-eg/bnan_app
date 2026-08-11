import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/core/helper/phone_number_normalizer.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
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
  static const int lastStep = 5;
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

  final parentNameController = TextEditingController();
  final parentEmailController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentWhatsappController = TextEditingController();
  final parentPasswordController = TextEditingController();
  final studentPasswordController = TextEditingController();
  final studentNameController = TextEditingController();
  final studentEmailController = TextEditingController();
  final cityController = TextEditingController();
  final regionController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
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
  String? get normalizedParentPhone => PhoneNumberNormalizer.normalize(
    parentPhoneController.text,
    currency: packageCurrency,
  );

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

  Future<void> authenticateParentAndContinue() async {
    if (!(parentFormKey.currentState?.validate() ?? false)) return;
    final parentPhone = normalizedParentPhone;
    if (parentPhone == null) return;
    emit(RegisterLoading(currentStep: state.currentStep));
    final result = await gulfParentAuthRepo.authenticate(
      ParentRegisterRequestModel(
        fullName: parentNameController.text,
        email: parentEmailController.text,
        password: parentPasswordController.text,
        phone: parentPhone,
        whatsappNumber: parentWhatsappController.text.trim().isEmpty
            ? parentPhone
            : parentWhatsappController.text,
      ),
    );
    result.fold(
      (failure) => emit(
        RegisterFailure(
          errorMessage: failure.message,
          currentStep: state.currentStep,
        ),
      ),
      (_) => nextStep(),
    );
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
      address: PaymentAddress(
        city: cityController.text,
        region: regionController.text,
        line1: addressLine1Controller.text,
        line2: addressLine2Controller.text,
      ),
    );
  }

  void previousStep() {
    if (state.currentStep > firstStep) {
      emit(RegisterStepChanged(currentStep: state.currentStep - 1));
    }
  }

  Future<void> register({required RegisterRequestModel request}) async {
    emit(RegisterLoading(currentStep: state.currentStep));

    final result = await authRepo.register(request: request);

    result.fold(
      (failure) {
        emit(
          RegisterFailure(
            errorMessage: failure.message,
            currentStep: state.currentStep,
          ),
        );
      },
      (response) {
        emit(
          RegisterSuccess(user: response.user, currentStep: state.currentStep),
        );
      },
    );
  }

  @override
  Future<void> close() {
    parentNameController.dispose();
    parentEmailController.dispose();
    parentPhoneController.dispose();
    parentWhatsappController.dispose();
    parentPasswordController.dispose();
    studentPasswordController.dispose();
    studentNameController.dispose();
    studentEmailController.dispose();
    cityController.dispose();
    regionController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    discountCodeController.dispose();
    return super.close();
  }
}
