import 'dart:io';

import 'package:bnan_app/features/teacher_registration/data/models/select_grade_subjects.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_register_request_model.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRegistrationCubit extends Cubit<TeacherRegistrationState> {
  final TeacherRegistrationRepo teacherRegistrationRepo;

  TeacherRegistrationCubit(this.teacherRegistrationRepo)
    : super(const TeacherRegistrationInitialState());
  static TeacherRegistrationCubit get(context) => BlocProvider.of(context);

  static const int firstStep = 1;
  static const int lastStep = 8;
  String? graduationGrade;
  int? selectedGraduationYear;
  bool? hasTeachingExperience;
  bool? taughtOnlineBefore;
  String? selectedCurriculumId;
  String? selectedCurriculumName;
  String? activeGradeId;
  String? computerUsageLevel;
  bool? hasLaptopOrComputer;
  bool? hasStableInternet;
  bool? hasGoodCamera;
  bool? hasClearMic;
  bool? canProvideTrialLesson;
  File? cvFile;
  File? certificateFile;
  File? nationalIdFile;

  bool declarationAccepted = false;
  final List<SelectedGradeSubjects> selectedGradesSubjects = [];
  final personalInfoFormKey = GlobalKey<FormState>();
  final qualificationFormKey = GlobalKey<FormState>();
  final shortVideoLinkController = TextEditingController();
  final whyJoinBananController = TextEditingController();
  final howHandleWeakStudentController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nationalityController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final qualificationController = TextEditingController();
  final specializationController = TextEditingController();
  final universityController = TextEditingController();
  final graduationYearController = TextEditingController();
 
  bool get isSubmitDisabled {
    return state.currentStep == lastStep && !declarationAccepted;
  }

  void changeCvFile(File file) {
    cvFile = file;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeCertificateFile(File file) {
    certificateFile = file;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeNationalIdFile(File file) {
    nationalIdFile = file;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeDeclarationAccepted(bool value) {
    declarationAccepted = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  String? validateEvaluationStep() {
    if (canProvideTrialLesson == null) {
      return S.current.pleaseAnswerAllQuestions;
    }

    if (whyJoinBananController.text.trim().isEmpty) {
      return S.current.fieldIsRequired(S.current.whyJoinBananAcademy);
    }

    if (howHandleWeakStudentController.text.trim().isEmpty) {
      return S.current.fieldIsRequired(S.current.howHandleWeakStudent);
    }

    return null;
  }

  void changeCanProvideTrialLesson(bool value) {
    canProvideTrialLesson = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeTeachingCurriculum({required String id, required String name}) {
    selectedCurriculumId = id;
    selectedCurriculumName = name;
    selectedGradesSubjects.clear();
    activeGradeId = null;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  String? validateTeachingGradesSubjectsStep() {
    if (selectedGradesSubjects.isEmpty) {
      return S.current.pleaseChooseAtLeastOneGrade;
    }

    final hasGradeWithoutSubjects = selectedGradesSubjects.any(
      (item) => item.subjectIds.isEmpty,
    );

    if (hasGradeWithoutSubjects) {
      return S.current.pleaseChooseAtLeastOneSubjectForEachGrade;
    }

    return null;
  }

  bool isGradeSelected(String gradeId) {
    return selectedGradesSubjects.any((item) => item.gradeId == gradeId);
  }

  bool isSubjectSelected({required String gradeId, required String subjectId}) {
    final gradeIndex = selectedGradesSubjects.indexWhere(
      (item) => item.gradeId == gradeId,
    );

    if (gradeIndex == -1) return false;

    return selectedGradesSubjects[gradeIndex].subjectIds.contains(subjectId);
  }

  void toggleTeachingGrade({required String gradeId}) {
    final index = selectedGradesSubjects.indexWhere(
      (item) => item.gradeId == gradeId,
    );

    if (index == -1) {
      selectedGradesSubjects.add(
        SelectedGradeSubjects(gradeId: gradeId, subjectIds: []),
      );
      activeGradeId = gradeId;
    } else {
      selectedGradesSubjects.removeAt(index);
      if (activeGradeId == gradeId) {
        activeGradeId = selectedGradesSubjects.isEmpty
            ? null
            : selectedGradesSubjects.last.gradeId;
      }
    }

    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeActiveGrade(String gradeId) {
    activeGradeId = gradeId;

    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void toggleTeachingSubject({
    required String gradeId,
    required String subjectId,
  }) {
    final gradeIndex = selectedGradesSubjects.indexWhere(
      (item) => item.gradeId == gradeId,
    );
    if (gradeIndex == -1) return;

    final subjectIds = selectedGradesSubjects[gradeIndex].subjectIds;

    if (subjectIds.contains(subjectId)) {
      subjectIds.remove(subjectId);
    } else {
      subjectIds.add(subjectId);
    }

    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  String? validateTeachingCurriculumStep() {
    if (selectedCurriculumId == null) {
      return S.current.pleaseChooseTeachingCurriculum;
    }
    return null;
  }

  void changeGraduationGrade(String? value) {
    graduationGrade = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeGraduationYear(int year) {
    selectedGraduationYear = year;
    graduationYearController.text = year.toString();

    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  bool validateQualificationStep() {
    return qualificationFormKey.currentState?.validate() ?? false;
  }

  bool validatePersonalInfoStep() {
    return personalInfoFormKey.currentState?.validate() ?? false;
  }

  void changeTeachingExperience(bool value) {
    hasTeachingExperience = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeTaughtOnlineBefore(bool value) {
    taughtOnlineBefore = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  String? validateExperienceStep() {
    if (hasTeachingExperience == null || taughtOnlineBefore == null) {
      return S.current.pleaseAnswerAllQuestions;
    }
    return null;
  }

  void changeComputerUsageLevel(String value) {
    computerUsageLevel = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeHasLaptopOrComputer(bool value) {
    hasLaptopOrComputer = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeHasStableInternet(bool value) {
    hasStableInternet = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeHasGoodCamera(bool value) {
    hasGoodCamera = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeHasClearMic(bool value) {
    hasClearMic = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void nextStep() {
    if (state.currentStep < lastStep) {
      emit(TeacherRegistrationStepChange(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > firstStep) {
      emit(TeacherRegistrationStepChange(currentStep: state.currentStep - 1));
    }
  }

  String? validateTechnicalSkillsStep() {
    if (computerUsageLevel == null ||
        hasLaptopOrComputer == null ||
        hasStableInternet == null ||
        hasGoodCamera == null ||
        hasClearMic == null) {
      return S.current.pleaseAnswerAllQuestions;
    }

    return null;
  }

  String? validateAttachmentsStep() {
    if (cvFile == null) {
      return S.current.uploadCvFile;
    }

    if (certificateFile == null) {
      return S.current.uploadCertificateFile;
    }

    if (nationalIdFile == null) {
      return S.current.uploadNationalIdFile;
    }

    if (!declarationAccepted) {
      return S.current.teacherDeclarationAgreement;
    }

    return null;
  }

  List<Map<String, dynamic>> get selectedGradesSubjectsJson {
    return selectedGradesSubjects.map((item) => item.toJson()).toList();
  }

  Future<void> registerTeacher() async {
    emit(TeacherRegistrationLoadingState(currentStep: state.currentStep));

    final request = TeacherRegisterRequestModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      nationality: nationalityController.text.trim(),
      country: countryController.text.trim(),
      city: cityController.text.trim(),
      degree: qualificationController.text.trim(),
      specialization: specializationController.text.trim(),
      institutionName: universityController.text.trim(),
      graduationYear: selectedGraduationYear ?? 0,
      graduationGrade: graduationGrade ?? '',
      phone: phoneController.text.trim(),
      whatsapp: whatsappController.text.trim(),
      hasTeachingExperience: hasTeachingExperience ?? false,
      hasOnlineTeachingExperience: taughtOnlineBefore ?? false,
      availableHoursPerWeek: 7,
      computerSkillLevel: computerUsageLevel ?? '',
      hasLaptop: hasLaptopOrComputer ?? false,
      hasStableInternet: hasStableInternet ?? false,
      hasMicrophone: hasClearMic ?? false,
      hasGoodCamera: hasGoodCamera ?? false,
      introVideoUrl: shortVideoLinkController.text.trim(),
      canProvideDemoSession: canProvideTrialLesson ?? false,
      joiningReason: whyJoinBananController.text.trim(),
      weakStudentHandling: howHandleWeakStudentController.text.trim(),
      termsAccepted: declarationAccepted,
      curriculum: selectedCurriculumId!,
      teacherAssignments: selectedGradesSubjectsJson,
      cv: cvFile!,
      certificate: certificateFile!,
      identityDocument: nationalIdFile!,
    );

    final result = await teacherRegistrationRepo.registerTeacher(
      request: request,
    );

    result.fold(
      (failure) {
        emit(
          TeacherRegistrationFailureState(
            currentStep: state.currentStep,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          TeacherRegistrationSuccessState(
            currentStep: state.currentStep,
            user: response.user,
            message: S.current.requestAccepted,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nationalityController.dispose();
    countryController.dispose();
    cityController.dispose();
    qualificationController.dispose();
    specializationController.dispose();
    universityController.dispose();
    shortVideoLinkController.dispose();
    whyJoinBananController.dispose();
    howHandleWeakStudentController.dispose();
    graduationYearController.dispose();
    return super.close();
  }
}
