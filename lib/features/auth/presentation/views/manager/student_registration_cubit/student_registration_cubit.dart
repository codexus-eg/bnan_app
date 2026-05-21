import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegistrationCubit extends Cubit<int> {
  StudentRegistrationCubit() : super(1);

  void nextStep() {
    if (state < 5) emit(state + 1);
  }

  void previousStep() {
    if (state > 1) emit(state - 1);
  }
}