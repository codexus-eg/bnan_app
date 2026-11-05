import 'package:bnan_app/core/constants/tamara_default_address.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_requests.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/models/registration_item.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo, this.gulfParentAuthRepo, [this.parentAuthRepo])
    : super(const RegisterInitial());

  final AuthRepo authRepo;
  final GulfParentAuthRepo gulfParentAuthRepo;
  final ParentAuthRepo? parentAuthRepo;

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
  String accessScope = 'all_subjects';
  bool isSingleSubjectPackage = false;
  bool isEgyptianPrivate = false;
  GulfPaymentProvider selectedProvider = GulfPaymentProvider.tamara;
  String? selectedCurriculumName;

  final parentFormKey = GlobalKey<FormState>();
  final studentFormKey = GlobalKey<FormState>();

  final parentNameController = TextEditingController();
  final parentEmailController = TextEditingController();
  final parentPasswordController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentWhatsappController = TextEditingController();
  final studentPasswordController = TextEditingController();
  final studentNameController = TextEditingController();
  final studentEmailController = TextEditingController();
  final discountCodeController = TextEditingController();

  String? selectedGradeId;
  String? selectedGradeName;

  List<String> selectedSubjectIds = [];
  final Map<String, String> _subjectNotes = {};
  Map<String, String> get subjectNotes => Map.unmodifiable(_subjectNotes);

  void updateSubjectNote(String subjectId, String note) {
    if (note.trim().isEmpty) {
      _subjectNotes.remove(subjectId);
    } else {
      _subjectNotes[subjectId] = note;
    }
  }

  void clearSubjectNotes() {
    _subjectNotes.clear();
  }
  void setRegisterFlowArgs(RegisterFlowArgsModel args) {
    curriculumId = args.curriculumId;
    curriculumName = args.curriculumName;
    packageId = args.packageId;
    packageName = args.packageName;
    packagePrice = args.packagePrice;
    packageCurrency = args.packageCurrency;
    registrationMode = args.registrationMode;
    accessScope = args.accessScope;
    isSingleSubjectPackage = args.isSingleSubject;
    isEgyptianPrivate = args.isEgyptianPrivate;
  }

  bool get isGulf => registrationMode == 'gulf';
  bool get isSingleSubject => accessScope == 'single_subject';
  bool get isSharedSubjects => accessScope == 'shared_subjects';
  bool get isAllSubjects => accessScope == 'all_subjects';
  bool get isItemizedCheckout => isGulf && isSingleSubject && !isSharedSubjects;

  int get checkoutItemCount => isItemizedCheckout
      ? selectedSubjectIds
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toSet()
            .length
      : 1;

  num get checkoutOriginalAmount {
    final unitPrice = num.tryParse(packagePrice.replaceAll(',', '')) ?? 0;
    return unitPrice * checkoutItemCount;
  }

  String formatAmount(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();

  void selectPaymentProvider(GulfPaymentProvider provider) {
    if (!isGulf || selectedProvider == provider) return;
    selectedProvider = provider;
    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void restorePaymentProvider(GulfPaymentProvider? provider) {
    if (provider != null) selectPaymentProvider(provider);
  }

  bool get requiresSubjectSelection =>
      isGulf || isSingleSubject || isSharedSubjects;
  bool _authenticating = false;
  bool _submitting = false;
  void setGrade({required String id, required String name}) {
    selectedGradeId = id;
    selectedGradeName = name;
    selectedSubjectIds.clear();
    _subjectNotes.clear();

    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void toggleSubject(String subjectId) {
    if (isSingleSubject && !isEgyptianPrivate) {
      selectedSubjectIds = selectedSubjectIds.contains(subjectId)
          ? []
          : [subjectId];
      _subjectNotes.removeWhere((id, _) => !selectedSubjectIds.contains(id));
      emit(RegisterStepChanged(currentStep: state.currentStep));
      return;
    }
    if (selectedSubjectIds.contains(subjectId)) {
      selectedSubjectIds.remove(subjectId);
      _subjectNotes.remove(subjectId);
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
    _subjectNotes.removeWhere((id, _) => !selectedSubjectIds.contains(id));
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

  void selectCurriculum(CurriculumModel curriculum) {
    if (curriculumId == curriculum.id) return;
    curriculumId = curriculum.id;
    curriculumName = curriculum.name;
    selectedCurriculumName = curriculum.name;
    registrationMode = curriculum.registrationMode;
    selectedGradeId = null;
    selectedGradeName = null;
    packageId = '';
    packageName = '';
    packagePrice = '';
    packageCurrency = '';
    accessScope = 'all_subjects';
    isSingleSubjectPackage = false;
    isEgyptianPrivate = false;
    selectedSubjectIds.clear();
    _subjectNotes.clear();
    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void selectPackage(PackageModel package) {
    packageId = package.id ?? '';
    packageName = package.name ?? '';
    packagePrice = (package.price ?? 0).toString();
    packageCurrency = package.currency ?? (isGulf ? 'SAR' : 'EGP');
    accessScope = package.accessScope;
    isSingleSubjectPackage = package.isSingleSubject;
    isEgyptianPrivate = !isGulf && package.isSingleSubject;
    selectedSubjectIds.clear();
    _subjectNotes.clear();
    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void nextStep() {
    if (state.currentStep < lastStep) {
      emit(RegisterStepChanged(currentStep: state.currentStep + 1));
    }
  }

  bool validateStudentInfo() {
    return studentFormKey.currentState?.validate() ?? false;
  }

  bool validateAcademicSelection() {
    final validSubjects = !requiresSubjectSelection
        ? true
        : isSingleSubject && !isEgyptianPrivate
        ? selectedSubjectIds.length == 1
        : isSharedSubjects
        ? selectedSubjectIds.length >= 2
        : selectedSubjectIds.isNotEmpty;
    return curriculumId.isNotEmpty &&
        selectedGradeId != null &&
        selectedGradeId!.isNotEmpty &&
        packageId.isNotEmpty &&
        validSubjects;
  }

  bool validateStudent() {
    return validateStudentInfo() && validateAcademicSelection();
  }

  RegisterRequestModel? buildRegisterRequest() {
    final selectedSubjects = selectedSubjectIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    final subjectCount = selectedSubjects.length;
    final validSubjects = !requiresSubjectSelection
        ? true
        : isSingleSubject && !isEgyptianPrivate
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
        subjects: selectedSubjects,
      ),
      curriculum: curriculumId,
      packageId: isEgyptianPrivate ? null : packageId,
      items: isEgyptianPrivate
          ? selectedSubjects
                .map(
                  (subjectId) => RegistrationItem(
                    subjectId: subjectId,
                    packageId: packageId,
                  ),
                )
                .toList(growable: false)
          : const [],
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
      await result.fold((failure) async {
        if (_isIncorrectLoginData(failure.code)) {
          GulfRegistrationDiagnostics.flow('INCORRECT_LOGIN_DATA intercepted');
          await _registerParentInsideFlow();
        } else if (_isUnverifiedParent(failure.code)) {
          GulfRegistrationDiagnostics.flow('verification required');
          emit(ParentVerificationRequired(currentStep: state.currentStep));
        } else if (_isInvalidParentRole(failure.code)) {
          emit(
            RegisterFailure(
              errorMessage:
                  S.current.studentRegistrationEmailBelongsToAnotherAccount,
              currentStep: state.currentStep,
            ),
          );
        } else if (_shouldRegisterParent(failure)) {
          await _registerParentInsideFlow();
        } else {
          GulfRegistrationDiagnostics.uiFailure(
            endpoint:
                GulfRegistrationDiagnostics.lastEndpoint ??
                'parent-authentication',
            cubit: 'RegisterCubit',
            state: 'RegisterFailure',
            message: failure.message,
          );
          emit(
            RegisterFailure(
              errorMessage: failure.message,
              currentStep: state.currentStep,
            ),
          );
        }
      }, (_) async => emit(const ParentAuthenticated()));
    } finally {
      _authenticating = false;
    }
  }

  void applyParentCredentials({
    required String email,
    required String password,
  }) {
    parentEmailController.text = email.trim();
    parentPasswordController.text = password;
  }

  bool _isUnverifiedParent(String? code) =>
      code?.trim().toUpperCase() == 'ACCOUNT_NOT_VERIFIED';

  bool _isIncorrectLoginData(String? code) =>
      code?.trim().toUpperCase() == 'INCORRECT_LOGIN_DATA';

  bool _isInvalidParentRole(String? code) =>
      code?.trim().toUpperCase() == 'INVALID_PARENT_ROLE';

  bool _shouldRegisterParent(Failure failure) {
    final code = failure.code?.trim().toUpperCase();
    const credentialCodes = {
      'INCORRECT_LOGIN_DATA',
      'INVALID_CREDENTIALS',
      'INVALID_LOGIN_DATA',
      'WRONG_PASSWORD',
      'UNAUTHORIZED',
    };
    final message = failure.message.toString().trim().toLowerCase();
    const credentialMessages = {
      'incorrect login',
      'incorrect email',
      'invalid credential',
      'invalid login',
      'wrong password',
      'email or password',
      'بيانات الدخول غير صحيحة',
      'البريد الإلكتروني أو كلمة المرور',
      'كلمة المرور غير صحيحة',
    };
    return _isMissingParent(failure.statusCode, code) ||
        failure.statusCode == 401 ||
        credentialCodes.contains(code) ||
        credentialMessages.any(message.contains);
  }

  Future<void> _registerParentInsideFlow() async {
    final repo = parentAuthRepo;
    if (repo == null) {
      emit(
        RegisterFailure(
          errorMessage: S.current.errorUnknown,
          currentStep: state.currentStep,
        ),
      );
      return;
    }
    GulfRegistrationDiagnostics.flow('auto parent registration started');
    final result = await repo.registerParent(
      ParentRegisterRequestModel(
        fullName: parentNameController.text,
        email: parentEmailController.text,
        password: parentPasswordController.text,
        phone: parentPhoneController.text,
        whatsappNumber: parentWhatsappController.text,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        GulfRegistrationDiagnostics.flow(
          '/auth/register-parent result: failure',
        );
        emit(
          RegisterFailure(
            errorMessage: _isEmailAlreadyUsed(failure)
                ? S.current.studentRegistrationEmailAlreadyRegistered
                : failure.message,
            currentStep: state.currentStep,
          ),
        );
      },
      (_) {
        GulfRegistrationDiagnostics.flow(
          '/auth/register-parent result: success',
        );
        GulfRegistrationDiagnostics.flow('verification required');
        emit(ParentVerificationRequired(currentStep: state.currentStep));
      },
    );
  }

  bool _isEmailAlreadyUsed(Failure failure) {
    final code = failure.code?.trim().toUpperCase();
    const duplicateCodes = {
      'EMAIL_ALREADY_EXISTS',
      'EMAIL_ALREADY_USED',
      'USER_ALREADY_EXISTS',
      'ACCOUNT_ALREADY_EXISTS',
      'DUPLICATE_EMAIL',
    };
    final message = failure.message.toString().trim().toLowerCase();
    return failure.statusCode == 409 ||
        duplicateCodes.contains(code) ||
        message.contains('already in use') ||
        message.contains('already exists') ||
        message.contains('مستخدم بالفعل') ||
        message.contains('موجود بالفعل');
  }

  bool _isMissingParent(int? statusCode, String? code) {
    const missingCodes = {
      'USER_NOT_FOUND',
      'ACCOUNT_NOT_FOUND',
      'PARENT_NOT_FOUND',
      'EMAIL_NOT_FOUND',
    };
    return statusCode == 404 ||
        missingCodes.contains(code?.trim().toUpperCase());
  }

  TamaraCheckoutRequest? buildTamaraRequest({bool validateForm = true}) {
    final selectedSubjects = selectedSubjectIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if ((validateForm && !(studentFormKey.currentState?.validate() ?? false)) ||
        selectedGradeId == null ||
        selectedSubjects.isEmpty ||
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
        subjects: List.unmodifiable(selectedSubjects),
        subjectNotes: isGulf ? Map.unmodifiable(_subjectNotes) : null,
      ),
      curriculumId: curriculumId,
      packageId: packageId,
      provider: selectedProvider,
      items: isGulf && isSingleSubject && !isSharedSubjects
          ? selectedSubjects
                .map(
                  (subjectId) => RegistrationItem(
                    subjectId: subjectId,
                    packageId: packageId,
                  ),
                )
                .toList(growable: false)
          : const [],
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

  DiscountPreviewRequest? buildDiscountPreviewRequest() {
    final checkout = buildTamaraRequest(validateForm: false);
    return checkout == null
        ? null
        : DiscountPreviewRequests.registration(checkout.toJson());
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
    parentNameController.dispose();
    parentEmailController.dispose();
    parentPasswordController.dispose();
    parentPhoneController.dispose();
    parentWhatsappController.dispose();
    studentPasswordController.dispose();
    studentNameController.dispose();
    studentEmailController.dispose();
    discountCodeController.dispose();
    return super.close();
  }
}
