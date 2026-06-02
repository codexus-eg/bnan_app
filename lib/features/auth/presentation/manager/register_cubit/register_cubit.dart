import 'package:bnan_app/features/auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/register_cubit/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo) : super(const RegisterInitial());

  final AuthRepo authRepo;

  static RegisterCubit get(context) => BlocProvider.of(context);

  static const int firstStep = 1;
  static const int lastStep = 5;

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
}
