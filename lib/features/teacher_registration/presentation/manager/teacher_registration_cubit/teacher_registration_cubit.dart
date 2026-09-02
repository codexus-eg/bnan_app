import 'dart:convert';
import 'dart:io';

import 'package:bnan_app/features/teacher_registration/data/models/select_grade_subjects.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_register_request_model.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_terms_model.dart';
import 'package:dartz/dartz.dart';
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
  String? degree;
  DateTime? dateOfBirth;
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
  File? stableInternetProofFile;
  final List<File> experienceCertificateFiles = [];
  final List<String> additionalCurriculumIds = [];

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
  final specializationController = TextEditingController();
  final graduationYearController = TextEditingController();
  final dateOfBirthController = TextEditingController();

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

  void changeStableInternetProof(File file) {
    stableInternetProofFile = file;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeExperienceCertificates(List<File> files) {
    experienceCertificateFiles
      ..clear()
      ..addAll(files.take(10));
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeDegree(String? value) {
    degree = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeDateOfBirth(DateTime value) {
    dateOfBirth = value;
    dateOfBirthController.text = _formatDate(value);
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void changeDeclarationAccepted(bool value) {
    declarationAccepted = value;
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  Future<Either<Failure, TeacherTermsModel>> getTeacherTerms() {
    final repo = teacherRegistrationRepo;
    if (repo is TeacherTermsRepo) {
      return (repo as TeacherTermsRepo).getTeacherTerms();
    }
    return Future.value(Left(Failure(message: S.current.unexpectedError)));
  }

  String? validateEvaluationStep() {
    if (canProvideTrialLesson == null) {
      return S.current.pleaseAnswerAllQuestions;
    }

    final videoError = validateIntroVideoUrl();
    if (videoError != null) return videoError;

    if (whyJoinBananController.text.trim().isEmpty) {
      return S.current.fieldIsRequired(S.current.whyJoinBananAcademy);
    }

    if (howHandleWeakStudentController.text.trim().isEmpty) {
      return S.current.fieldIsRequired(S.current.howHandleWeakStudent);
    }

    return null;
  }

  String? validateIntroVideoUrl() {
    final value = shortVideoLinkController.text.trim();
    if (value.isEmpty) {
      return S.current.fieldIsRequired(S.current.shortVideoLink);
    }

    final uri = Uri.tryParse(value);
    final isWebUrl =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return isWebUrl ? null : S.current.invalidLink;
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
    additionalCurriculumIds.remove(id);
    emit(TeacherRegistrationDataChanged(currentStep: state.currentStep));
  }

  void toggleAdditionalCurriculum(String id) {
    if (id == selectedCurriculumId) return;
    additionalCurriculumIds.contains(id)
        ? additionalCurriculumIds.remove(id)
        : additionalCurriculumIds.add(id);
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
    if (additionalCurriculumIds.isEmpty) {
      return S.current.additionalCurriculumsRequired;
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

    if (stableInternetProofFile == null) {
      return S.current.stableInternetProofRequired;
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
    final videoError = validateIntroVideoUrl();
    if (videoError != null) {
      emit(
        TeacherRegistrationFailureState(
          currentStep: state.currentStep,
          errorMessage: videoError,
        ),
      );
      return;
    }

    emit(TeacherRegistrationLoadingState(currentStep: state.currentStep));

    final request = TeacherRegisterRequestModel(
      fields: {
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'nationality': nationalityController.text.trim(),
        'country': countryController.text.trim(),
        'city': cityController.text.trim(),
        'degree': degree,
        'dateOfBirth': _formatDate(dateOfBirth ?? DateTime.now()),
        'specialization': specializationController.text.trim(),
        'graduationYear': selectedGraduationYear,
        'graduationGrade': graduationGrade,
        'phone': phoneController.text.trim(),
        'whatsapp': whatsappController.text.trim(),
        'hasTeachingExperience': hasTeachingExperience.toString(),
        'hasOnlineTeachingExperience': taughtOnlineBefore.toString(),
        'availableHoursPerWeek': 7,
        'computerSkillLevel': computerUsageLevel,
        'hasLaptop': hasLaptopOrComputer.toString(),
        'hasStableInternet': hasStableInternet.toString(),
        'hasMicrophone': hasClearMic.toString(),
        'hasGoodCamera': hasGoodCamera.toString(),
        'introVideoUrl': shortVideoLinkController.text.trim(),
        'canProvideDemoSession': canProvideTrialLesson.toString(),
        'joiningReason': whyJoinBananController.text.trim(),
        'weakStudentHandling': howHandleWeakStudentController.text.trim(),
        'termsAccepted': declarationAccepted.toString(),
        'teacherAssignments': jsonEncode(selectedGradesSubjectsJson),
      },
      curriculum: selectedCurriculumId!,
      additionalCurriculums: additionalCurriculumIds,
      cv: cvFile!,
      certificate: certificateFile!,
      identityDocument: nationalIdFile!,
      stableInternetProof: stableInternetProofFile ?? nationalIdFile!,
      experienceCertificates: experienceCertificateFiles,
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
    specializationController.dispose();
    shortVideoLinkController.dispose();
    whyJoinBananController.dispose();
    howHandleWeakStudentController.dispose();
    graduationYearController.dispose();
    dateOfBirthController.dispose();
    return super.close();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
