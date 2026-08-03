import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo.dart';
import 'package:bnan_app/features/parent_auth/presentation/manager/parent_register_cubit/parent_register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentRegisterCubit extends Cubit<ParentRegisterState> {
  ParentRegisterCubit(this.parentAuthRepo)
    : super(const ParentRegisterInitial());

  final ParentAuthRepo parentAuthRepo;

  Future<void> registerParent(ParentRegisterRequestModel request) async {
    if (state is ParentRegisterLoading) return;
    emit(const ParentRegisterLoading());

    final result = await parentAuthRepo.registerParent(request);
    result.fold(
      (failure) => emit(ParentRegisterFailure(failure.message)),
      (response) => emit(ParentRegisterSuccess(response)),
    );
  }
}
