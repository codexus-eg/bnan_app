import 'package:bnan_app/features/auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/register_cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo) : super(const RegisterInitial());

  final AuthRepo authRepo;

  static RegisterCubit get(context) => BlocProvider.of(context);

  static const int firstStep = 1;
  static const int lastStep = 5;
  String curriculumId = '';
  String curriculumName = '';
  String packageId = '';
  String packageName = '';
  String packagePrice = '';
  String? selectedCurriculumName;

  final parentFormKey = GlobalKey<FormState>();

  final parentNameController = TextEditingController();
  final parentEmailController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentWhatsappController = TextEditingController();
  final studentPasswordController = TextEditingController();
  final studentNameController = TextEditingController();
  final studentEmailController = TextEditingController();

  String? selectedGradeId;
  String? selectedGradeName;

  List<String> selectedSubjectIds = [];
  void setRegisterFlowArgs(RegisterFlowArgsModel args) {
    curriculumId = args.curriculumId;
    curriculumName = args.curriculumName;
    packageId = args.packageId;
    packageName = args.packageName;
    packagePrice = args.packagePrice;
  }

  void setGrade({required String id, required String name}) {
    selectedGradeId = id;
    selectedGradeName = name;
    selectedSubjectIds.clear();

    emit(RegisterStepChanged(currentStep: state.currentStep));
  }

  void toggleSubject(String subjectId) {
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
    studentPasswordController.dispose();
    studentNameController.dispose();
    studentEmailController.dispose();
    return super.close();
  }
}
