import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetParentChildrenCubit extends Cubit<GetParentChildrenState> {
  GetParentChildrenCubit(this.parentHomeRepo)
    : super(GetParentChildrenInitial());

  final ParentHomeRepo parentHomeRepo;

  Future<void> getParentChildren() async {
    emit(GetParentChildrenLoading());
    final result = await parentHomeRepo.getParentChildren();
    if (isClosed) return;

    result.fold(
      (failure) => emit(GetParentChildrenFailure(failure.message)),
      (response) => emit(GetParentChildrenSuccess(response.data)),
    );
  }
}
